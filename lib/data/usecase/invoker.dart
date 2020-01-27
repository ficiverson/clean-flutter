import 'package:cleanflutter/data/result/result.dart';
import 'base_use_case.dart';

class Invoker {
  Stream<Result> execute(BaseUseCase useCase) async*  {
    useCase.invoke();
    for (var task in useCase.callback.getTasks()) {
      var result = await task;
      yield result;
    }
    useCase.callback.clearTasks();
  }
}

