class Validator {
  static String? emailValidator(String? email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email!);
    if (email.isEmpty) {
      return 'Email is required';
    } else if (!emailValid){
      return 'Please provide a valid email address';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password!.isEmpty) {
      return 'Password is required';
    } else if (password.length < 8){
      return 'Password must be eight characters or more';
    }
    return null;
  }
}
