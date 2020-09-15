import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:cubit_sample/data/user.dart';
import 'package:cubit_sample/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageCounter extends StatelessWidget {
  const PageCounter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit<User>, PagedListAsyncState>(
      builder: (BuildContext context, PagedListAsyncState field) {
        return Text('Page:${field.page}');
      },
    );
  }
}
