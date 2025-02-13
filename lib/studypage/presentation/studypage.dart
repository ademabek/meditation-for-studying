import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudyPage extends StatefulWidget {
  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  final Map<String, List<Map<String, String>>> _tasksBySubject = {
    'Math': [],
    'Science': [],
    'History': [],
    'English': [],
    'Geography': [],
    'Physics': [],
  };

  void _updateTasks(String subject, List<Map<String, String>> updatedTasks) {
    setState(() {
      _tasksBySubject[subject] = updatedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High School Study Hub'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: Colors.blue.shade50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subjects',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _tasksBySubject.keys.length,
                itemBuilder: (context, index) {
                  String subject = _tasksBySubject.keys.elementAt(index);
                  return _subjectCard(context, subject);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subjectCard(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskCreationPage(
              subject: title,
              tasks: List.from(_tasksBySubject[title]!),
              onTaskCompleted: (updatedTasks) {
                _updateTasks(title, updatedTasks);
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(Icons.book, color: Colors.deepPurple),
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${_tasksBySubject[title]!.length} Tasks'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ),
      ),
    );
  }
}

class TaskCreationPage extends StatefulWidget {
  final String subject;
  final List<Map<String, String>> tasks;
  final Function(List<Map<String, String>>) onTaskCompleted;

  TaskCreationPage({
    required this.subject,
    required this.tasks,
    required this.onTaskCompleted,
  });

  @override
  _TaskCreationPageState createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  final TextEditingController _taskTitleController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  void _pickTime(BuildContext context, bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  void _addTask() {
    if (_taskTitleController.text.isNotEmpty &&
        _startTime != null &&
        _endTime != null) {
      setState(() {
        widget.tasks.add({
          'title': _taskTitleController.text,
          'startTime': _startTime!.format(context),
          'endTime': _endTime!.format(context),
        });
      });
      _taskTitleController.clear();
    }
  }

  void _completeTask(int index) {
    setState(() {
      widget.tasks.removeAt(index);
    });

    widget.onTaskCompleted(List.from(widget.tasks));

    Future.delayed(Duration(milliseconds: 300), () {
      _showMotivationalDialog();
    });
  }

  void _showMotivationalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Great Job!'),
          content: Text(
              'You are the best! Keep going, you\'re getting closer to your goal!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _taskTitleController,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickTime(context, true),
                    child: Text(_startTime == null
                        ? 'Start Time'
                        : _startTime!.format(context)),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _pickTime(context, false),
                    child: Text(_endTime == null
                        ? 'End Time'
                        : _endTime!.format(context)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addTask,
                child: Text('Add Task'),
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.tasks.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.tasks[index]['title']!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${widget.tasks[index]['startTime']} - ${widget.tasks[index]['endTime']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _completeTask(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Complete',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
