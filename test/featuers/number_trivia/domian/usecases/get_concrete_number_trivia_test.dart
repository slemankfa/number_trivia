import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repostiry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mockito/annotations.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepostiry {
  @override
  Future<Either<Failures, NumberTrivia>> getConcreateNumberTrivia(int number);
}

// @GenerateMocks([],
//     customMocks: [MockSpec<MethodChannel>(as: #MockMethodChannel)])
@GenerateMocks([NumberTriviaRepostiry])
void main() {
  // GetConcreteNumberTrivia usecase;
  // MockNumberTriviaRepository? mockNumberTriviaRepostiry;
  // setUp(() {
  //   mockNumberTriviaRepostiry = MockNumberTriviaRepository();
  //   usecase = GetConcreteNumberTrivia(mockNumberTriviaRepostiry!);
  // });

  const tNumber = 1;
  const NumberTrivia tNumberTrivia = NumberTrivia(text: "test", number: 1);
  test("shouid get trivia for the number form the repositery", () async {
    var mockNumberTriviaRepostiry = MockNumberTriviaRepository();
    GetConcreteNumberTrivia usecase =
        GetConcreteNumberTrivia(mockNumberTriviaRepostiry);
// arange
    when(mockNumberTriviaRepostiry.getConcreateNumberTrivia(1))
        .thenAnswer((_) async => const Right(tNumberTrivia));
// act
    final result = await usecase.excuate(number: tNumber);
// assert
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepostiry.getConcreateNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepostiry);
  });
}
