part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class GridUpdateState extends HomeState {
  final id = DateTime.now().microsecondsSinceEpoch;

  @override
  List<Object> get props => [id];
}

class KeyboardKeyUpdateState extends HomeState {
  final id = DateTime.now().microsecondsSinceEpoch;
  final KeyboardKeys key;
  final Letter letterType;

  KeyboardKeyUpdateState(this.key, this.letterType);

  @override
  List<Object> get props => [id,key,letterType];
}

class SnackBarMessage extends HomeState {
  final id = DateTime.now().microsecondsSinceEpoch;
  final MessageTypes type;
  final String message;

  SnackBarMessage(this.type, this.message);

  @override
  List<Object> get props => [id, type, message];
}

class LoseGameState extends HomeState {
  @override
  List<Object> get props => [];
}

class WinGameState extends HomeState {
  @override
  List<Object> get props => [];
}
