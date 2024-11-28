import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/menu/bloc/menu_bloc.dart';
import 'package:testing/menu/bloc/menu_event.dart';
import 'package:testing/menu/bloc/menu_state.dart';
import 'package:testing/menu/model.dart';

import 'login/repository/repository.dart';
import 'menu/repo/menu_repository.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({Key? key}) : super(key: key);

  @override
  _MenuListPageState createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  late UserRepository userRepository;
  late MenuRepository menuRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    menuRepository = MenuRepository(userRepository: userRepository);
    _fetchMenus();
  }

  void _fetchMenus() {
    final userId = userRepository.getUserId();
    final date = menuRepository.getdate();

    if (userId != null) {
      context.read<MenuBloc>().add(FetchMenusEvent(userId: userId, date: date));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('User ID is missing'),
            duration: Duration(seconds: 5)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menus'),
      ),
      body: BlocListener<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuDeleteSucess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Menu successfully deleted!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is MenuError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MenuLoaded) {
              final List<Menus> menus = state.menuList;
              if (menus.isEmpty) {
                return const Center(
                  child: Text('No menus available'),
                );
              }
              return ListView.builder(
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(leading:  IconButton(
                            onPressed: () {
                              _showEditMenuDialog(context, menu.id, menu.menuname);
                            },
                            icon: const Icon(Icons.edit, color: Colors.red),
                          ),
                      title: Text(menu.menuname),
                      subtitle: Text('Date: ${menu.date}'),
                      trailing:
                          IconButton(
                            onPressed: () {
                              context.read<MenuBloc>().add(deleteMenu(menuId: menu.id));
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                         
                    ),
                  );
                },
              );
            } else if (state is MenuError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }
            return const Center(
              child: Text('Loading menus...'),
            );
          },
        ),
      ),
    );
  }

  void _showEditMenuDialog(BuildContext context, String menuId, String currentMenuname) {
    final TextEditingController menunameController = TextEditingController(text: currentMenuname);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Menu Name'),
          content: TextField(
            controller: menunameController,
            decoration: const InputDecoration(hintText: 'Enter new menu name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newMenuname = menunameController.text;
                if (newMenuname.isNotEmpty) {
                  // Dispatch the event to update the menu
                  context.read<MenuBloc>().add(UpdateMenu(
                    menuId: menuId,
                    menuname: newMenuname,
                  ));
                }
                Navigator.of(context).pop();  // Close the dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
