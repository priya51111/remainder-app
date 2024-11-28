
import '../model.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<Menus> menuList;

  MenuLoaded({required this.menuList});
}
class MenuCreated extends MenuState {
  final String menuId; 
  final String menuname; 

  MenuCreated({required this.menuId,  required this.menuname}); 

  
}


class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});
}
