import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guessy/cubits/question_cubit.dart';
import 'package:guessy/utils/triplet.dart';
import 'package:guessy/data/model/question.dart';
import 'package:guessy/data/provider/image_provider.dart';
import 'package:guessy/views/my_error.dart';
import 'package:guessy/views/home_page.dart';
import 'package:guessy/views/loading.dart';

class QuestionsView extends StatefulWidget {
  List<Question> _questions = [];

  List<Question> get questions => _questions;

  set questions(List<Question> value) => _questions = value;

  QuestionsView({Key? key, required List<Question> questions}) : super(key: key) {
    _questions = questions;
  }

  @override
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  List<Question> _questions = [];
  final ImageFirebaseProvider _imageFirabeseProvider = ImageFirebaseProvider();

  @override
  void initState() {
    super.initState();
    _questions = widget.questions;
  }

  @override
  Widget build(BuildContext context) {
    context.read<QuestionCubit>().questions = _questions;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFA450),
        title: const Text(
          "Guessy",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.black),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height * 1.1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFFFA450),
              Color(0xFFFF5656),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                child: BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                  builder: (context, pair) {
                    return FutureBuilder<String>(
                      future: _imageFirabeseProvider.getImageFromPath(pair.key.path),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasError) {
                          return MyError(error: snapshot.error.toString());
                        }
                        if (snapshot.hasData) {
                          return Image.network(snapshot.data!);
                        }
                        return const Loading();
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                      builder: (context, pair) => Text(
                        pair.key.question,
                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 26),
                decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => {context.read<QuestionCubit>().checkAnswer(true, context)},
                      style: ElevatedButton.styleFrom(
                        onPrimary: const Color(0xFFFFA450),
                        textStyle: const TextStyle(fontSize: 20.0),
                        primary: const Color(0xFFFF5656),
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        "True",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        onPressed: () => {context.read<QuestionCubit>().checkAnswer(false, context)},
                        style: ElevatedButton.styleFrom(
                          onPrimary: const Color(0xFFFFA450),
                          textStyle: const TextStyle(fontSize: 20.0),
                          primary: const Color(0xFFFF5656),
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          "False",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                        builder: (context, triplet) => ElevatedButton(
                          onPressed: () => {
                            (triplet.secondValue >= context.read<QuestionCubit>().questions.length)
                                ? context.read<QuestionCubit>().resetAll()
                                : context.read<QuestionCubit>().changeQuestion(false, context)
                          },
                          style: ElevatedButton.styleFrom(
                            onPrimary: const Color(0xFFFFA450),
                            textStyle: const TextStyle(fontSize: 20.0),
                            primary: const Color(0xFFFF5656),
                            fixedSize: const Size(300, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child:
                              (triplet.secondValue >= context.read<QuestionCubit>().questions.length)
                                  ? const Icon(Icons.restart_alt, color: Colors.white,)
                                  : const Icon(Icons.arrow_forward, color: Colors.white,),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.015,
                    ),
                    BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                      builder: (context, triplet) => Text(
                          '${triplet.value} / ${context.read<QuestionCubit>().questions.length}'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.012,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
