import 'package:cleanflutter/data/result/result.dart';

class UseCaseCallback<T> {
  List<Future<Result<T>>> tasks = [];

  void addTask(Future<Result<T>> task) {
    tasks.add(task);
  }

  List<Future<Result<T>>> getTasks() {
    return tasks;
  }

  void clearTasks(){
    tasks.clear();
  }
}
