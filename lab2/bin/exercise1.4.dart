void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    double sum = 0;
    for (String arg in arguments) {
      sum += double.parse(arg);
    }
    int count = arguments.length;
    print(sum/count);
  }
}