import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepostiry {
  // Failures in the left side when errors happend
  Future<Either<Failures, NumberTrivia>> getConcreateNumberTrivia(int number);
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();
}
