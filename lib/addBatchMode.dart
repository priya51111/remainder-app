import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:testing/task/bloc/task_bloc.dart';
import 'package:testing/task/bloc/task_event.dart';
import 'package:testing/task/bloc/task_state.dart';
import 'package:testing/task/models.dart';

import '../../login/repository/repository.dart';
import '../../menu/bloc/menu_bloc.dart';
import '../../menu/bloc/menu_event.dart';
import '../../menu/bloc/menu_state.dart';
import '../../menu/model.dart';
import '../../menu/repo/menu_repository.dart';


class Addbatchmode extends StatefulWidget {
  final Tasks? task; // Optional task parameter for editing
  final bool isEditMode;

  const Addbatchmode({Key? key, this.task, required this.isEditMode})
      : super(key: key);

  @override
  State<Addbatchmode> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<Addbatchmode> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isTaskFinished = false;

  final UserRepository userRepository = UserRepository();
  final MenuRepository menuRepository;
  final Logger log = Logger();
  _CreateTaskPageState()
      : menuRepository = MenuRepository(userRepository: UserRepository());
  String selectedTaskType = 'Default';
  bool _isDateSelected = false;
  bool _isEditMode = false; // To check if it's an edit operation
  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _isEditMode = true;
      _populateFields(widget.task!); // Populate fields with task data
    }
    _fetchMenus();
  }

  void _populateFields(Tasks task) {
    _taskController.text = task.task;
    _dateController.text = task.date;
    _timeController.text = task.time;
    selectedTaskType =
        task.menuId.toString(); // or assign the menu name if available
    _isDateSelected = true;
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
      backgroundColor: Color.fromARGB(134, 4, 83, 147),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(135, 33, 149, 243),
        title: Text(_isEditMode ? 'Edit Task' : 'New Task',
            style: TextStyle(color: Colors.white)),
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskLoading) {
            Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is TaskSuccess || state is TaskUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(_isEditMode
                      ? 'Task Updated Successfully'
                      : 'Task Created Successfully')),
            );
          } else if (state is TaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task Creation Failed: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: [
                SizedBox(height: 16),
                Text(
                  "What is to be done?",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: 16),

                TextField(
                  controller: _taskController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter Task here",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                if (_isEditMode)
                  Row(
                    children: [
                      Checkbox(
                        value: widget.task!.isFinished,
                        onChanged: (bool? value) {
                          if (value != null && !widget.task!.isFinished) {
                            context.read<TaskBloc>().add(
                                  MarkTaskAsCompleted(taskId: widget.task!.id),
                                );
                          }
                        },
                        activeColor: Colors.blue.shade900,
                        checkColor: Colors.white,
                      ),
                      Text(
                        "Task Finished?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                SizedBox(
                  height: 9,
                ),

                // Date Input
                Text(
                  "Due Date",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _dateController,
                  style: TextStyle(color: Colors.white),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.blue.shade900,
                              onPrimary: Colors.white,
                              onSurface: Colors.blue.shade900,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      _dateController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      setState(() {
                        _isDateSelected = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Date not set",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),

                // Time Input (enabled only if date is selected)
                if (_isDateSelected) ...[
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    "Time",
                    style: TextStyle(
                      color: Color.fromARGB(135, 33, 149, 243),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _timeController,
                    style: TextStyle(color: Colors.white),
                    readOnly: true,
                    enabled: _isDateSelected, // Enable only if date is selected
                    onTap: _isDateSelected
                        ? () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.blue.shade900,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.blue.shade900,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedTime != null) {
                              _timeController.text = pickedTime.format(context);
                            }
                          }
                        : null,
                    decoration: InputDecoration(
                      enabled: _isDateSelected,
                      hintText: "Time not set",
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: Icon(Icons.access_time, color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ],
                SizedBox(
                  height: 9,
                ),

                Text(
                  "Add to List",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<MenuBloc, MenuState>(
                        builder: (context, state) {
                          if (state is MenuLoading) {
                            return CircularProgressIndicator();
                          } else if (state is MenuLoaded) {
                            return DropdownButtonFormField<Menus>(
                              dropdownColor: Color.fromARGB(135, 33, 149, 243),
                              value: state.menuList.isNotEmpty
                                  ? state.menuList.first
                                  : null,
                              items: state.menuList.map((menu) {
                                return DropdownMenuItem<Menus>(
                                  value: menu,
                                  child: Text(menu.menuname ?? ''),
                                );
                              }).toList(),
                              onChanged: (menu) {
                                setState(() {
                                  selectedTaskType =
                                      menu?.menuname ?? 'Default';
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Select Menu",
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.white,
                            );
                          } else if (state is MenuError) {
                            return Text(
                              'Error fetching menus',
                              style: TextStyle(color: Colors.white),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.format_list_bulleted_add,
                            color: Colors.white),
                        onPressed: () {
                          _showNewMenuDialog();
                        }),
                  ],
                ),

                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 280, left: 290),
                  child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        final task = _taskController.text;
                        final date = _dateController.text;
                        final time = _timeController.text;

                        if (task.isEmpty || date.isEmpty || time.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please fill in all fields')),
                          );
                        } else {
                          // Different event for creating vs updating a task
                          if (_isEditMode && widget.task != null) {
                            context.read<TaskBloc>().add(
                                  UpdateTaskEvent(
                                      taskId: widget.task!.id,
                                      task: task,
                                      date: date,
                                      time: time,
                                      menuId: selectedTaskType,
                                      isfinished: false),
                                );
                          } else {
                            context.read<TaskBloc>().add(TaskSubmitted(
                                  task: task,
                                  date: date,
                                  time: time,
                                ));
                          }
                          Navigator.pop(context);
                        }
                        ;
                      },
                      backgroundColor: Colors.white,
                      child: Icon(Icons.check)),
                )),
              ],
            ),
          ),
        ),
      ),
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
                  // Trigger the event to create a new menu
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
                  fontWeight: FontWeight.bold,
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
