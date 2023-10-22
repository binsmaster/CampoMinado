import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../Views/campoMinadoScreen.dart';
import '../../Views/Ui/theme.dart'; // Importe o arquivo de tema

class ResponsividadeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          return BouncingScrollWrapper.builder(
              context, _buildPage(settings.name ?? ''),
              dragWithMouse: true);
        });
      },
      debugShowCheckedModeBanner: false,
      theme: customTheme, // Use o tema personalizado
    );
  }

  Widget _buildPage(String name) {
    switch (name) {
      case '/':
        return CampoMinadoGame();
      default:
        return const SizedBox.shrink();
    }
  }
}
