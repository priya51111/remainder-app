import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/login/repository/repository.dart';
import 'package:testing/menu/bloc/menu_bloc.dart';
import 'package:testing/menu/bloc/menu_event.dart';
import 'package:testing/menu/repo/menu_repository.dart';
import 'package:testing/task/bloc/task_bloc.dart';
import 'package:testing/task/bloc/task_event.dart';
import 'package:testing/task/bloc/task_state.dart';
import 'package:testing/task/models.dart';

import 'task/repository/task_repository.dart';

class Tasklistpage extends StatefulWidget {
  const Tasklistpage({super.key});

  State<Tasklistpage> createState() => _TasklistpageState();
}

class _TasklistpageState extends State<Tasklistpage> {
  late UserRepository userRepository;
  late MenuRepository menuRepository;
  late TaskRepository taskRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository(); // Initialize the user repository
    menuRepository = MenuRepository(
        userRepository:
            userRepository); // Pass user repository to menu repository
    taskRepository = TaskRepository(
      userRepository: userRepository,
      menuRepository: menuRepository,
    ); // Pass both repositories to task repositoryn

    _fetchTasks();
  }

  void _fetchTasks() {
    final userIds = userRepository.getUserId();
    final dates = taskRepository.date();

    if (userIds != null) {
      context
          .read<TaskBloc>()
          .add(FetchTaskEvent(userId: userIds, date: dates));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('User IDs is missing'),
            duration: Duration(seconds: 5)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:MultiBlocListener(listeners:   [
        BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Task deleted successfully")),
              );
            } else if (state is TaskDeleteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete task')),
              );
            }
          },
        ),
      ], child:        BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskDeleteSuccess) {
           SchedulerBinding.instance.addPostFrameCallback((_) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Task deleted successfully")),
  );
});

            return SizedBox.shrink(); // To prevent multiple SnackBars
          } else if (state is TaskDeleteFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete task')),
            );
            return SizedBox.shrink();
          } else if (state is TaskSuccess) {
            return ListView.builder(
              itemCount: state.taskList.length,
              itemBuilder: (context, index) {
                final task = state.taskList[index];
                final menuname = state.menuMap[task.menuId] ??
                    'Unknown menu'; // Fetch the menu name
                return Padding(
                  padding: const EdgeInsets.all(9),
                  child: Container(
                    height: 70,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(135, 33, 149, 243),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(task.task), // Display task name
                            SizedBox(width: 10),
                            Text(
                                '${task.date} ${task.time}'), // Display date and time
                            SizedBox(width: 10),
                            // Handle the list of menuIds
                            SizedBox(width: 10),
                            Text(menuname), // Di
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                               onPressed: (){},
                                icon: Icon(Icons.edit))
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                 
                                  context
                                      .read<TaskBloc>()
                                      .add(DeleteTaskEvent(taskId: task.id));
                                }, icon: Icon(Icons.delete))
                          ],
                        )
                      ],
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
      ),)
      
      

    );
  }
}
