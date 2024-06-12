String? CheckUsername(String username) {
  if (username.isEmpty) {
    return "Username cannot be empty";
  } else if (!RegExp(r'^[a-zA-Z0-9_]*$').hasMatch(username)) {
    return "Username can only contain letters, numbers, and underscores";
  } else {
    return null; // Username is valid
  }
}
