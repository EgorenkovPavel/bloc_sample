import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:cubit_sample/data/user.dart';
import 'package:cubit_sample/ui/user_list_item.dart';
import 'package:cubit_sample/ui/page_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_user_button.dart';
import 'user_task_list_item.dart';
import 'paged_list_view.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
          middle: Text('Users'), trailing: PageCounter()),
      body: BlocConsumer<ListCubit<User>, PagedListAsyncState>(
          listener: (context, state) {
            if (state.hasError) {
              _showError(context, state.error?.toString());
            } else if (state.inProgress) {
              _showBottomProgress(context, state.page);
            } else if (state.hasData) {
              Scaffold.of(context).hideCurrentSnackBar();
            }
          },
          builder: (context, state) => PagedListView(state, onLoadNextPage: () {
                BlocProvider.of<ListCubit<User>>(context).loadNextPage();
              }, itemBuilder: (BuildContext context, item) {
                if (item is ItemTask<User>) {
                  return UserTaskListItem(item);
                }
                return UserListItem(item);
              })),
      floatingActionButton: AddUserButton(),
    );
  }

  void _showError(BuildContext context, String error) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  void _showBottomProgress(BuildContext context, int page) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Loading page: $page'), CupertinoActivityIndicator()],
        )));
  }
}
