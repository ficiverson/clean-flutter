import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/data/usecase/use_case_callback.dart';

abstract class BaseUseCase<P,T>{
  P params;
  UseCaseCallback callback;
  void invoke();

  BaseUseCase(){
    callback = UseCaseCallback();
  }

  void notifyListeners(Future<Result<T>> task){
    callback.addTask(task);
  }

  BaseUseCase<P,T> withParams(P params) {
    this.params = params;
    return this;
  }
}

