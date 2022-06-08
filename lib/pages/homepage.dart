import 'package:flutter/Material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:second_app_taskly/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _deviceWidth, _deviceHeight;
  Box? _box; //hive class that contains our data
  String? _newTaskContent;

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.15,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        title: const Text(
          "Taskyly!",
        ),
      ),
      body: SafeArea(
        child: _taskView(),
      ),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskList() {
    // Task _newTask = Task(
    //   content: "Eat Pizza",
    //   timestamp: DateTime.now(),
    //   done: false,
    // );

    // _box?.add(_newTask.toMap());

    List tasks = _box!.values.toList();

    // difference between ? and ! in chaining is that
    // while using ?, we tell the compiler to check if
    // the value is null or not, and while using !, we
    // tell the compiler that no need to worry, we know
    // that it is not null.

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
              decoration: task.done ? null : TextDecoration.lineThrough,
            ),
          ),
          subtitle: Text(
            task.timestamp.toString(),
          ),
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_outlined,
            color: Colors.red,
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(index);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      child: const Icon(
        Icons.add,
      ),
    );
  }

  void _displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add new Task"),
          content: TextField(
            onSubmitted: (_) {
              if (_newTaskContent != null) {
                var task = Task(
                  content: _newTaskContent!,
                  timestamp: DateTime.now(),
                  done: false,
                );
                _box!.add(task.toMap());
                setState(() {
                  _newTaskContent = null;
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (value) {
              setState(() {
                _newTaskContent = value;
              });
              // _newTaskContent = value;
            },
          ),
        );
      },
    );
  }

  Widget _taskView() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _taskList();
        } else {
          return Container(
            alignment: Alignment.center,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
