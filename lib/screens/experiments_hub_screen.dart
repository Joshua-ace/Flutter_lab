import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_heart.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/tilt_3d_card.dart';

class ExperimentsHubScreen extends StatefulWidget {
  const ExperimentsHubScreen({super.key});

  @override
  State<ExperimentsHubScreen> createState() => _ExperimentsHubScreenState();
}

class _ExperimentsHubScreenState extends State<ExperimentsHubScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  int _cheerCount = 42;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showAnimationDemoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Experiment 8: Animation Framework Showcase',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Demonstrates Flutter AnimationController, CurvedAnimation, Tween, Scale, Fade, and Hero animations.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      PulseHeartButton(
                        count: _cheerCount,
                        label: 'Cheer',
                        onTap: () {
                          setModalState(() => _cheerCount++);
                          setState(() => _cheerCount++);
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text('Scale & Fade Pulse', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close Showcase'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text('🧪 ', style: TextStyle(fontSize: 20)),
            Text('Flutter Lab Experiments Hub'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Light / Dark Theme (Exp 5 & 6)',
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 48 : (isTablet ? 24 : 16),
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryDark, AppTheme.primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Prescribed Lab Curriculum',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            ResponsiveLayout.isMobile(context)
                                ? '📱 Mobile'
                                : (ResponsiveLayout.isTablet(context) ? '💻 Tablet' : '🖥️ Desktop'),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Experiments 2 through 10',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Explore all interactive implementations integrated directly inside the Srekar Fan Association application.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Experiment Cards List
                _buildExperimentCard(
                  expNum: 'Exp 2',
                  title: 'Flutter Widgets & Layout Structures',
                  subconcepts: [
                    '2.a) Core widgets: Text, Image, Container, Icon, Buttons, Card',
                    '2.b) Layout structures: Row, Column, Stack with Positioned overlays',
                  ],
                  icon: Icons.widgets_outlined,
                  color: Colors.purple,
                  actionLabel: 'View Gallery & Hero Cards',
                  onAction: () => Navigator.pushNamed(context, '/gallery'),
                ),

                _buildExperimentCard(
                  expNum: 'Exp 3',
                  title: 'Responsive UI & Adaptability',
                  subconcepts: [
                    '3.a) Fluid UI adapting from mobile phones to tablets and desktop screens',
                    '3.b) Media queries & Breakpoints helper (ResponsiveLayout, LayoutBuilder)',
                  ],
                  icon: Icons.devices,
                  color: Colors.indigo,
                  actionLabel: 'Test Home Responsive Grid',
                  onAction: () => Navigator.pushNamed(context, '/'),
                ),

                _buildExperimentCard(
                  expNum: 'Exp 4',
                  title: 'Navigation & Named Routes',
                  subconcepts: [
                    '4.a) Imperative navigation with Navigator.push() and Navigator.pop()',
                    '4.b) Declarative Named Routes in MaterialApp with arguments passing',
                  ],
                  icon: Icons.navigation_outlined,
                  color: Colors.teal,
                  actionLabel: 'Launch Events via Named Route',
                  onAction: () => Navigator.pushNamed(context, '/events'),
                ),

                _buildExperimentCard(
                  expNum: 'Exp 5',
                  title: 'Stateful vs Stateless Widgets & State Management',
                  subconcepts: [
                    '5.a) Architectural separation of Stateless vs Stateful widget lifecycles',
                    '5.b) State management via setState (ephemeral) and Provider (ChangeNotifier)',
                  ],
                  icon: Icons.tune,
                  color: Colors.orange.shade800,
                  actionLabel: 'Toggle Theme via Provider',
                  onAction: () => themeProvider.toggleTheme(),
                ),

                _buildExperimentCard(
                  expNum: 'Exp 6',
                  title: 'Custom Widgets & Styling',
                  subconcepts: [
                    '6.a) Reusable modular widgets: StatCard, EventCard, AnnouncementCard',
                    '6.b) Theming via ThemeData (Light & Dark), Material 3 tokens, custom fonts',
                  ],
                  icon: Icons.palette_outlined,
                  color: Colors.pink,
                  actionLabel: 'View Custom Widget Cards',
                  onAction: () => Navigator.pushNamed(context, '/'),
                ),

                _buildExperimentCard(
                  expNum: 'Exp 7',
                  title: 'Forms, Input Fields & Validation',
                  subconcepts: [
                    '7.a) Form fields: TextFormField, DropdownButton, Checkboxes, Phone keyboard',
                    '7.b) Validation with GlobalKey<FormState>, regex patterns, error handling',
                  ],
                  icon: Icons.how_to_reg_outlined,
                  color: Colors.deepOrange,
                  actionLabel: 'Open Membership Registration Form',
                  onAction: () => Navigator.pushNamed(context, '/membership'),
                ),

                _buildExperimentCard(
                  expNum: 'Exp 8',
                  title: 'Animations Framework & Types',
                  subconcepts: [
                    '8.a) AnimationController, CurvedAnimation, Tween, and AnimatedBuilder',
                    '8.b) Fade, Slide, Scale/Pulse, Rotation, and Hero transitions',
                  ],
                  icon: Icons.animation,
                  color: Colors.deepPurple,
                  actionLabel: 'Open Animation Showcase Modal',
                  onAction: _showAnimationDemoModal,
                ),

                _buildExperimentCard(
                  expNum: 'Exp 9',
                  title: 'REST API Integration & Meaningful UI',
                  subconcepts: [
                    '9.a) HTTP GET requests to public REST API with timeout & error handling',
                    '9.b) Display with 3 states (Loading, Error with Retry, Success Feed), Search & Pull-to-Refresh',
                  ],
                  icon: Icons.cloud_download_outlined,
                  color: Colors.blue.shade700,
                  actionLabel: 'Open REST API Community Feed',
                  onAction: () => Navigator.pushNamed(context, '/api-feed'),
                ),

                _buildExperimentCard(
                  expNum: 'Exp 10',
                  title: 'Unit Testing & Flutter Debugging Tools',
                  subconcepts: [
                    '10.a) Unit tests for models & providers + Widget tests with testWidgets',
                    '10.b) Flutter DevTools, debugPrint, assertion inspection, and fix verification',
                  ],
                  icon: Icons.bug_report_outlined,
                  color: Colors.green.shade700,
                  actionLabel: 'View Test Suite & Debugging Notes',
                  onAction: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Experiment 10 Evidence'),
                        content: const Text(
                          'Unit and widget test suites are executed via "flutter test" in the test/ directory.\n\n'
                          'Includes testing model serialization, form validation regex, provider state updates, and smoke tests.',
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExperimentCard({
    required String expNum,
    required String title,
    required List<String> subconcepts,
    required IconData icon,
    required Color color,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Tilt3DCard(
        borderRadius: 18,
        elevation: 8,
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        expNum,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(icon, color: color),
                  ],
                ),
                const SizedBox(height: 12),
                ...subconcepts.map(
                  (concept) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        Expanded(
                          child: Text(
                            concept,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: Text(actionLabel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
