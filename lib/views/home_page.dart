import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guessy/cubits/dropdown_cubit.dart';
import 'package:guessy/cubits/game_on_cubit.dart';
import 'package:guessy/cubits/question_cubit.dart';
import 'package:guessy/data/model/question.dart';
import 'package:guessy/data/provider/questions_firebase_provider.dart';
import 'package:guessy/utils/constants.dart';
import 'package:guessy/views/questions_view.dart';
import 'package:provider/provider.dart';

import 'add_question_view.dart';
import 'loading.dart';
import 'my_error.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuestionsFirebaseProvider _questionsFirebaseProvider = QuestionsFirebaseProvider();
  late String dropdownValue;
  late bool gameOn;

  @override
  void initState() {
    dropdownValue = 'Général';
    gameOn = false;
    super.initState();
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider<GameOnCubit>(
        create: (context) => GameOnCubit(),
        child: Provider<DropdownCubit>(
          create: (context) => DropdownCubit(Constants.general_theme),
          child: BlocBuilder<GameOnCubit, bool>(
            builder: (context, stateGameOn) {
              return (stateGameOn)
                  ? goToGame()
                  : Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 45),
                                child: Image.asset(
                                  'assets/logo_transparent.png',
                                  width: MediaQuery.of(context).size.width * 0.30,
                                  height: MediaQuery.of(context).size.width * 0.30,
                                  color: Colors.black,
                                ),
                              ),
                              const Center(
                                child: Text(
                                  'Welcome on Guessy!',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              FutureBuilder<List<String>>(
                                  future: _questionsFirebaseProvider.getAllTheme(),
                                  builder:
                                      (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                                    if (snapshot.hasError) {
                                      return MyError(error: snapshot.error.toString());
                                    }
                                    if (snapshot.hasData) {
                                      List<String> theme = [Constants.general_theme];
                                      theme.addAll(snapshot.data!);
                                      return BlocBuilder<DropdownCubit, String>(
                                          builder: (context, stateDropDown) {
                                        return SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          child: DropdownButton<String>(
                                            value: stateDropDown,
                                            icon: const Icon(
                                              Icons.arrow_downward,
                                              color: Colors.black,
                                            ),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: const TextStyle(color: Colors.black),
                                            underline: Container(height: 2, color: Colors.black),
                                            onChanged: (String? newValue) {
                                              context
                                                  .read<DropdownCubit>()
                                                  .changeDropdownValue(newValue!);
                                            },
                                            isExpanded: true,
                                            items: theme
                                                .map((e) => DropdownMenuItem<String>(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: const TextStyle(color: Colors.black),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        );
                                      });
                                    }
                                    return const Loading();
                                  }),
                              Positioned(
                                bottom: 2,
                                child: Flexible(
                                  child: Align(
                                    // alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40.0),
                                          topRight: Radius.circular(40.0),
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(
                                        top: 194,
                                      ),
                                      padding: const EdgeInsets.only(top: 26,
                                      bottom: 26),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 15),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => const AddQuestion()),
                                                  );
                                                },
                                                child: const Text(
                                                  "Add question",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  onPrimary: const Color(0xFFFFA450),
                                                  textStyle: const TextStyle(fontSize: 20.0),
                                                  primary: const Color(0xFFFF5656),
                                                  fixedSize: const Size(300, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                context.read<GameOnCubit>().changeState();
                                              },
                                              child: const Text(
                                                "Play",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                onPrimary: const Color(0xFFFFA450),
                                                textStyle: const TextStyle(fontSize: 20.0),
                                                primary: const Color(0xFFFF5656),
                                                fixedSize: const Size(300, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget goToGame() {
    return BlocBuilder<DropdownCubit, String>(builder: (context, state) {
      return FutureBuilder(
          future: _questionsFirebaseProvider.getQuestionsFromTheme(state),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return MyError(error: snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return Provider<QuestionCubit>(
                create: (_) => QuestionCubit(),
                child: QuestionsView(questions: snapshot.data! as List<Question>),
              );
            }
            return const Loading();
          });
    });
  }
}
