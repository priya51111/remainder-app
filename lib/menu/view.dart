import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:testing/addBatchMode.dart';
import 'package:testing/menulistpage.dart';
import 'package:testing/settings.dart';
import 'package:testing/task/bloc/task_event.dart';
import 'package:testing/task/models.dart';
import 'package:testing/task/repository/task_repository.dart';
import 'package:testing/tasklistpage.dart';
import '../login/repository/repository.dart';
import '../logout/LogoutPage.dart';
import '../task/bloc/task_bloc.dart';
import '../task/bloc/task_state.dart';
import '../task/view/view.dart';
import 'bloc/menu_bloc.dart';
import 'bloc/menu_event.dart';
import 'bloc/menu_state.dart';
import 'repo/menu_repository.dart';

enum Menu {
  TaskLists,
  AddInBatchMode,
  RemoveAds,
  MoreApps,
  SendFeedback,
  FollowUs,
  Invite,
  Settings,
  MenuPage,
  Logout
}

class SimplePage extends StatefulWidget {
  @override
  _SimplePageState createState() => _SimplePageState();
}

class _SimplePageState extends State<SimplePage> {
  String? dropdownValue;
  List<String> dropdownItems = ['New List', 'Finished '];
  late UserRepository userRepository;
  late MenuRepository menuRepository;
  late TaskRepository taskRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    menuRepository = MenuRepository(userRepository: userRepository);
    taskRepository = TaskRepository(
      userRepository: userRepository,
      menuRepository: menuRepository,
    );
    _fetchMenus();
    _fetchTasks(true);
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

  void _fetchTasks(bool? finished) {
    final userIds = userRepository.getUserId();
    final dates = taskRepository.date();

    if (userIds != null) {
      context.read<TaskBloc>().add(
          FetchTaskEvent(userId: userIds, date: dates, finished: finished));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('User IDs is missing'),
            duration: Duration(seconds: 5)),
      );
    }
  }

  List<Tasks> _getFilteredTasks(TaskState state) {
    if (state is TaskSuccess) {
      print('Dropdown Value: $dropdownValue');
      print('Total Tasks: ${state.taskList.length}');

      if (dropdownValue == 'Finished') {
        return state.taskList.where((task) => task.isFinished).toList();
      } else {
        return state.taskList.where((task) => !task.isFinished).toList();
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 4, 83, 147),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(135, 33, 149, 243),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Container(
                width: 160.0,
                height: 60.0,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  hint: Text('Select'),
                  items: dropdownItems.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value;
                    });
                    if (value == 'New List') {
                      _showNewMenuDialog();
                    } else if (value == 'Finished') {
                      _fetchTasks(true);
                    } else {
                      _fetchTasks(false);
                    }
                  },
                  dropdownColor: Color.fromARGB(135, 33, 149, 243),
                  iconEnabledColor: Colors.white, 

                  isExpanded:
                      true, 
                  underline: SizedBox(), 
                ),
              ),
            ),
            BlocListener<MenuBloc, MenuState>(
              listener: (context, state) {
                if (state is MenuCreated) {
                  setState(() {
                    if (!dropdownItems.contains(state.menuname)) {
                      dropdownItems.add(state.menuname);
                    }
                    dropdownValue = state.menuname;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Menu created successfully: ${state.menuId}'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else if (state is MenuError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      duration: Duration(seconds: 5),
                    ),
                  );
                } else if (state is MenuLoaded) {
                  setState(() {
                    dropdownItems = [
                      'New List',
                      ...state.menuList.map((menu) => menu.menuname).toList(),
                      'Finished'
                    ];
                    dropdownValue = dropdownItems.first;
                  });
                }
              },
              child: SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          _buildPopupMenu()
        ],
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskMarkedAsCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: Duration(seconds: 3),
              ),
            );

            _fetchTasks(true);
            _fetchTasks(false);
          } else if (state is TaskSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tasks fetched successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is TaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is TaskUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Task updated successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading || state is TaskEditLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TaskSuccess) {
              final filteredTasks = _getFilteredTasks(state);
              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  final menuname = state.menuMap[task.menuId] ?? 'Unknown menu';
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateTaskPage(
                            task: task,
                            isEditMode: true,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: Container(
                        height: 70,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color.fromARGB(135, 33, 149, 243),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Checkbox(
                                  value: task.isFinished,
                                  onChanged: (bool? value) {
                                    if (value != null && !task.isFinished) {
                                      context.read<TaskBloc>().add(
                                            MarkTaskAsCompleted(
                                              taskId: task.id,
                                            ),
                                          );
                                    }
                                  },
                                  side: BorderSide(color: Colors.white),
                                  activeColor: Colors.blue.shade900,
                                  checkColor: Colors.white,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 100),
                                  child: Text(
                                    task.task,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: Text(
                                    '${task.date}',
                                    style: TextStyle(
                                      color: Color.fromARGB(135, 33, 149, 243),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 85   ),
                                  child: Text(
                                    task.time,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is TaskFailure) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Center(child: Text('No tasks available'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateTaskPage(
                      isEditMode: false,
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<Menu>(
      elevation: 0,
      color: Color.fromARGB(135, 33, 149, 243),
      constraints: BoxConstraints.tightFor(height: 340, width: 200),
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (Menu item) {
        switch (item) {
          case Menu.TaskLists:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Tasklistpage()),
            );
            break;
          case Menu.AddInBatchMode:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Addbatchmode(
                          isEditMode: false,
                        )));
          
            break;
          case Menu.RemoveAds:
            break;
          case Menu.MoreApps:
          
          case Menu.SendFeedback:
         
          case Menu.FollowUs:
          
          case Menu.Invite:
         
          case Menu.Settings:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => settings()));
                  break; 
                  case Menu.Logout:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>LogoutPage()));
          
            break;
             case Menu.MenuPage:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuListPage(
                       
                        )));

          
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.TaskLists,
          child: Text('Task Lists',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.AddInBatchMode,
          child: Text('Add in Batch Mode',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.RemoveAds,
          child: Text('Remove Ads',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.MoreApps,
          child: Text('More Apps',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.SendFeedback,
          child: Text('Send Feedback',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.FollowUs,
          child: Text('Follow Us',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.Settings,
          child: Text('Settings',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
         const PopupMenuItem<Menu>(
          value: Menu.MenuPage,
          child: Text('MenuPage',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.Logout,
          child: Text('Logout',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
      ],
    );
  }

  void _showNewMenuDialog() {
    final TextEditingController menuController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          title: Text(
            'Create New Menu',
            style: TextStyle(
              color: Color.fromARGB(201, 4, 83, 147),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: menuController,
                decoration: InputDecoration(hintText: 'Menu Name'),
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(hintText: 'Select Date'),
                onTap: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate!);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String menuName = menuController.text.trim();
                final String date = dateController.text.trim();
                if (menuName.isNotEmpty && date.isNotEmpty) {
                 
                  context
                      .read<MenuBloc>()
                      .add(CreateMenuEvent(menuname: menuName, date: date));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please fill in all fields'),
                        duration: Duration(seconds: 3)),
                  );
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Color.fromARGB(201, 4, 83, 147),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
