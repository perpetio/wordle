import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle/core/const/text_constants.dart';
import 'package:wordle/core/data/enums/keyboard_keys.dart';
import 'package:wordle/core/data/enums/message_types.dart';
import 'package:wordle/core/presentation/home/cubit/home_cubit.dart';

class DataSingleton {
  static final DataSingleton _dataSingleton = DataSingleton._internal();
  Set<String> allWords = {};
  String secretWord = "";
  List<String> gridData = [""];
  Map<String, Color> coloredLetters = {};
  int currentWordIndex = 0;

  factory DataSingleton() {
    return _dataSingleton;
  }

  DataSingleton._internal(){
    if (secretWord.isEmpty) {
      createWord();
    }
  }

  bool setLetter(KeyboardKeys key) {
    if (KeyboardKeys.enter.name == key.name) {
      return false;
    }
    if (gridData.length <= currentWordIndex) {
      gridData.add("");
    }
    if (gridData[currentWordIndex].length < 5) {
      gridData[currentWordIndex] = gridData[currentWordIndex] + key.name;
      return true;
    }
    return false;
  }

  void removeLetter() {
    if (gridData.length <= currentWordIndex) {
      gridData.add("");
    }
    int wordLength = gridData[currentWordIndex].length;
    if (wordLength > 0) {
      gridData[currentWordIndex] =
          gridData[currentWordIndex].substring(0, wordLength - 1);
    }
  }

  HomeState submitWord() {
    if (gridData.length <= currentWordIndex) {
      gridData.add("");
    }
    if (currentWordIndex < 5) {
      if (gridData[currentWordIndex].length == 5) {
        if (gridData[currentWordIndex] == secretWord) {
          nextWord();
          return WinGameState();
        }
        if (allWords.contains(gridData[currentWordIndex])) {
          nextWord();
          return GridUpdateState();
        } else {
          return SnackBarMessage(
              MessageTypes.error, TextConstants.errorWrongWord);
        }
      } else {
        return SnackBarMessage(
            MessageTypes.error, TextConstants.errorWrongWordLength);
      }
    } else {
      return LoseGameState();
    }
  }

  void nextWord() {
    final word = gridData[currentWordIndex];
    word.split("").asMap().map((key, value) {
      if (secretWord[key] == value) {
        //green
        if (coloredLetters.containsKey(value)) {
          coloredLetters.update(value, (value) => Colors.green);
        } else {
          coloredLetters.addAll({value: Colors.green});
        }
      } else if (secretWord.contains(value)) {
        //orange
        if (coloredLetters.containsKey(value)) {
          if(coloredLetters[key]==Colors.black38){
            coloredLetters.update(value, (value) => Colors.orangeAccent);
          }
        } else {
          coloredLetters.addAll({value: Colors.orangeAccent});
        }
      } else {
        //grey
        if (!coloredLetters.containsKey(value)) {
          coloredLetters.addAll({value: Colors.black38});
        }
      }
      return MapEntry(key, value);
    });
    if (currentWordIndex < 5) {
      currentWordIndex++;
    }
  }

  Future<String> createWord() async {
    final words = (await rootBundle.loadString('assets/words.txt')).split("\n");
    var now = DateTime.now();
    var random = Random(now.year * 10000 + now.month * 100 + now.day);
    var index = random.nextInt(words.length);
    secretWord = words[index];
    allWords = words.toSet();
    return secretWord;
  }

  String getLetters() {
    return gridData.join();
  }

  Color getKeyColor(KeyboardKeys myKey) {
    return coloredLetters[myKey.name] ?? Colors.black26;
  }

  void resetData(){
    allWords={};
    secretWord="";
    gridData = [""];
    coloredLetters = {};
    currentWordIndex = 0;
  }
}
