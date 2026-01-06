class CardValidator {
  static bool validateCardNum(String input) {
    if (input.isEmpty) return false;

    // Remove any non-digits
    String inputNum = input.replaceAll(RegExp(r'\D'), '');

    if (inputNum.length < 8) return false; // Basic length check

    int sum = 0;
    int length = inputNum.length;
    for (var i = 0; i < length; i++) {
      // Get digits in reverse order
      int digit = int.parse(inputNum[length - i - 1]);

      // Double every second digit
      if (i % 2 == 1) {
        digit *= 2;
      }

      // Subtract 9 if of two digits
      if (digit > 9) {
        digit -= 9;
      }
      sum += digit;
    }

    return (sum % 10 == 0);
  }

  static String? getCardType(String number) {
    String cleanNum = number.replaceAll(RegExp(r'\D'), '');
    if (cleanNum.startsWith('4')) return 'VISA';
    if (cleanNum.startsWith('5')) return 'Mastercard';
    if (cleanNum.startsWith('3')) return 'American Express';
    return null;
  }
}
