import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:cubit_sample/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListItem extends StatelessWidget {
  const UserListItem(this.item, {Key key}) : super(key: key);

  final User item;

  @override
  Widget build(BuildContext context) => Card(
      child: SizedBox(
          height: 100,
          child: Center(
            child: ListTile(
              title: Text(
                item.name,
                style: Theme.of(context).textTheme.headline5,
              ),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle),
                color: Colors.red,
                onPressed: () {
                  BlocProvider.of<ListCubit<User>>(context).deleteItem(item);
                },
              ),
            ),
          )));
}
