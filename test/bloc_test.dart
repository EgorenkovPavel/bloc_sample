// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_test/bloc_test.dart';
import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:cubit_sample/data/user.dart';
import 'package:cubit_sample/data/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserMockRepository extends Mock implements ListRepository<User> {}

void main() {
  final userMockRepository = UserMockRepository();

  group('fetch items test', ()  {
    final fakeUsers = List.generate(10, (index) => User.createFakeUser());
    when(userMockRepository.fetch(1, 10))
        .thenAnswer((realInvocation) => Future.value(fakeUsers.toList()));
    when(userMockRepository.fetch(2, 10))
        .thenAnswer((realInvocation) => Future.value(fakeUsers.toList()));

    final expectStates = [
      PagedListAsyncState.inProgress(1),
      PagedListAsyncState<dynamic>.success(1, fakeUsers.toList())
    ];

    blocTest<ListCubit,PagedListAsyncState>('fetch items',
        expect: expectStates,
        act: (bloc) => bloc.fetchItems(),
        build: () => ListCubit<User>(userMockRepository));

  });
}
