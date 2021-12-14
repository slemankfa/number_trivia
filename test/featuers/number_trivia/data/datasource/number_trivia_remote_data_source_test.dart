import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_tirvia_model.dart';
import '../../../../fixtuers/fixtuers_readers.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;
  final tNumber = 1;

  mockHttpClient = MockHttpClient();
  dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

  void setUpMockHttpSuccess200() {
    when(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'})).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockRandomHttpSuccess200() {
    when(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
        headers: {'Content-Type': 'application/json'})).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpFailure404() {
    when(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'})).thenAnswer(
      (_) async => http.Response("Something went wrong!", 404),
    );
  }

  void setUpMockRandomHttpFailure404() {
    when(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
        headers: {'Content-Type': 'application/json'})).thenAnswer(
      (_) async => http.Response("Something went wrong!", 404),
    );
  }

  group("getConcreteNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));
    test(
        'should preform a GET request on a URL with number being the endpoint and with application/json header',
        () {
      //arrange
      setUpMockHttpSuccess200();
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ));
    });
    //---

    test("should return NumberTrivia when the response code is 200 (success)",
        () async {
      //arrange
      setUpMockHttpSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, tNumberTriviaModel);
    });

    //------

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));
    test(
        'should preform a GET request on a URL with number being the endpoint and with application/json header',
        () {
      //arrange
      setUpMockRandomHttpSuccess200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ));
    });
    //---

    test("should return NumberTrivia when the response code is 200 (success)",
        () async {
      //arrange
      setUpMockRandomHttpSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, tNumberTriviaModel);
    });

    //------

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
     setUpMockRandomHttpFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
