import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repostiry.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepostiry repostiry;

  GetRandomNumberTrivia(this.repostiry);

  @override
  Future<Either<Failure, NumberTrivia>> call(params) async {
    // TODO: implement call
   return await repostiry.getRandomNumberTrivia();
  }
}

