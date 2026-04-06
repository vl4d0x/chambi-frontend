import 'package:chambi_frontend/core/router/app_router.dart';
import 'package:chambi_frontend/core/theme/app_theme.dart';
import 'package:chambi_frontend/viewmodels/auth_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  // TODO(backend): Add WidgetsFlutterBinding.ensureInitialized() and
  // Firebase.initializeApp() before runApp when connecting Firebase.
  runApp(const TaskrApp());
}

class TaskrApp extends StatelessWidget {
  const TaskrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const _AppWithRouter(),
    );
  }
}

class _AppWithRouter extends StatefulWidget {
  const _AppWithRouter();

  @override
  State<_AppWithRouter> createState() => _AppWithRouterState();
}

class _AppWithRouterState extends State<_AppWithRouter> {
  late final _router;

  @override
  void initState() {
    super.initState();
    // Router is created once and depends on AuthViewModel for redirect logic
    _router = createRouter(context.read<AuthViewModel>());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: 'Chambi',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.accent,
        scaffoldBackgroundColor: AppColors.background,
        barBackgroundColor: AppColors.background,
        textTheme: CupertinoTextThemeData(
          primaryColor: AppColors.textPrimary,
          textStyle: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: '.SF Pro Display',
          ),
        ),
      ),
    );
  }
}
