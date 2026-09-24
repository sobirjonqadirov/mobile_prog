void main(List<String> arguments) {
  if (arguments.length == 2) {
    print('2 arguments have been passed: ${arguments.join(', ')}');
  } else {
    print('usageWarning: Please provide exactly 2 arguments.');
  }
}