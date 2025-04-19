import 'package:get/get.dart';
import 'package:go/services/services.dart';

class InitialBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(() => MyServices().init(), permanent: true);
  }
}
