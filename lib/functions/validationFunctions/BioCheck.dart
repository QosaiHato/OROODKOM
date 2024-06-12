String? CheckBio(String bio) {
  if (bio.isEmpty) {
    return "Bio cannot be empty";
  } else if (bio.length > 100) {
    return "Bio must be less than or equal to 100 characters";
  } else if (bio.contains(RegExp(r'[0-9]'))) {
    return "Bio cannot contain numbers";
  } else {
    return null; // Bio is valid
  }
}
