import 'dart:math';
import 'package:username_gen/username_gen.dart';

void main() {
  final algo1 = BigO.init(10000);
  final algo2 = BigO.init(50000);
  final algo3 = BigO.init(100000);

  algo1.runFunc('O(1)', algo1.getUserAge, 500);
  algo2.runFunc('O(1)', algo2.getUserAge, 500);
  algo3.runFunc('O(1)', algo3.getUserAge, 500);

  algo1.runFunc('O(n)', algo1.getUsersByAge, 45);
  algo2.runFunc('O(n)', algo2.getUsersByAge, 45);
  algo3.runFunc('O(n)', algo3.getUsersByAge, 45);

  final sortedMap1 = algo1.runSortFunc('O(n^2)', algo1.sortUsersByAge);
  final sortedMap2 = algo2.runSortFunc('O(n^2)', algo2.sortUsersByAge);
  final sortedMap3 = algo3.runSortFunc('O(n^2)', algo3.sortUsersByAge);

  algo1.runSearchFunc('O(log N)', algo1.getFirstByAge, sortedMap1, 45);
  algo2.runSearchFunc('O(log N)', algo2.getFirstByAge, sortedMap2, 45);
  algo3.runSearchFunc('O(log N)', algo3.getFirstByAge, sortedMap3, 45);
}

class BigO {
  final Map<int, User> users;

  BigO(this.users);

  factory BigO.init(int num) {
    final Map<int, User> tmp = {};
    final userGen = UsernameGen();
    final random = Random();
    final int min = 18;
    final int max = 100;

    for (var i = 0; i < num; i++) {
      final username = userGen.generate();
      final age = min + random.nextInt(max - min);

      tmp[i] = User(username, age);
    }

    return BigO(tmp);
  }

  // O(1) - constant
  //
  // time
  // |
  // |
  // |  ⭐       ⭐       ⭐
  // |_ _ _ _ _ _ _ _ _ _ _ _ _ number of records
  //   alg1    alg2    alg3
  //
  int getUserAge(int userId) {
    final user = users[userId];
    return user != null ? user.age : 0;
  }

  // O(N) - linear
  //
  // time
  // |                  ⭐
  // |          ⭐
  // |  ⭐
  // |_ _ _ _ _ _ _ _ _ _ _ _ _ number of records
  //   alg1    alg2    alg3
  //
  int getUsersByAge(int age) {
    int numberUsers = 0;
    for (var i = 0; i < users.length; i++) {
      if (users[i]!.age == age) {
        numberUsers++;
      }
    }

    return numberUsers;
  }

  // O(N^2) - quadratic
  //
  // time
  // |                  ⭐
  // |
  // |
  // |
  // |
  // |
  // |
  // |          ⭐
  // |
  // |  ⭐
  // |_ _ _ _ _ _ _ _ _ _ _ _ _ number of records
  //   alg1    alg2    alg3
  //
  // Bubble Sort
  //
  Map<int, User> sortUsersByAge() {
    Map<int, User> tmp = {...users};
    int records = tmp.length;

    for (int i = 0; i < records - 1; i++) {
      for (int j = 0; j < records - i - 1; j++) {
        //print('Index (i - j): $i - $j');
        //print('User age (j - j + 1): ${tmp[j]!.age} - ${tmp[j + 1]!.age}');

        if (tmp[j]!.age > tmp[j + 1]!.age) {
          //Swap
          //print('Swap users');

          final User tmpUser = tmp[j] as User;
          tmp[j] = tmp[j + 1] as User;
          tmp[j + 1] = tmpUser;
        }
      }
    }

    return tmp;
  }

  // O(log N) - logarithmic
  //
  // time
  // |
  // |
  // |
  // |
  // |
  // |
  // |
  // |
  // |          ⭐       ⭐
  // |  ⭐
  // |_ _ _ _ _ _ _ _ _ _ _ _ _ number of records
  //   alg1    alg2    alg3
  //
  // Binary Search
  //
  User? getFirstByAge(Map<int, User> sortedMap, int age, int min, int max) {
    if (max >= min) {
      int mid = ((max + min) / 2).floor();

      if (sortedMap[mid]!.age == age) {
        return sortedMap[mid] as User;
      } else if (sortedMap[mid]!.age < age) {
        getFirstByAge(sortedMap, age, mid + 1, max);
      } else {
        getFirstByAge(sortedMap, age, min, mid - 1);
      }
    }

    return null;
  }

  void runFunc(String label, int Function(int) func, int param) {
    Stopwatch stopwatch = Stopwatch()..start();

    print('result: ${func.call(param)}');

    stopwatch.stop();
    print('$label time elapsed ${stopwatch.elapsed}');
  }

  Map<int, User> runSortFunc(String label, Map<int, User> Function() func) {
    Stopwatch stopwatch = Stopwatch()..start();

    final result = func.call();

    stopwatch.stop();
    print('$label time elapsed ${stopwatch.elapsed}');

    return result;
  }

  User? runSearchFunc(
      String label,
      User? Function(Map<int, User>, int, int, int) func,
      Map<int, User> sortedMap,
      int age) {
    Stopwatch stopwatch = Stopwatch()..start();

    final user = func.call(sortedMap, age, 0, sortedMap.length - 1);

    if (user != null) {
      print('User name: ${user.username}, Age: ${user.age}');
    }

    stopwatch.stop();
    print('$label time elapsed ${stopwatch.elapsed}');

    return user;
  }
}

class User {
  final String username;
  final int age;

  User(this.username, this.age);
}
