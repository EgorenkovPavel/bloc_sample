// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:cubit_sample/data/user.dart';
import 'package:cubit_sample/data/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserMockRepository extends Mock implements ListRepository<User> {}

void main() {
  UserMockRepository userMockRepository;
  ListCubit<User> bloc;

  setUp(() {
    userMockRepository = UserMockRepository();
    bloc = ListCubit<User>(userMockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test('init bloc test', () async {
    expect(bloc.state, PagedListAsyncState(0), reason: 'init');
  });

  test('fetch test', () async {
    final fakeUsers = List.generate(10, (index) => User.createFakeUser());

    // Мокаем наш запрос
    when(userMockRepository.fetch(1, 10))
        .thenAnswer((realInvocation) => Future.value(fakeUsers.toList()));

    final expectStates = [
      PagedListAsyncState.inProgress(1),
      PagedListAsyncState<dynamic>.success(1, fakeUsers.toList())
    ];

    // Проверяем последовательность состояний
    expectLater(bloc, emitsInOrder(expectStates), reason: 'emitsInOrder');

    bloc.fetchItems();
  });

  test('throw test', () {
    when(userMockRepository.fetch(1, 10)).thenThrow('Error');

    final expectStates = [
      PagedListAsyncState.inProgress(1),
      PagedListAsyncState.error(0, 'Error')
    ];

    expectLater(bloc, emitsInOrder(expectStates), reason: 'emitsInOrder');
    bloc.fetchItems();
  });

  test('finish test', () {
    final fakeUsers = List.generate(8, (index) => User.createFakeUser());
    when(userMockRepository.fetch(1, 10))
        .thenAnswer((realInvocation) => Future.value(fakeUsers.toList()));

    final expectStates = [
      PagedListAsyncState.inProgress(1),
      PagedListAsyncState<dynamic>.success(1, fakeUsers.toList(),
          isFinished: true)
    ];
    expectLater(bloc, emitsInOrder(expectStates));

    bloc.fetchItems();
  });

  test('add item success test', () async {
    final user = User.createFakeUser();
    final createdUser = user.copyWith(id: 1);
    when(userMockRepository.add(user))
        .thenAnswer((realInvocation) => Future.value(createdUser));

    final expectStates = [
      PagedListAsyncState<dynamic>.success(0, [ItemTask.create(user)]),
      PagedListAsyncState<dynamic>.success(0, [createdUser])
    ];

    expectLater(bloc, emitsInOrder(expectStates));

    bloc.addItem(user);
  });

  test('add item failure test', () async {
    final user = User.createFakeUser();
    when(userMockRepository.add(user))
        .thenAnswer((realInvocation) => throw ('User error'));

    final expectStates = [
      PagedListAsyncState<dynamic>.success(0, [ItemTask.create(user)]),
      PagedListAsyncState<dynamic>.success(0, [
        ItemTask.create(user)
            .copyWith(taskStatus: AsyncState.error('User error'))
      ])
    ];

    expectLater(bloc, emitsInOrder(expectStates));

    bloc.addItem(user);
  });

  test('delete item success test', () async {
    final fakeUsers = List.generate(3, (index) => User.createFakeUser());

    when(userMockRepository.remove(fakeUsers[1]))
        .thenAnswer((realInvocation) => Future.value(true));

    bloc.emit(PagedListAsyncState<dynamic>.success(1, <dynamic>[...fakeUsers]));
    //список в процессе удаления
    final inProcessList = [
      fakeUsers[0],
      ItemTask.create(fakeUsers[1]),
      fakeUsers[2]
    ];
    //список после удаления
    final resultList = [fakeUsers[0], fakeUsers[2]];

    final expectStates = [
      PagedListAsyncState<dynamic>.success(1, inProcessList),
      PagedListAsyncState<dynamic>.success(1, resultList)
    ];

    expectLater(bloc, emitsInOrder(expectStates));

    bloc.deleteItem(fakeUsers[1]);
  });

  test('element test', () async {
    final fakeUsers = List.generate(10, (index) => User.createFakeUser());

    // Мокаем наш запрос
    when(userMockRepository.fetch(1, 10))
        .thenAnswer((realInvocation) => Future.value(fakeUsers.toList()));

    // Проверяем последовательность состояний
    final expectStates = [true, false];

    expectLater(
        bloc.map((state) => state.inProgress), emitsInOrder(expectStates),
        reason: 'emitsInOrder');

    bloc.fetchItems();
  });
}
