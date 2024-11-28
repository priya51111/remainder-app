abstract class MenuEvent {}

class CreateMenuEvent extends MenuEvent {
  final String menuname;
  final String date;

  CreateMenuEvent({required this.menuname, required this.date});
}

class FetchMenusEvent extends MenuEvent {
  final String userId;
  final String date;

  FetchMenusEvent({ required this.userId,  required this.date});
}
