import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:cubit_sample/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserButton extends StatelessWidget {
  const AddUserButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit<User>, PagedListAsyncState>(
      builder: (BuildContext context, PagedListAsyncState field) {
        if (field?.hasData == true) {
          return FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                print(field.payload.length);
                (field.payload as List).add(User.createFakeUser());
                BlocProvider.of<ListCubit<User>>(context)
                    .addItem(User.createFakeUser());
                print(field.payload.length);
              });
        }
        return SizedBox();
      },
    );
  }
}
