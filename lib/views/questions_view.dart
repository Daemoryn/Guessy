import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guessy/cubits/question_cubit.dart';
import 'package:guessy/data/provider/dynamic_theme.dart';
import 'package:guessy/utils/constants.dart';
import 'package:guessy/utils/triplet.dart';
import 'package:guessy/data/model/question.dart';
import 'package:guessy/data/provider/image_provider.dart';
import 'package:guessy/views/my_error.dart';
import 'package:guessy/views/loading.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<DynamicTheme>(context);
    context.read<QuestionCubit>().questions = _questions;

    return Consumer<DynamicTheme>(
      builder: (context, theme, _) => Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                (themeProvider.getDarkMode()) ? Constants.primary_dark : Constants.primary,
                (themeProvider.getDarkMode()) ? Constants.secondary_dark : Constants.secondary,
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
                  height: MediaQuery.of(context).size.height * 0.26,
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
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
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
                  margin: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 30,
                    right: 30,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (themeProvider.getDarkMode()) ? Constants.text_light : Constants.text_dark,
                    borderRadius: const BorderRadius.only(
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
                          onPrimary: (themeProvider.getDarkMode())
                              ? Constants.primary_dark
                              : Constants.primary,
                          textStyle: const TextStyle(fontSize: 20.0),
                          primary: (themeProvider.getDarkMode())
                              ? Constants.secondary_dark
                              : Constants.secondary,
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "True",
                          style: TextStyle(
                              color: (themeProvider.getDarkMode())
                                  ? Constants.text_light
                                  : Constants.text_dark),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () =>
                              {context.read<QuestionCubit>().checkAnswer(false, context)},
                          style: ElevatedButton.styleFrom(
                            onPrimary: (themeProvider.getDarkMode())
                                ? Constants.primary_dark
                                : Constants.primary,
                            textStyle: const TextStyle(fontSize: 20.0),
                            primary: (themeProvider.getDarkMode())
                                ? Constants.secondary_dark
                                : Constants.secondary,
                            fixedSize: const Size(300, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            "False",
                            style: TextStyle(
                                color: (themeProvider.getDarkMode())
                                    ? Constants.text_light
                                    : Constants.text_dark),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                          builder: (context, triplet) => ElevatedButton(
                            onPressed: () => {
                              (triplet.secondValue >=
                                      context.read<QuestionCubit>().questions.length)
                                  ? context.read<QuestionCubit>().resetAll()
                                  : context.read<QuestionCubit>().changeQuestion(false, context)
                            },
                            style: ElevatedButton.styleFrom(
                              onPrimary: (themeProvider.getDarkMode())
                                  ? Constants.primary_dark
                                  : Constants.primary,
                              textStyle: const TextStyle(fontSize: 20.0),
                              primary: (themeProvider.getDarkMode())
                                  ? Constants.secondary_dark
                                  : Constants.secondary,
                              fixedSize: const Size(300, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: (triplet.secondValue >=
                                    context.read<QuestionCubit>().questions.length)
                                ? Icon(
                                    Icons.restart_alt,
                                    color: (themeProvider.getDarkMode())
                                        ? Constants.text_light
                                        : Constants.text_dark,
                                  )
                                : Icon(
                                    Icons.arrow_forward,
                                    color: (themeProvider.getDarkMode())
                                        ? Constants.text_light
                                        : Constants.text_dark,
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 9),
                        child: BlocBuilder<QuestionCubit, Triplet<Question, int, int>>(
                          builder: (context, triplet) => Text(
                            '${triplet.value} / ${context.read<QuestionCubit>().questions.length}',
                            style: TextStyle(
                                color: (themeProvider.getDarkMode())
                                    ? Constants.secondary_dark
                                    : Constants.secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
