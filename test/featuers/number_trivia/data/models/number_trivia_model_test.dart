import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_tirvia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtuers/fixtuers_readers.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test("Shouid be a subclass of NumberTrivia Entity ", () {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test("should return a valid model when the JSON number is an integer",
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture("trivia.json"));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
    //------

    test(
        "should return a valid model when the JSON number is regareded as a double",
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture("trivia_double.json"));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group("toJson", () {
    test('should return a Json map', () {
      // arrange
      // we already have it up in  tNumberTriviaModel
      // act
      final expectedMap = {
        "text": "Test Text",
        "number": 1,
      };
      final result = tNumberTriviaModel.toJson();
      // assert
      expect(result, expectedMap);
    });
  });
}
