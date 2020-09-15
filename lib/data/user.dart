import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  User({this.name, this.id});

  final String name;
  final int id;

  factory User.createFakeUser() => User(name: faker.person.firstName());

  @override
  List<Object> get props => [name, id];

  User copyWith({
    String name,
    int id,
  }) {
    if ((name == null || identical(name, this.name)) &&
        (id == null || identical(id, this.id))) {
      return this;
    }

    return User(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => super.hashCode ^ name.hashCode ^ id.hashCode;
}
