import 'package:bloc/bloc.dart';

class GameOnCubit extends Cubit<bool> {
  GameOnCubit() : super(false);

  changeState() => emit(true);
}