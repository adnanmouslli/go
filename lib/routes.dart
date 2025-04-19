import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:go/core/constant/routes.dart';
import 'package:go/view/pages/auth/login.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: "/", page: () => const Login()),
  GetPage(name: AppRoute.login, page: () => const Login()),
];
