import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repostiry.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepostiry repostiry;

  GetConcreteNumberTrivia(this.repostiry);
//  callable classes
  @override
  Future<Either<Failures, NumberTrivia>> call(Params params) async {
    return await repostiry.getConcreateNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});
  @override
  // TODO: implement props
  List<Object?> get props => [number];
}
