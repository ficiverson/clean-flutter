import 'package:cleanflutter/data/result/result.dart';

abstract class BaseUseCase<P,T>{
  P params;
  List<Future<Result<T>>> _results = [];

  Stream<Result<T>> execute();

  void addResult(Future<Result<T>> task){
    _results.add(task);
  }

  Stream<Result<T>> notifyResults(){
    Stream<Result<T>> stream =  new Stream.fromFutures(_results);
    _results.clear();
    return stream;
  }
}