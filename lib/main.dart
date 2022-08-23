import 'package:flutter/material.dart';
import 'package:skin_camera/pages/home.dart';
import 'package:skin_camera/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future<dynamic>.delayed(const Duration(seconds: 1));
  runApp(const AppProvider());
}

class AppProvider extends StatelessWidget {
  const AppProvider({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const ThemeProvider(
      child: MaterialSkinApp()
    );
  }
}

class MaterialSkinApp extends StatelessWidget {
  const MaterialSkinApp({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skin Classification',
      theme: ThemeProvider.of(context)?.themeData(Theme.of(context)),
      home: const HomeScreen(title: 'Skin Classification'),
    );
  }
}

class _PageRoute<T extends Object> extends MaterialPageRoute<T> {
  _PageRoute({required WidgetBuilder builder, required RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(_, Animation<double> animation, __, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }
}