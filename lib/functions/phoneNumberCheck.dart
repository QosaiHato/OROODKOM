bool validatePhoneNumber(String phoneNumber) {
  // Remove leading '+' character if present
  if (phoneNumber.startsWith('+')) {
    phoneNumber = phoneNumber.substring(1);
  }



  // Remove '962' from the beginning of the phone number
  phoneNumber = phoneNumber.substring(3);

  // Check if the remaining phone number starts with '79', '77', or '78'
  if (!phoneNumber.startsWith('79') &&
      !phoneNumber.startsWith('77') &&
      !phoneNumber.startsWith('78')) {
    return false;
  }

  // Remove the first two digits (79, 77, or 78)
  phoneNumber = phoneNumber.substring(2);

  // Check if the remaining characters are all digits and the total length is 9
  if (phoneNumber.length != 9 || !phoneNumber.contains(RegExp(r'^[0-9]+$'))) {
    return false;
  }

  return true;
}
