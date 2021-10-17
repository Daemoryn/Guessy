import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:guessy/utils/triplet.dart';
import 'package:guessy/data/model/question.dart';

class QuestionCubit extends Cubit<Triplet<Question, int, int>> {
  //Une question par défaut car quelques fois le bloc cubit est appelé alors que la requête n'est pas termiéne
  List<Question> _questions = [
    new Question("Paris est-elle la capitale de la France ?",
        "images/tour-eiffel-paris.jpg", "Géographie",true)
  ];
  var _nbgoodanswer = 0;
  var _nbquestion = 0;

  QuestionCubit() : super(new Triplet(new Question("", "path","theme", false), 0, 0)){
    _sendQuestion();
  }


  set questions(List<Question> value) {
    _questions = value;
    print(questions.length);
    _sendQuestion();
  }

  void resetAll() {
    _nbquestion = 0;
    _nbgoodanswer = 0;
    _sendQuestion();
  }

  void checkAnswer(bool answer, BuildContext context) {
    if (_nbquestion < _questions.length) {
      var flag = (answer == _questions[_nbquestion].correctAnswer);
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text(flag
              ? "Vous avez trouvé une bonne réponse!"
              : "C'est dommage ..."),
          duration: Duration(milliseconds: 500)));
      changeQuestion(flag, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content:
          Text('Vous avez terminé le jeu avec un score de $_nbgoodanswer!'),
          duration: Duration(milliseconds: 500)));
    }
  }

  void changeQuestion(bool flagreceived, BuildContext context) {
    if (flagreceived) {
      _nbgoodanswer += 1;
      _nbquestion += 1;
      if (_nbquestion >= _questions.length) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content: Text(
                'Vous avez terminé le jeu avec un score de $_nbgoodanswer!'),
            duration: Duration(milliseconds: 500)));
      }
      _sendQuestion();
    } else {
      _nbquestion += 1;
      if (_nbquestion >= _questions.length) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content:
          Text('Vous avez terminé le jeu avec un score de $_nbgoodanswer!'),
          duration: Duration(milliseconds: 500),
        ));
      }
      _sendQuestion();
    }
  }

  void _sendQuestion() {
    print(_questions.length);
    if (_nbquestion < _questions.length) {
      emit(new Triplet(_questions[_nbquestion], _nbgoodanswer, _nbquestion));
    } else {
      emit(new Triplet(questions.last, _nbgoodanswer, _nbquestion));
    }
  }

  List<Question> get questions => _questions;

  get nbgoodanswer => _nbgoodanswer;

  get nbquestion => _nbquestion;
}