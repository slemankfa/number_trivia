import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repostiry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepostiry {
  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();
}

// @GenerateMocks([],
//     customMocks: [MockSpec<MethodChannel>(as: #MockMethodChannel)])

@GenerateMocks([MockNumberTriviaRepository])
void main() {
  // GetConcreteNumberTrivia usecase;
  // MockNumberTriviaRepository? mockNumberTriviaRepostiry;
  // setUp(() {
  //   mockNumberTriviaRepostiry = MockNumberTriviaRepository();
  //   usecase = GetConcreteNumberTrivia(mockNumberTriviaRepostiry!);
  // });

  const NumberTrivia tNumberTrivia = NumberTrivia(text: "test", number: 1);
  test("shouid get trivia  form the repositery", () async {
    var mockNumberTriviaRepostiry = MockMockNumberTriviaRepository();
    GetRandomNumberTrivia usecase =
        GetRandomNumberTrivia(mockNumberTriviaRepostiry);
// arange
    when(mockNumberTriviaRepostiry.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));
// act
    final result = await usecase(NoParams());
    // final result = await usecase.excuate(number: tNumber);
// assert
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepostiry.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepostiry);
  });
}
