abstract class MenuEvent {}

// Event to create a menu
class CreateMenuEvent extends MenuEvent {
  final String menuname;
  final String date;

  CreateMenuEvent({required this.menuname, required this.date});
}

class FetchMenusEvent extends MenuEvent {
  final String userId;
  final String date;

  FetchMenusEvent({required this.userId, required this.date});
}


class deleteMenu extends MenuEvent {
  final String menuId;

  deleteMenu({required this.menuId});
}

class UpdateMenu extends MenuEvent {
  final String menuId;
    final String menuname;
  UpdateMenu({required this.menuId, required this.menuname});
}
