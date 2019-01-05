import 'dart:async';
import 'package:geocoder/geocoder.dart';

mixin Validator {
  var nameValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (!name.contains("@"))
      sink.add(name);
    else
      sink.addError("Name is not valid");
  });
  var locationValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (location, sink) async {
    var adresses = await Geocoder.local.findAddressesFromQuery(location);
    adresses.isEmpty ? sink.addError("Location not found") : sink.add(location);
  });
  var ageValidator =
      StreamTransformer<int, String>.fromHandlers(handleData: (age, sink) {
    if (age < 60 && age > 18)
      sink.add(age.toString());
    else
      sink.addError("ohh! You cannot donate blood");
  });
  var weightValidator =
      StreamTransformer<int, String>.fromHandlers(handleData: (weight, sink) {
    if (weight < 200 && weight > 50)
      sink.add(weight.toString());
    else
      sink.addError("ohh! You cannot donate blood");
  });
  var phoneValidator =
      StreamTransformer<int, String>.fromHandlers(handleData: (phone, sink) {
    if (phone.toString().length == 10)
      sink.add(phone.toString());
    else
      sink.addError("ohh! This does not look like a phone no");
  });
}
