import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/api_feed_provider.dart';
import 'widgets/animated_3d_background.dart';
import 'screens/home_screen.dart';
import 'screens/updates_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/fans_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/experiments_hub_screen.dart';
import 'screens/api_feed_screen.dart';
import 'screens/leadership_screen.dart';
import 'screens/events_screen.dart';
import 'screens/membership_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FanAssociationApp());
}

class FanAssociationApp extends StatelessWidget {
  const FanAssociationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ApiFeedProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Srekar's Association",
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            builder: (context, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  const Positioned.fill(
                    child: Animated3DBackground(),
                  ),
                  ?child,
                ],
              );
            },
            initialRoute: '/',
            routes: {
              '/': (context) => const MainNavigationScreen(),
              '/experiments': (context) => const ExperimentsHubScreen(),
              '/api-feed': (context) => const ApiFeedScreen(),
              '/leadership': (context) => const LeadershipScreen(),
              '/events': (context) => const EventsScreen(),
              '/membership': (context) => const MembershipScreen(),
              '/gallery': (context) => const GalleryScreen(),
              '/fans': (context) => const FansScreen(),
              '/updates': (context) => const UpdatesScreen(),
            },
          );
        },
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        onNavigateToUpdates: () => _navigateToTab(1),
        onNavigateToGallery: () => _navigateToTab(2),
        onNavigateToFans: () => _navigateToTab(3),
      ),
      const UpdatesScreen(),
      const GalleryScreen(),
      const FansScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF161226).withValues(alpha: 0.90)
              : Colors.white.withValues(alpha: 0.90),
          selectedIndex: _currentIndex,
          onDestinationSelected: _navigateToTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppTheme.primaryColor),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.newspaper_outlined),
              selectedIcon: Icon(Icons.newspaper_rounded, color: AppTheme.primaryColor),
              label: 'Updates',
            ),
            NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              selectedIcon: Icon(Icons.photo_library_rounded, color: AppTheme.primaryColor),
              label: 'Gallery',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded),
              selectedIcon: Icon(Icons.favorite_rounded, color: AppTheme.accentHeart),
              label: 'Fans',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primaryColor),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
