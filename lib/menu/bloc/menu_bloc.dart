import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:testing/menu/model.dart';
import 'package:testing/task/repository/task_repository.dart';

import '../../login/repository/repository.dart';
import '../repo/menu_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;
  final UserRepository userRepository;
  final GetStorage box = GetStorage(); 
  final Logger logger = Logger();

  MenuBloc({required this.menuRepository, required this.userRepository})
      : super(MenuInitial()) {
    on<CreateMenuEvent>(_onCreateMenu);
    on<FetchMenusEvent>(_onFetchMenus);
    on<deleteMenu>(_onDeleteMenu);
    on<UpdateMenu>(_onmenuUpdated); 
  }

 
  Future<void> _onCreateMenu(
      CreateMenuEvent event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final response =
          await menuRepository.createMenu(event.menuname, event.date);
      emit(MenuCreated(menuId: response, menuname: event.menuname));

      final userId = box.read('userId');
      final date = box.read('date');

      if (userId == null || date == null) {
        emit(MenuError(message: 'User ID or date is missing'));
        return;
      }
 
      add(FetchMenusEvent(userId: userId, date: date));
    } catch (error) {
      emit(MenuError(message: error.toString()));
    }
  }

  // Handle fetching menus
  Future<void> _onFetchMenus(
      FetchMenusEvent event, Emitter<MenuState> emit) async {
    emit(MenuLoading()); 

    try {
      final List<Menus> menus = await menuRepository.fetchMenus(
        userId: event.userId, 
        providedDate: event.date,
      );

      emit(MenuLoaded(menuList: menus)); 
    } catch (e) {
      logger.e("Error fetching menus: $e");
      emit(MenuError(message: 'Failed to fetch menus.'));
    }
  }

  Future<void> _onDeleteMenu(deleteMenu event, Emitter<MenuState> emit) async {
    try {
      await menuRepository.deletemenu(event.menuId);
      emit(MenuDeleteSucess());
      final userId = box.read('userId');
      final date = box.read('date');
      if (userId == null || date == null) {
        emit(MenuError(message: 'User ID or date is missing'));
        return;
      }

      
      add(FetchMenusEvent(userId: userId, date: date));
    } catch (e) {
      emit(MenuError(message: 'failed to delete '));
    }
  }

  Future<void> _onmenuUpdated(
    UpdateMenu event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
    
      final isUpdated = await menuRepository.updateMenu(
        menuId: event.menuId,
        menuname: event.menuname,
      );

      if (isUpdated) {

        final List<Menus> UpdatedMenus = await menuRepository.fetchMenus(
          userId: userRepository.getUserId()!,
          providedDate: box.read('date') ?? '',
        );

        emit(MenuUpdateSuccess(updatedMenus: UpdatedMenus));
      } else {
        
        emit(MenuError(message: 'Failed to update the menu'));
      }
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }
}
