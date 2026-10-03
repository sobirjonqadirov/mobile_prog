class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  String appName = 'My Dart App';
}

void main() {
  AppConfig config1 = AppConfig();
  AppConfig config2 = AppConfig();

  print(config1.appName);

  print(identical(config1, config2));
}