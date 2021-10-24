import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guessy/cubits/image_cubit.dart';
import 'package:guessy/data/model/question.dart';
import 'package:guessy/data/provider/dynamic_theme.dart';
import 'package:guessy/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:guessy/data/provider/image_provider.dart';
import 'package:guessy/data/provider/questions_firebase_provider.dart';
import 'dart:async';

import 'home_page.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final TextEditingController _themeController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  bool _isSwitchOn = false;
  final QuestionsFirebaseProvider _questionsFirebaseProvider = QuestionsFirebaseProvider();

  final ImageFirebaseProvider _imageFirebaseProvider = ImageFirebaseProvider();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);

    return Consumer<DynamicTheme>(
      builder: (context, theme, _) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.home, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          backgroundColor:
              (themeProvider.getDarkMode()) ? Constants.primary_dark : Constants.primary,
          title: const Text(
            "Add question",
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
        body: Provider<ImageCubit>(
          create: (context) => ImageCubit(),
          child: SingleChildScrollView(
            child: Builder(builder: (BuildContext ctxScaffold) {
              return BlocBuilder<ImageCubit, File?>(builder: (context, state) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: (state != null)
                      ? MediaQuery.of(context).size.height * 0.9
                      : MediaQuery.of(context).size.height * 0.9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      colors: [
                        (themeProvider.getDarkMode()) ? Constants.primary_dark : Constants.primary,
                        (themeProvider.getDarkMode())
                            ? Constants.secondary_dark
                            : Constants.secondary,
                      ],
                    ),
                  ),
                  child: Builder(
                    builder: (BuildContext ctxScaffold) {
                      return BlocBuilder<ImageCubit, File?>(
                        builder: (context, state) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 15),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextField(
                                  controller: _themeController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(fontSize: 20),
                                      fillColor: Color.fromRGBO(255, 255, 255, 1),
                                      hintText: "Add theme"),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 15),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextField(
                                  controller: _questionController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(fontSize: 20),
                                      fillColor: Color.fromRGBO(255, 255, 255, 1),
                                      hintText: "Add question"),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "False",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Switch(
                                        inactiveTrackColor: Colors.red,
                                        activeTrackColor: Colors.green,
                                        activeColor: (themeProvider.getDarkMode())
                                            ? Constants.text_light
                                            : Constants.text_dark,
                                        inactiveThumbColor: (themeProvider.getDarkMode())
                                            ? Constants.text_light
                                            : Constants.text_dark,
                                        value: _isSwitchOn,
                                        onChanged: _updateAnswer),
                                    const Text(
                                      "True",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              if (state != null)
                                Image.file(
                                  state,
                                  width: MediaQuery.of(context).size.width * 0.3,
                                ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
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
                                      top: 30,
                                      left: 30,
                                      right: 30,
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 30,
                                      left: 30,
                                      right: 30,
                                    ),
                                    child: Column(
                                      children: [
                                        (state != null)
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  onPrimary: (themeProvider.getDarkMode()) ? Constants.primary_dark : Constants.primary,
                                                  textStyle: const TextStyle(
                                                      fontSize: 20.0, color: Colors.white),
                                                  primary: (themeProvider.getDarkMode()) ? Constants.secondary_dark : Constants.secondary,
                                                  fixedSize: const Size(300, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  context.read<ImageCubit>().sendCorrectImage(null);
                                                },
                                                child: Text(
                                                  "Remove picture",
                                                  style: TextStyle(
                                                      color: (themeProvider.getDarkMode())
                                                          ? Constants.text_light
                                                          : Constants.text_dark),
                                                ))
                                            : ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  onPrimary: (themeProvider.getDarkMode())
                                                      ? Constants.primary_dark
                                                      : Constants.primary,
                                                  textStyle: const TextStyle(
                                                      fontSize: 20.0, color: Colors.white),
                                                  primary: (themeProvider.getDarkMode())
                                                      ? Constants.secondary_dark
                                                      : Constants.secondary,
                                                  fixedSize: const Size(300, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _showPicker(context);
                                                },
                                                child: Text(
                                                  "Add picture",
                                                  style: TextStyle(
                                                      color: (themeProvider.getDarkMode())
                                                          ? Constants.text_light
                                                          : Constants.text_dark),
                                                )),
                                        Container(
                                          margin: const EdgeInsets.only(top: 15),
                                          child: ElevatedButton(
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
                                            onPressed: () {
                                              if (_questionController.text != "" &&
                                                  state != null &&
                                                  _themeController.text != "") {
                                                _imageFirebaseProvider
                                                    .uploadImage(state)
                                                    .then((value) {
                                                  _questionsFirebaseProvider
                                                      .addQuestion(Question(
                                                          _questionController.text,
                                                          "/" + basename(state.path),
                                                          _themeController.text,
                                                          _isSwitchOn))
                                                      .then((value) {
                                                    Scaffold.of(ctxScaffold).showSnackBar(
                                                      const SnackBar(
                                                        content:
                                                            Text("Your question has been added."),
                                                        duration: Duration(milliseconds: 2000),
                                                      ),
                                                    );
                                                  });
                                                });
                                              } else {
                                                Scaffold.of(ctxScaffold).showSnackBar(const SnackBar(
                                                  content: Text("Please complete all fields"),
                                                  duration: Duration(milliseconds: 2000),
                                                ));
                                              }
                                            },
                                            child: Text(
                                              "Send",
                                              style: TextStyle(
                                                  color: (themeProvider.getDarkMode())
                                                      ? Constants.text_light
                                                      : Constants.text_dark),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              });
            }),
          ),
        ),
      ),
    );
  }

  Future _imgFromGallery(BuildContext context) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    context.read<ImageCubit>().sendCorrectImage(image);
  }

  Future _imgFromCamera(BuildContext context) async {
    File photo = await ImagePicker.pickImage(source: ImageSource.camera);
    context.read<ImageCubit>().sendCorrectImage(photo);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery(context);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _updateAnswer(bool value) {
    setState(() {
      _isSwitchOn = value;
    });
  }

  @override
  void dispose() {
    _themeController.dispose();
    _questionController.dispose();
    super.dispose();
  }
}
