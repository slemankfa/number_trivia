import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repostiry.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepostiry repostiry;

  GetConcreteNumberTrivia(this.repostiry);

  Future<Either<Failures, NumberTrivia>> excuate({required int number}) async {
    return await repostiry.getConcreateNumberTrivia(number);
  }
}
