import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia =
      MockGetConcreteNumberTrivia();
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia =
      MockGetRandomNumberTrivia();
  MockInputConverter mockInputConverter = MockInputConverter();
  NumberTriviaBloc bloc = NumberTriviaBloc(
      concreate: mockGetConcreteNumberTrivia,
      inputConverter: mockInputConverter,
      random: mockGetRandomNumberTrivia);

  test("initailState Should be Empty ", () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group("GetTriviaForConcreteNumber", () {
    const tNumber = "1";
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.stringToUnsignedInteger(tNumber))
            .thenReturn(const Right(tNumberParsed));
    test(
        "Should call the InputConverter to valdiate and convert the string to unsigned integer",
        () async {
//arrange
      setUpMockInputConverterSuccess();
// act
// ignore: prefer_const_constructors
      bloc.add(GetTriviaForConcreteNumber(tNumber));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(tNumber));

//assert
      verify(() => mockInputConverter.stringToUnsignedInteger(tNumber));
    });

    test("Should emit [ERROR] state when the input is invalid", () {
      //arrange
      when(() => mockInputConverter.stringToUnsignedInteger(tNumber))
          .thenReturn(Left(InvalidInputFailure()));

      // assert later
      // possible that the added event is faster than emit
      final expected = [
        // bloc.stream.asBroadcastStream(),
        Empty(),
        const ErrorState(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumber));
    });

    test('should get data from the concrete use case', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(() =>
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumber));
      await untilCalled(() =>
          mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      //assert
      verify(() =>
          mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      setUpMockInputConverterSuccess();
      when(() =>
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.stream.cast(), emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumber));
    });

    test('should emit [Loading, Error State] when getting data fails', () {
      // arrange
      setUpMockInputConverterSuccess();
      when(() =>
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const ErrorState(errorMessage: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream.cast(), emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumber));
    });

    test(
        'should emit [Loading, Error State] with a propper message for the error when getting data fails',
        () {
      // arrange
      setUpMockInputConverterSuccess();
      when(() =>
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const ErrorState(errorMessage: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream.cast(), emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumber));
    });
  });

  group("GetTriviaForRandomNumber", () {
    const tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    test('should get data from the random use case', () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(() => mockGetRandomNumberTrivia(NoParams())); //assert
      verify(() => mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(() => mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.stream.cast(), emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error State] when getting data fails', () {
      // arrange
      when(() => mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const ErrorState(errorMessage: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream.cast(), emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error State] with a propper message for the error when getting data fails',
        () {
      // arrange
      when(() => mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const ErrorState(errorMessage: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream.cast(), emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
