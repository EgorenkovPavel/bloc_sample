// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:cubit_sample/data/user.dart';
import 'package:cubit_sample/data/repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('Async List test', (){
    final fakeUsers = List.generate(5, (index) => User.createFakeUser());
    final f1 = PagedListAsyncState.success(1, fakeUsers.toList());
    final f2 = PagedListAsyncState.success(1, fakeUsers.toList());
    expect(f1 == f2,true,reason: 'f1 == f2');
  });

  test('AsyncFields', () {
    final fieldProgress1 = AsyncState.inProgress();
    final fieldProgress2 = AsyncState.inProgress();
    final fieldData1 = AsyncState.success(1);
    final fieldData2 = AsyncState.success(1);

    final fieldList1 = PagedListAsyncState.success(1,[1]);
    final fieldList2 = PagedListAsyncState.success(1,[1]);
    final fieldList3 = PagedListAsyncState.success(1,[1, 2]);

    expect(fieldData1 == fieldProgress1, false,
        reason: 'fieldData1 == fieldProgress1');
    expect(fieldProgress1 == fieldProgress2, true,
        reason: 'fieldProgress1 == fieldProgress2');
    expect(fieldData1 == fieldData2, true, reason: 'fieldData1 == fieldData2');
    expect(fieldList1 == fieldList2, true, reason: 'fieldList1 == fieldList2');
    expect(fieldList1 == fieldList3, false, reason: 'fieldList1 == fieldList3');
  });

  test('paged async field', () {

    final inProgress1 = PagedListAsyncState.inProgress(1,payload: [1,2]);
    final data1 = PagedListAsyncState.success(1,[1,2]);
    final failure1 = PagedListAsyncState.error(1,'Error');
    final finished1 = PagedListAsyncState.success(1,[1,2],isFinished: true);

    final inProgress2 = PagedListAsyncState.inProgress(1,payload: [1,2]);
    final data2 = PagedListAsyncState.success(1,[1,2]);
    final failure2 = PagedListAsyncState.error(1,'Error');
    final finished2 = PagedListAsyncState.success(1,[1,2],isFinished: true);

    final data3 = PagedListAsyncState.success(1,[1,2,3]);

    expect(inProgress1 == data1, false, reason: 'inProgress1 == data1');
    expect(data1 == failure1, false, reason: 'data1 == failure1');
    expect(failure1 == finished1, false, reason: 'failure1 == finished1');

    expect(inProgress1 == inProgress2, true, reason: 'inProgress1 == inProgress2');
    expect(data1 == data2, true, reason: 'data1 == data2');
    expect(data1 != data3, true, reason: 'data1 == data3');
    expect(failure1 == failure2, true, reason: 'failure1 == failure2');
    expect(finished1 == finished2, true, reason: 'finished1 == finished2');

  });

}
