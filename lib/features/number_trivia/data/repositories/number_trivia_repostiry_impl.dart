import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_tirvia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repostiry.dart';

typedef Future<NumberTriviaModel> _ConcreateOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepostiry {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failures, NumberTrivia>> getConcreateNumberTrivia(
      int number) async {
    // TODO: implement getConcreateNumberTrivia

    return _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia() async {
    // TODO: implement getRandomNumberTrivia
    // throw UnimplementedError();
    return _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failures, NumberTrivia>> _getTrivia(
      _ConcreateOrRandomChooser getconcreateOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getconcreateOrRandom();
        await localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CachException {
        return Left(CachFailure());
      }
    }
  }
}
