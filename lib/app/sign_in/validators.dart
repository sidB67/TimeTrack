abstract class StringValidator{
  bool isValid(String value);
}


class NonEmptyStringValidator implements StringValidator{
  @override
  bool isValid(String value){
    return value.isNotEmpty;
  }
}

class EmailandPasswordValidators{
  final StringValidator emailValidator= NonEmptyStringValidator();
  final StringValidator passwordValidator= NonEmptyStringValidator();
  final String invalidEmailErrorText= 'Email cant be empty';
  final String invalidPassErrorText= 'Password cant be empty';
}