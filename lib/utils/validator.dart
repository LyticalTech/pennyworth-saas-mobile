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
    RegExp regExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (password!.isEmpty) {
      return 'Password is required';
    } else if (regExp.hasMatch(password)){
      return 'Password must be eight characters or more, contain at least one upper case, one lower case, one digit, and one special character';
    }
    return null;
  }

  static String? textValidator(String? name) {
    RegExp regExp = RegExp(r'^[A-Za-z]+\s[A-Za-z]$');
    if (name!.isEmpty) {
      return 'First name is required';
    } else if (regExp.hasMatch(name)){
      return 'You must provide your name in full';
    }
    return null;
  }

  static String? firstNameValidator(String? name) {
    RegExp regExp = RegExp(r'^[A-Za-z]+\s[A-Za-z]$');
    if (name!.isEmpty) {
      return 'First name is required';
    } else if (regExp.hasMatch(name)){
      return 'You must provide your name in full';
    }
    return null;
  }

  static String? lastNameValidator(String? name) {
    RegExp regExp = RegExp(r'^[A-Za-z]+\s[A-Za-z]$');
    if (name!.isEmpty) {
      return 'Last name is required';
    } else if (regExp.hasMatch(name)){
      return 'You must provide your name in full';
    }
    return null;
  }

  static String? phoneValidator(String? phone) {
    RegExp regExp = RegExp(r'^0[0-9]+.{811,}$');
    if (phone!.isEmpty) {
      return 'Phone Number is required';
    } else if (regExp.hasMatch(phone)){
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? numberValidator(String? number) {
    RegExp regExp = RegExp(r'^0[0-9]$');
    if (number!.isEmpty) {
      return 'Field is required!';
    } else if (regExp.hasMatch(number)){
      return 'Enter valid numbers';
    }
    return null;
  }
}
