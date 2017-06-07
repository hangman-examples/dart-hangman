import 'dart:io';

// The phrase to guess
String toGuess = "suck my shorts".toUpperCase();

// Number of guesses you get
int guessesLeft = 5;

List<String> lettersLeft = getAlphabet();
String knownLetters = getGuessAsBlanks(toGuess);

main(List<String> arguments) {
  print("Welcome to Hangman in Dart");

  while(guessesLeft > 0) {
    print(knownLetters);
    print("You have $guessesLeft guesses left");
    print("Letters remaining:");
    print(lettersLeft.toString());

    // Make your selection
    guess(stdin.readLineSync());
  }
  print("You are out of guesses!");

}

List<String> getAlphabet() {
  List<String> letters = [];
  for(int i = 65; i < 65 + 26; i++) {
    letters.add(new String.fromCharCode(i));
  }
  return letters;
}

String getGuessAsBlanks(String toGuess) {
  return toGuess.runes.map((int rune) {
    if(rune != 32) {
      return "_";
    } else {
      return " ";
    }
  }).toList().join(" ");
}

void guess(String letter) {
  int letterCodeUnit = letter.codeUnitAt(0);
  //print("code unit: ${letter.codeUnitAt(0)}");

  if (letter.length != 1) {
    print("Enter exactly one letter please!");
  } else if(!codeUnitIsLetter(letterCodeUnit)) {
    print("Please enter a letter between A and Z!");
  } else {

    String letterUpperCase = letter.toUpperCase();
    bool notGuessedBefore = lettersLeft.contains(letterUpperCase);

    if(notGuessedBefore) {
      lettersLeft.remove(letterUpperCase);
      int indexOfLetter = toGuess.indexOf(letterUpperCase);
      if(indexOfLetter != -1) {
        // Hit
        // Reveal
        List<int> indices = getIndices(letterUpperCase, toGuess);
        for(int index in indices) {
            knownLetters = replaceLetterAtIndex(knownLetters, index, letterUpperCase);
        }
        if(hasWon()) {
          print("Well done! You got it!");
          print(toGuess.toUpperCase());
          exit(0);
        }

      } else {
        // Miss
        guessesLeft--;
        print("Nope. Try again.");
      }


    } else {
      // Already guessed
      print("You've already tried $letterUpperCase");
    }
  }
}

bool codeUnitIsLetter(int codeUnit) {
  bool lowerCaseLetter = codeUnit > 96 && codeUnit <= 96 + 26 ? true : false;
  bool upperCaseLetter = codeUnit > 64 && codeUnit <= 64 + 26 ? true : false;
  return lowerCaseLetter || upperCaseLetter;
}

List<int> getIndices(String needle, String haystack) {
  List<String> letters = haystack.split("");
  List<int> indices = [];
  for(int i = 0; i < letters.length; i++) {
    if(letters[i] == needle) {
      indices.add(i);
    }
  }
  return indices;
}

String replaceLetterAtIndex(String phrase, int index, String letter) {
  if(index >= phrase.length * 2) {
    print("Index out of bounds");
  } else if(letter.length > 1) {
    print("Enter only one letter to replace with");
  } else {
    List<int> codeUnits = phrase.codeUnits.toList();
    codeUnits[index*2] = letter.codeUnitAt(0);

    //convert back to string
    return new String.fromCharCodes(codeUnits);
  }
}

bool hasWon() {
  return !knownLetters.contains("_");
}