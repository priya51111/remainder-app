import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {
 
  final String task;
  final String date;
  final String time;


  const TaskDetailPage({
    Key? key,
   
    required this.task,
    required this.date,
    required this.time,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            SizedBox(height: 8),
            Text(
              'Task: $task',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: $date',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time: $time',
              style: TextStyle(fontSize: 16),
            ),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can add functionality to edit or delete the task here
              },
              child: Text('Edit Task'),
            ),
          ],
        ),
      ),
    );
  }
}
