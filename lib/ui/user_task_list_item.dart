import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:cubit_sample/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTaskListItem extends StatelessWidget {
  const UserTaskListItem(this.taskListItem, {Key key}) : super(key: key);

  final ItemTask<User> taskListItem;

  @override
  Widget build(BuildContext context) {
    final model = taskListItem.item;
    final taskStatus = taskListItem.taskStatus;

    Widget statusWidget;
    if (taskStatus.inProgress) {
      statusWidget = CircularProgressIndicator();
    } else if (taskStatus.hasError) {
      statusWidget = Icon(Icons.error, color: Colors.red);
    }
    return Card(
        child: SizedBox(
            height: 100,
            child: Center(
              child: ListTile(
                title: Text(model.name,
                    style: Theme.of(context).textTheme.headline5),
                trailing: statusWidget,
              ),
            )));
  }
}
