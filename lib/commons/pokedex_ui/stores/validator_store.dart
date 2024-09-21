import 'package:mobx/mobx.dart';

class ValidatorStore<T> {
  Observable<T> value;

  ValidatorStore(T initialValue) : value = Observable(initialValue);

  void updateValue(T newValue) {
    value.value = newValue;
  }
}
