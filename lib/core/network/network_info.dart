// import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  // final DataConnectionChecker dataConnectionChecker;

  // NetworkInfoImpl(this.dataConnectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => Future.value(true);
  // Future<bool> get isConnected => dataConnectionChecker.hasConnection;
  // Future<bool> get isConnected {
  //   dataConnectionChecker.hasConnection ;
  //   return Future.value(true);
  // }
}
