import 'package:cubit_sample/data/user.dart';
import 'package:cubit_sample/data/user_repository.dart';
import 'package:cubit_sample/ui/users_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListCubit<User>>(
      create: (context) => ListCubit<User>(UserRepository())..fetchItems(),
      lazy: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light().copyWith(
            tabBarTheme: TabBarTheme(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(color: Colors.blue.withOpacity(0.2)))),
        home: UsersPage(),
      ),
    );
  }
}
