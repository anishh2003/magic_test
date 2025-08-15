import 'package:integration_test/integration_test.dart';

import '../basic_flow_test.dart' as basic_flow_test;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Run basic flow tests
  basic_flow_test.main();
}
