
enum DataPolicy{
  cache,network,network_cache
}

enum Status{
  ok, fail
}
class Result<T> {

  Status status;
  T data;

  Result(Status status, T data){
    this.status = status;
    this.data = data;
  }

  T getData() {
    return data;
  }

  Status getStatus(){
    return status;
  }
}

class Success<T> extends Result<T>{
  Success(T data, Status dataStatus) : super(dataStatus,data);
}

class Error<T> extends Result<T>{
  Error(T data, Status dataStatus, String error) : super(dataStatus,data);
}