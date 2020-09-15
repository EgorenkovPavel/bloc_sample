// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'dart:collection';

import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:cubit_sample/data/user.dart';
import 'package:cubit_sample/data/repository.dart';
import 'package:flutter_test/flutter_test.dart';

class ClassA {
  ClassA(this.name);
  final String name;
}

class ClassB {
  ClassB(this.classA);
  final ClassA classA;
}

class ClassC {
  ClassC(this.items);
  final Iterable items;
}

class ClassD {
  ClassD(this.items);
  final List items;
}

void main() {
  test('vars', () {
    String mutableName = 'Name1';
    final classB = ClassA(mutableName);
    expect(classB.name, 'Name1', reason: 'Name1');
    mutableName = 'Name2';
    expect(classB.name, 'Name2', reason: 'Name2');
  });

  test('objects', () {
    String mutableName = 'Name1';
    ClassA classA = ClassA(mutableName);
    final classB = ClassB(classA);
    expect(classB.classA.name, 'Name1', reason: 'class b name');
    mutableName = 'Name2';
    expect(classB.classA.name, 'Name1', reason: 'class b name 2 ');
    classA = ClassA('Name3');
    expect(classB.classA.name, 'Name1', reason: 'class b name 3');
  });

  test('iterable mutable', () {
    List mutableList = [1,2];
    final classC = ClassC(mutableList);
    expect(classC.items.length, 2,reason: 'init');
    mutableList.add(3);
    expect(classC.items.length, 3,reason: 'add');
    mutableList.removeAt(1);
    mutableList.insert(0, 2);
    expect(classC.items.elementAt(0), 2,reason: 'edit');
  });

  test('to list', () {
    List mutableList = [1,2];
    final classC = ClassC(mutableList.toList());
    expect(classC.items.length, 2,reason: 'init');
    mutableList.add(3);
    expect(classC.items.length, 3,reason: 'add');
    mutableList.removeAt(1);
    mutableList.insert(0, 2);
    expect(classC.items.elementAt(0), 2,reason: 'edit');
  });

  test('to list growable: false', () {
    List mutableList = [1,2];
    final classD = ClassD(mutableList.toList(growable: false));
    expect(classD.items.length, 2,reason: 'init');
    classD.items[0] = 3;
    expect(classD.items.elementAt(0), 3,reason: 'edit');

//    classD.items.add(3);
//    expect(classD.items.length, 3,reason: 'add');
  });

  test('to list unmodifiable', () {
    List mutableList = [1,2];
    final classD = ClassD(List.unmodifiable(mutableList));
    expect(classD.items.length, 2,reason: 'init');

    mutableList[0] = 3;
    expect(classD.items.elementAt(0), 1,reason: 'edit');

    classD.items[0] = 3;
    expect(classD.items.elementAt(0), 1,reason: 'edit');
  });

  test('to list UnmodifiableListView', () {
    List mutableList = [1,2];
    final classD = ClassD(UnmodifiableListView(mutableList));

    mutableList[0] = 3;
    expect(classD.items.elementAt(0), 1,reason: 'edit 1');

    classD.items[0] = 3;
    expect(classD.items.elementAt(0), 1,reason: 'edit 2');
  });

  test('iterable immutable', () {
    List mutableList = [1,2];
    final classC = ClassC(mutableList);
    expect(classC.items.length, 2,reason: 'init');
    mutableList.add(3);
    expect(classC.items.length, 3,reason: 'add');
  });
}
