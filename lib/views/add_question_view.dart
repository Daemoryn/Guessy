import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guessy/cubits/image_cubit.dart';
import 'package:guessy/data/model/question.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:guessy/data/provider/image_provider.dart';
import 'package:guessy/data/provider/questions_firebase_provider.dart';
import 'dart:async';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

export 'package:image_picker_platform_interface/image_picker_platform_interface.dart'
    show
        kTypeImage,
        kTypeVideo,
        ImageSource,
        CameraDevice,
        LostData,
        LostDataResponse,
        PickedFile,
        XFile,
        RetrieveType;

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
  final ImagePicker _picker = ImagePicker();
  late File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: const Color(0xFFFFA450),
        title: const Text(
          "Add new question",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Provider<ImageCubit>(
        create: (context) => ImageCubit(),
        child: SingleChildScrollView(
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
            child: Builder(
              builder: (BuildContext ctxScaffold) {
                return BlocBuilder<ImageCubit, File?>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Container(
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Container(
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
                                  activeColor: Colors.white,
                                  value: _isSwitchOn,
                                  onChanged: _updateAnswer),
                              const Text(
                                "True",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        if (state != null)
                          Image.file(
                            state,
                            width: MediaQuery.of(context).size.width * 0.8,
                          ),
                        if (state != null)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                top: 15,
                              ),
                              padding: const EdgeInsets.only(
                                top: 26,
                                left: 30,
                                right: 30,
                              ),
                              child: Column(
                                children: [
                                  (state != null)
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            onPrimary: const Color(0xFFFFA450),
                                            textStyle: const TextStyle(
                                                fontSize: 20.0, color: Colors.white),
                                            primary: const Color(0xFFFF5656),
                                            fixedSize: const Size(300, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                          ),
                                          onPressed: () {
                                            context.read<ImageCubit>().sendCorrectImage(null);
                                          },
                                          child: const Text(
                                            "Enlever l'image",
                                            style: TextStyle(color: Colors.white),
                                          ))
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            onPrimary: const Color(0xFFFFA450),
                                            textStyle: const TextStyle(
                                                fontSize: 20.0, color: Colors.white),
                                            primary: const Color(0xFFFF5656),
                                            fixedSize: const Size(300, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                          ),
                                          onPressed: () {
                                            _showPicker(context);
                                          },
                                          child: const Text(
                                            "Ajouter une image",
                                            style: TextStyle(color: Colors.white),
                                          )),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.03,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      onPrimary: const Color(0xFFFFA450),
                                      textStyle: const TextStyle(fontSize: 20.0),
                                      primary: const Color(0xFFFF5656),
                                      fixedSize: const Size(300, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    onPressed: () {
                                      print(_questionController.text);
                                      if (_questionController.text != "" &&
                                          state != null &&
                                          _themeController.text != "") {
                                        _imageFirebaseProvider.uploadImage(state).then((value) {
                                          print("Je suis ici 2");
                                          _questionsFirebaseProvider
                                              .addQuestion(Question(
                                                  _questionController.text,
                                                  "/" + basename(state.path),
                                                  _themeController.text,
                                                  _isSwitchOn))
                                              .then((value) {
                                            Scaffold.of(ctxScaffold).showSnackBar(
                                              const SnackBar(
                                                content: Text("Your question has been added."),
                                                duration: Duration(milliseconds: 500),
                                              ),
                                            );
                                          });
                                        });
                                        // );
                                      } else {
                                        Scaffold.of(ctxScaffold).showSnackBar(const SnackBar(
                                          content: Text("Please complete all fields"),
                                          duration: Duration(milliseconds: 500),
                                        ));
                                      }
                                    },
                                    child: const Text(
                                      "Send",
                                      style: TextStyle(color: Colors.white),
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
          ),
        ),
      ),
    );
  }

  Future _imgFromGallery(BuildContext context) async {
    File image = await _picker.getImage(source: ImageSource.gallery) as File;
    setState(() {
      _image = File(image.path);
    });
    context.read<ImageCubit>().sendCorrectImage(_image);
  }

  Future _imgFromCamera(BuildContext context) async {
    File photo = await _picker.pickImage(source: ImageSource.camera) as File;
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
      // print("Switch ->" + _isSwitchOn.toString());
    });
  }

  @override
  void dispose() {
    _themeController.dispose();
    _questionController.dispose();
    super.dispose();
  }
}
