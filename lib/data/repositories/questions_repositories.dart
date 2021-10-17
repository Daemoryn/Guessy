import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guessy/Utils/constants.dart';

class QuestionsRepository {
  final _questionsdb =
  FirebaseFirestore.instance.collection(Constants.questions_reference);

  Future<QuerySnapshot> getAllQuestions() {
    return _questionsdb.get();
  }

  Future<QuerySnapshot> getQuestionsFromTheme(String theme){
    return _questionsdb.where(Constants.theme_field,isEqualTo: theme).get();
  }

  Future<DocumentReference> addQuestion(Map<String,dynamic> question){
    return _questionsdb.add(question);
  }
}