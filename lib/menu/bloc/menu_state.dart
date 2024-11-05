
import '../model.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<Menus> menuList;

  MenuLoaded({required this.menuList});
}
class MenuCreated extends MenuState {
  final String menuId; // Required
  final String menuname; // Optional

  MenuCreated({required this.menuId,  required this.menuname}); // menuname is optional

  
}


class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});
}
