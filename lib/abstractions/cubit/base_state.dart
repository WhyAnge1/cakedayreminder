import 'package:cakeday_reminder/abstractions/base_error.dart';

abstract class BaseState {}

class InitialState extends BaseState {
  InitialState();
}

class LoadingState extends BaseState {}

class SuccessDataState<T> extends BaseState {
  final T data;

  SuccessDataState(
    this.data,
  );
}

class SuccessState extends BaseState {}

class FailureState<T extends BaseError> extends BaseState {
  final T error;
  FailureState(
    this.error,
  );
}
