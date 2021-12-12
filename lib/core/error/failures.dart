import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  const Failures([List proprites = const <dynamic>[]]) : super();

  //  @override
  // // TODO: implement props
  // List<Object?> get props => [text, number];
}

// general Failures
class ServerFailure extends Failures {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CachFailure extends Failures {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
