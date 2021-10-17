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

  QuestionsView({Key? key, required List<Question> questions})
      : super(key: key) {
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
        title: const Text("Questions / Réponses"),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                builder: (context, pair) {
                  print(pair.key.path);
                  return FutureBuilder<String>(
                      future: _imageFirabeseProvider
                          .getImageFromPath(pair.key.path),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasError) {
                          print("error ->" + snapshot.error.toString());
                          return MyError(error: snapshot.error.toString());
                        }
                        if (snapshot.hasData) {
                          return Image.network(snapshot.data!);
                        }
                        return const Loading();
                      });
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child:
                      BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                    builder: (context, pair) => Text(pair.key.question),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => {
                          context
                              .read<QuestionCubit>()
                              .checkAnswer(true, context)
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                          ),
                        ),
                        child: const Text("Vrai"),
                      ),
                      ElevatedButton(
                        onPressed: () => {
                          context
                              .read<QuestionCubit>()
                              .checkAnswer(false, context)
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1),
                          ),
                        ),
                        child: const Text("Faux"),
                      ),
                      BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                        builder: (context, triplet) => ElevatedButton(
                          onPressed: () => {
                            (triplet.secondValue >=
                                    context
                                        .read<QuestionCubit>()
                                        .questions
                                        .length)
                                ? context.read<QuestionCubit>().resetAll()
                                : context
                                    .read<QuestionCubit>()
                                    .changeQuestion(false, context)
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.1)),
                          ),
                          child: (triplet.secondValue >=
                                  context
                                      .read<QuestionCubit>()
                                      .questions
                                      .length)
                              ? const Icon(Icons.restart_alt)
                              : const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                    builder: (context, triplet) => Text(
                        '${triplet.value} / ${context.read<QuestionCubit>().questions.length}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
