import 'dart:async';
import 'validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geocoder/geocoder.dart';

class Bloc extends Object with Validator implements BaseBloc {
  final _nameController = BehaviorSubject<String>();
  final _ageController = BehaviorSubject<int>();
  final _weightController = BehaviorSubject<int>();

  final _phoneController = BehaviorSubject<int>();
  final _locationController = BehaviorSubject<String>();

  Function(String) get nameChanged => _nameController.sink.add;
  Function(int) get phoneChanged => _phoneController.sink.add;
  Function(int) get ageChanged => _ageController.sink.add;
  Function(int) get weightChanged => _weightController.sink.add;
  Function(String) get locationChanged => _locationController.sink.add;

  Stream<String> get name => _nameController.stream.transform(nameValidator);
  Stream<String> get location =>
      _locationController.stream.transform(locationValidator);
  Stream<String> get weight =>
      _weightController.stream.transform(weightValidator);
  Stream<String> get phoneNo =>
      _phoneController.stream.transform(phoneValidator);
  Stream<String> get age => _ageController.stream.transform(ageValidator);
  Stream<bool> get canSubmit => Observable.combineLatest5(
      name, age, weight, phoneNo, location, (n, a, w, p, l) => true);

  @override
  void dispose() {
    _nameController?.close();
    _ageController?.close();
    _weightController?.close();
    _phoneController?.close();
    _locationController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
