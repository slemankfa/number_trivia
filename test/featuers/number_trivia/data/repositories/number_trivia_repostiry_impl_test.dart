import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';

import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_tirvia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repostiry_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {
//   @override
//   Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
//   @override
//   Future<NumberTriviaModel> getRandomNumberTrivia();
}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {
  // @override
  // Future<NumberTriviaModel> getLastNumberTrivia();
  // @override
  // Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class MockNetworkInfo extends Mock implements NetworkInfo {
  // @override
  // Future<bool> get isConnected;
}

// @GenerateMocks([MockRemoteDataSource, MockLocalDataSource, MockNetworkInfo])
void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  void runTestsOnline(Function body, MockNetworkInfo mockNetworkInfo) {
    group("device is online", () {
      // setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((value) async => true);

      body();
    });
  }

  void runTestsOffline(Function body, MockNetworkInfo mockNetworkInfo) {
    group("device is offline", () {
      // setUp(() {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((value) async => false);

      body();
    });
  }
  // setUp(() {
  //   mockRemoteDataSource = MockRemoteDataSource();
  //   mockLocalDataSource = MockLocalDataSource();
  //   mockNetworkInfo = MockNetworkInfo();
  //   repository = NumberTriviaRepositoryImpl(
  //     remoteDataSource: mockRemoteDataSource,
  //     localDataSource: mockLocalDataSource,
  //     networkInfo: mockNetworkInfo,
  //   );
  // });

  group("Get concrete number trivia", () {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: "test trivia");

    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    // test('should check if the device is online', () async {
    //   //arrange
    //   when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //   // act
    //   await repository.getConcreateNumberTrivia(12);
    //   // assert
    //   verify(() => mockNetworkInfo.isConnected);
    // });

    runTestsOnline(() {
      // setUp(() {
      // when(() => mockNetworkInfo.isConnected).thenAnswer((value) async => true);
      // });
      test("should return the data when the call remote data is successfull",
          () async {
        //arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreateNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        // final result =
        await repository.getConcreateNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        // expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          "should return server faluier when the call remote data is unsuccessfull",
          () async {
        //arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        // act
        final result = await repository.getConcreateNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(left(ServerFailure())));
      });
    }, mockNetworkInfo);

    runTestsOffline(() {
      // setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      // });
      test(
          "Shuld retuen last locally chaced data when the chache data is present",
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // ----
        final result = await repository.getConcreateNumberTrivia(tNumber);
        // ----
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      ///////

      test("Shuld retuen CachFailure when there is no chaced data present",
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow((_) async => CachException());
        // ----
        final result = await repository.getConcreateNumberTrivia(tNumber);
        // ----
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CachFailure())));
      });
    }, mockNetworkInfo);
  });

  group("Get random number trivia", () {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: "test trivia");

    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    // test('should check if the device is online', () async {
    //   //arrange
    //   when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //   // act
    //   await repository.getConcreateNumberTrivia(12);
    //   // assert
    //   verify(() => mockNetworkInfo.isConnected);
    // });

    runTestsOnline(() {
      // setUp(() {
      // when(() => mockNetworkInfo.isConnected).thenAnswer((value) async => true);
      // });
      test("should return the data when the call remote data is successfull",
          () async {
        //arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        // final result =
        await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        // expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          "should return server faluier when the call remote data is unsuccessfull",
          () async {
        //arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(left(ServerFailure())));
      });
    }, mockNetworkInfo);

    runTestsOffline(() {
      // setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      // });
      test(
          "Shuld retuen last locally chaced data when the chache data is present",
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // ----
        final result = await repository.getRandomNumberTrivia();
        // ----
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      ///////

      test("Shuld retuen CachFailure when there is no chaced data present",
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow((_) async => CachException());
        // ----
        final result = await repository.getRandomNumberTrivia();
        // ----
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CachFailure())));
      });
    }, mockNetworkInfo);
  });
}
