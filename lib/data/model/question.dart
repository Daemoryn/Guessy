class Question {
  late String question;
  late String path;
  late String theme;
  late bool correctAnswer;

  Question(this.question, this.path, this.theme,this.correctAnswer);

  Question.fromJson(Map<String, dynamic> json) {
    question = (json['question'] != null) ? json['question'] : "";
    path = (json['path'] != null) ? json['path'] : "";
    theme = (json['theme']!=null) ? json['theme'] :"";
    correctAnswer =
    (json['correctAnswer'] != null) ? json['correctAnswer'] : false;
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'path': path,
      'theme' : theme,
      'correctAnswer': correctAnswer,
    };
  }
}