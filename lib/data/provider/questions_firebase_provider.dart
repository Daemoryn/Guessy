import 'package:guessy/utils/constants.dart';
import 'package:guessy/data/model/question.dart';
import 'package:guessy/data/repositories/questions_repositories.dart';

class QuestionsFirebaseProvider {
  final QuestionsRepository _repository = QuestionsRepository();

  Future<List<Question>> getAllQuestions() async {
    return await _repository.getAllQuestions().then(
            (value) => value.docs.map((e) => Question.fromJson(e.data() as Map<String, dynamic>)).toList());
  }

  Future<List<Question>> getQuestionsFromTheme(String theme) async {
    if (theme == Constants.general_theme) {
      return getAllQuestions();
    }
    return await _repository.getQuestionsFromTheme(theme).then(
            (value) => value.docs.map((e) => Question.fromJson(e.data() as Map<String, dynamic>)).toList());
  }

  Future<List<String>> getAllTheme() async {
    return await _repository.getAllQuestions().then((value) => value.docs
        .map((e) => Question.fromJson(e.data() as Map<String, dynamic>).theme)
        .toList()
        .toSet()
        .toList());
  }

  Future<void> addQuestion(Question question) async {
    await _repository.addQuestion(question.toJson());
  }
}