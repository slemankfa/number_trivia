import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter? inputConverter;

  NumberTriviaBloc(
      {required GetConcreteNumberTrivia concreate,
      required this.inputConverter,
      required GetRandomNumberTrivia random})
      : getConcreteNumberTrivia = concreate,
        getRandomNumberTrivia = random,
        super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter!.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failures) async* {
        yield (const ErrorState(errorMessage: INVALID_INPUT_FAILURE_MESSAGE));
      }, (integer) async* {
        yield Loading();
        final faluierOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        yield* _eitherLoadedOrErrorState(faluierOrTrivia);
      });
    } else if (event is GetRandomNumberTrivia) {
      yield Loading();
      final faluierOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(faluierOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> faluierOrTrivia) async* {
    yield faluierOrTrivia.fold(
        (failures) => ErrorState(errorMessage: _mapFailureToMessage(failures)),
        (numberTrivia) => Loaded(trivia: numberTrivia));
  }

  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CachFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
