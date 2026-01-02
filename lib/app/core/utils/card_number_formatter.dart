import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;
      if (index % 4 == 0 && inputData.length != index) {
        buffer.write(
            "  "); // Double space for wider visual separation as requested, or single?
        // User said "separado de 4 en 4". Usually single space. Image shows wide spacing.
        // Let's stick to single space for standard behavior unless "  " is safer.
        // Actually, let's look at the implementation.
        // Standard is single space.
      }
    }

    // However, the standard logical implementation is:
    // 1. Remove non-digits
    // 2. Chunk into 4s
    // 3. Join with space

    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 16 digits
    if (text.length > 16) {
      text = text.substring(0, 16);
    }

    var newText = "";
    for (int i = 0; i < text.length; i++) {
      if (i != 0 && i % 4 == 0) {
        newText += " ";
      }
      newText += text[i];
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static String format(String text) {
    String cleanText = text.replaceAll(RegExp(r'\D'), '');
    var newText = "";
    for (int i = 0; i < cleanText.length; i++) {
      if (i != 0 && i % 4 == 0) {
        newText += " ";
      }
      newText += cleanText[i];
    }
    return newText;
  }
}
