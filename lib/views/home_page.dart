import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guessy/cubits/dropdown_cubit.dart';
import 'package:guessy/cubits/game_on_cubit.dart';
import 'package:guessy/cubits/question_cubit.dart';
import 'package:guessy/data/model/question.dart';
import 'package:guessy/data/provider/dynamic_theme.dart';
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
    dropdownValue = 'All';
    gameOn = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);

    return Consumer<DynamicTheme>(
      builder: (context, theme, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor:
                (themeProvider.getDarkMode()) ? Constants.primary_dark : Constants.primary,
            centerTitle: true,
            title: const Text(
              "Guessy",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
            ),
            leading: IconButton(
              icon: const FaIcon(FontAwesomeIcons.home, color: Colors.black),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            actions: [
              Switch(
                activeColor: Colors.black,
                inactiveThumbColor: Colors.white,
                activeTrackColor: Colors.black54,
                inactiveTrackColor: Colors.white54,
                value: themeProvider.getDarkMode(),
                onChanged: (value) {
                  setState(() {
                    themeProvider.changeDarkMode(value);
                    if (value == true) {
                      print("passage en darkmode");
                    } else {
                      print("passage en lightmode");
                    }
                  });
                },
              ),
            ],
          ),
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
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomLeft,
                                colors: [
                                  (themeProvider.getDarkMode())
                                      ? Constants.primary_dark
                                      : Constants.primary,
                                  (themeProvider.getDarkMode())
                                      ? Constants.secondary_dark
                                      : Constants.secondary,
                                ],
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 25),
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
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<String>> snapshot) {
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
                                                underline:
                                                    Container(height: 2, color: Colors.black),
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
                                                            style: const TextStyle(
                                                                color: Colors.black),
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                            );
                                          });
                                        }
                                        return const Loading();
                                      }),
                                  Flexible(
                                    child: Align(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: (themeProvider.getDarkMode())
                                              ? Constants.text_light
                                              : Constants.text_dark,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(40.0),
                                            topRight: Radius.circular(40.0),
                                          ),
                                        ),
                                        margin: const EdgeInsets.only(
                                          top: 120,
                                          left: 30,
                                          right: 30,
                                        ),
                                        padding: const EdgeInsets.only(
                                          top: 26,
                                          bottom: 120,
                                          left: 30,
                                          right: 30,
                                        ),
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
                                                          builder: (context) =>
                                                              const AddQuestion()),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Add question",
                                                    style: TextStyle(
                                                        color: (themeProvider.getDarkMode())
                                                            ? Constants.text_light
                                                            : Constants.text_dark),
                                                  ),
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
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  context.read<GameOnCubit>().changeState();
                                                },
                                                child: Text(
                                                  "Play",
                                                  style: TextStyle(
                                                      color: (themeProvider.getDarkMode())
                                                          ? Constants.text_light
                                                          : Constants.text_dark),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  onPrimary: (themeProvider.getDarkMode())
                                                      ? Constants.secondary_dark
                                                      : Constants.secondary,
                                                  textStyle: const TextStyle(fontSize: 20.0),
                                                  primary: (themeProvider.getDarkMode())
                                                      ? Constants.secondary_dark
                                                      : Constants.secondary,
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
                                ],
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
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
