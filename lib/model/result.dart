
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