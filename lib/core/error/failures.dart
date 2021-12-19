import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List proprites = const <dynamic>[]]) : super();

  //  @override
  // // TODO: implement props
  // List<Object?> get props => [text, number];
}

// general Failures
class ServerFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CachFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
