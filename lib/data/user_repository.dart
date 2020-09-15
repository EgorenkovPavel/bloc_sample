import 'dart:math';

import 'package:cubit_sample/data/user.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'repository.dart';

final random = Random();

class UserRepository extends Mock implements ListRepository<User> {
  UserRepository() {
    final fp = _generateItems(10);

    when(this.fetch(1, 10)).thenAnswer(
        (_) => Future.delayed(Duration(milliseconds: 800), () => fp));
    when(this.fetch(2, 10)).thenAnswer((_) =>
        Future.delayed(Duration(milliseconds: 800), () => _generateItems(10)));
    when(this.fetch(3, 10)).thenAnswer((_) =>
        Future.delayed(Duration(milliseconds: 800), () => _generateItems(1)));

    //when(this.add(createNewFakeModel())).thenThrow('Error');
    // when(this.remove(fp.elementAt(3))).thenThrow('Error');
  }

  List<User> _generateItems(int count) => List.generate(count, (index) {
        return User(name: faker.person.firstName(), id: random.nextInt(100));
      });

  @override
  Future<User> add(User item) {
    return Future.delayed(const Duration(milliseconds: 500), () {
      return item.copyWith(id: random.nextInt(100));
    });
  }

  @override
  Future<bool> remove(User item) {
    return Future.delayed(const Duration(milliseconds: 500), () => true);
  }
}
