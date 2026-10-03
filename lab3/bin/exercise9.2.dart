abstract interface class DBConnector {
  void connect();
}

class MySQLConnector implements DBConnector {
  @override
  void connect() {
    print('Connected to MySQL database.');
  }
}

void main() {
  MySQLConnector connector = MySQLConnector();

  connector.connect();
}