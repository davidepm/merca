import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/data/auth_local_repository.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/exhibiciones/data/exhibiciones_local_repository.dart';
import '../features/exhibiciones/presentation/exhibiciones_screen.dart';
import '../features/exhibiciones/providers/exhibiciones_provider.dart';
import '../features/historial/presentation/historial_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/perfil/presentation/perfil_screen.dart';
import '../features/visitas/data/visitas_local_repository.dart';
import '../features/visitas/presentation/visitas_screen.dart';
import '../features/visitas/providers/visitas_provider.dart';

class GestionPdvApp extends StatelessWidget {
  const GestionPdvApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(AuthLocalRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => VisitasProvider(VisitasLocalRepository())..load(),
      ),
      ChangeNotifierProvider(
        create: (_) =>
            ExhibicionesProvider(ExhibicionesLocalRepository())..load(),
      ),
    ],
    child: MaterialApp(
      title: 'Gestion PDV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) =>
            auth.isAuthenticated ? const AppShell() : const LoginScreen(),
      ),
    ),
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final _screens = const [
    HomeScreen(),
    VisitasScreen(),
    ExhibicionesScreen(),
    HistorialScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: _screens[_selectedIndex]),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: 'Visitas',
        ),
        NavigationDestination(
          icon: Icon(Icons.view_quilt_outlined),
          selectedIcon: Icon(Icons.view_quilt),
          label: 'Exhib.',
          tooltip: 'Exhibiciones',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'Historial',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    ),
  );
}
