import 'dart:async';

mixin Validator {
  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@") && email.contains(".com") && !(email.contains(" ")))
      sink.add(email);
    else
      sink.addError("Email is not valid");
  });
  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8)
      sink.add(password);
    else
      sink.addError("Password must be more than 8 characters");
  });
}
