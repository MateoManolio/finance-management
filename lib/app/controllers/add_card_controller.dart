import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../domain/entity/credit_card.dart';
import '../domain/usecases/save_card_usecase.dart';
import 'cards_controller.dart';
import '../core/utils/card_validator.dart';

class AddCardController extends GetxController {
  final cardNumberController = TextEditingController();
  final holderNameController = TextEditingController();
  final expiryDateController = TextEditingController();
  final closingDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final bankNameController = TextEditingController();

  final Rx<Color> cardColor = Colors.blueAccent.obs;
  final RxString cardIssuer = ''.obs; // Visa, Mastercard, etc.
  final Rx<CardType> selectedCardType = CardType.credit.obs; // Credit vs Debit

  // Real-time preview observables
  final RxString cardNumberPreview = '0000 0000 0000 0000'.obs;
  final RxString holderNamePreview = 'NOMBRE APELLIDO'.obs;
  final RxString expiryPreview = 'MM/AA'.obs;

  @override
  void onInit() {
    super.onInit();

    // Listeners for real-time updates
    cardNumberController.addListener(() {
      final text = cardNumberController.text;
      cardNumberPreview.value = text.isEmpty ? '0000 0000 0000 0000' : text;

      // Auto-detect type instantly (cheap operation)
      final type = CardValidator.getCardType(text);
      if (type != null) {
        cardIssuer.value = type;
      } else {
        cardIssuer.value = '';
      }
    });

    holderNameController.addListener(() {
      final text = holderNameController.text;
      holderNamePreview.value =
          text.isEmpty ? 'NOMBRE APELLIDO' : text.toUpperCase();
    });

    expiryDateController.addListener(() {
      final text = expiryDateController.text;
      expiryPreview.value = text.isEmpty ? 'MM/AA' : text;
    });
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    holderNameController.dispose();
    expiryDateController.dispose();
    closingDateController.dispose();
    dueDateController.dispose();
    super.onClose();
  }

  void saveCard() async {
    final cleanNum = cardNumberController.text.replaceAll(' ', '');
    // Validate on Save
    if (!CardValidator.validateCardNum(cleanNum)) {
      Get.snackbar('Error', 'Invalid Card Number',
          backgroundColor: Colors.red.withValues(alpha: 0.5),
          colorText: Colors.white);
      return;
    }

    final isCredit = selectedCardType.value == CardType.credit;

    if (holderNameController.text.isEmpty ||
        expiryDateController.text.isEmpty ||
        (isCredit &&
            (closingDateController.text.isEmpty ||
                dueDateController.text.isEmpty))) {
      Get.snackbar('Error', 'Por favor completa todos los campos requeridos',
          backgroundColor: Colors.red.withValues(alpha: 0.5),
          colorText: Colors.white);
      return;
    }

    final card = CreditCard(
      cardNumber: cleanNum,
      holderName: holderNameController.text,
      expiryDate: expiryDateController.text,
      closingDay: int.tryParse(closingDateController.text) ?? 1,
      dueDay: int.tryParse(dueDateController.text) ?? 10,
      color: cardColor.value,
      type: selectedCardType.value,
      bankName: bankNameController.text,
    );

    try {
      final saveCardUseCase = Get.find<SaveCardUseCase>();
      await saveCardUseCase(card);
      if (Get.isRegistered<CardsController>()) {
        Get.find<CardsController>().loadCards();
      }
      Get.back();
      Get.snackbar('Success', 'Card saved successfully',
          backgroundColor: Colors.green.withValues(alpha: 0.5),
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save card: $e',
          backgroundColor: Colors.red.withValues(alpha: 0.5),
          colorText: Colors.white);
    }
  }
}
