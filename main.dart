import 'package:flutter/material.dart';

void main() {
  runApp(const FanAssociationApp());
}

class FanAssociationApp extends StatelessWidget {
  const FanAssociationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sreekar's Association",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F7FC),
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================
// HOME PAGE WITH BOTTOM NAVIGATION
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeContent(),
    AboutPage(),
    UpdatesPage(),
    GalleryPage(),
    JoinPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'About',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper),
            label: 'Updates',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Join',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  // Replace these URLs with your actual images.
  static const String associationImage =
      'https://via.placeholder.com/300x300.png?text=Sai+Charan';

  static const String presidentImage =
      'https://via.placeholder.com/300x300.png?text=President';

  static const String secretaryImage =
      'https://via.placeholder.com/300x300.png?text=Secretary';

  static const String treasurerImage =
      'https://via.placeholder.com/300x300.png?text=Treasurer';

  static const String managerImage =
      'https://via.placeholder.com/300x300.png?text=Manager';

  static const String coordinatorImage =
      'https://via.placeholder.com/300x300.png?text=Coordinator';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            // ==================================================
            // ASSOCIATION PHOTO
            // ==================================================

            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.deepPurple.shade100,
                backgroundImage: const NetworkImage(
                  associationImage,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // TITLE
            // ==================================================

            const Center(
              child: Text(
                "Sreekar's Association",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                'Official Fan Association',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // LEADERSHIP
            // ==================================================

            const SectionTitle(
              title: 'Association Leadership',
              icon: Icons.groups,
            ),

            const SizedBox(height: 20),

            // PRESIDENT
            Center(
              child: LeadershipPerson(
                imageUrl: presidentImage,
                name: 'Joshua',
                role: 'President',
                radius: 48,
              ),
            ),

            const SizedBox(height: 30),

            // SECRETARY + TREASURER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LeadershipPerson(
                  imageUrl: secretaryImage,
                  name: 'Secretary Name',
                  role: 'General Secretary',
                ),
                LeadershipPerson(
                  imageUrl: treasurerImage,
                  name: 'Treasurer Name',
                  role: 'Treasurer',
                ),
              ],
            ),

            const SizedBox(height: 30),

            // MANAGER + COORDINATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LeadershipPerson(
                  imageUrl: managerImage,
                  name: 'Manager Name',
                  role: 'Manager',
                ),
                LeadershipPerson(
                  imageUrl: coordinatorImage,
                  name: 'Coordinator Name',
                  role: 'Coordinator',
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ==================================================
            // WELCOME CARD
            // ==================================================

            Card(
              elevation: 3,
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome Fans ❤️',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Welcome to the official Sreekar\'s '
                          'Association. Stay connected with the latest '
                          'news, photos, events and updates.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // LATEST UPDATE
            // ==================================================

            const SectionTitle(
              title: 'Latest Update',
              icon: Icons.campaign,
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                leading: const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.campaign,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  'Welcome to our Fan Association!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Stay tuned for more updates and events.',
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 17,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // JOIN BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Welcome! Please visit the Join section.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite),
                label: const Text(
                  'Join the Fan Association',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// LEADERSHIP PERSON WIDGET
// ============================================================

class LeadershipPerson extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String role;
  final double radius;

  const LeadershipPerson({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.role,
    this.radius = 38,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Column(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.deepPurple.shade100,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 10),
          Text(
            role,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.deepPurple,
          size: 27,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ABOUT PAGE
// ============================================================

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'About Us',
              icon: Icons.groups,
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Sreekar's Association",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Our fan association is a community of passionate '
                          'fans who come together to celebrate, support and '
                          'share their love for Sreekar.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'We organize fan activities, events, celebrations, '
                          'social initiatives and community programs.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const SectionTitle(
              title: 'Our Activities',
              icon: Icons.event,
            ),

            const SizedBox(height: 15),

            const ActivityCard(
              icon: Icons.celebration,
              title: 'Fan Celebrations',
              description:
              'Special celebrations and events organized for fans.',
            ),

            const ActivityCard(
              icon: Icons.volunteer_activism,
              title: 'Social Activities',
              description:
              'Community service and social welfare activities.',
            ),

            const ActivityCard(
              icon: Icons.groups,
              title: 'Fan Meets',
              description:
              'Fan meetings and community gatherings.',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ACTIVITY CARD
// ============================================================

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Icon(
            icon,
            color: Colors.deepPurple,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(description),
        ),
      ),
    );
  }
}

// ============================================================
// UPDATES PAGE
// ============================================================

class UpdatesPage extends StatelessWidget {
  const UpdatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Latest Updates',
              icon: Icons.newspaper,
            ),

            const SizedBox(height: 25),

            UpdateCard(
              title: 'Fan Association Started',
              description:
              'Welcome to the official Sai Charan Fan\'s Association.',
              date: 'Latest',
              icon: Icons.campaign,
            ),

            UpdateCard(
              title: 'Upcoming Fan Event',
              description:
              'More information about upcoming events will be shared soon.',
              date: 'Upcoming',
              icon: Icons.event,
            ),

            UpdateCard(
              title: 'Community Activities',
              description:
              'Stay connected for information about our social activities.',
              date: 'News',
              icon: Icons.volunteer_activism,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// UPDATE CARD
// ============================================================

class UpdateCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final IconData icon;

  const UpdateCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    description,
                    style: const TextStyle(
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.deepPurple.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// GALLERY PAGE
// ============================================================

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  final List<String> images = const [
    'https://via.placeholder.com/600x600.png?text=Photo+1',
    'https://via.placeholder.com/600x600.png?text=Photo+2',
    'https://via.placeholder.com/600x600.png?text=Photo+3',
    'https://via.placeholder.com/600x600.png?text=Photo+4',
    'https://via.placeholder.com/600x600.png?text=Photo+5',
    'https://via.placeholder.com/600x600.png?text=Photo+6',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Gallery',
              icon: Icons.photo_library,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          color: Colors.deepPurple.shade100,
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.deepPurple,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// JOIN PAGE
// ============================================================

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void joinAssociation() {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your name and phone number.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Thank you for joining the Fan Association! ❤️',
        ),
      ),
    );

    nameController.clear();
    phoneController.clear();
    cityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Join Us ❤️',
              icon: Icons.favorite,
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.favorite,
                      size: 55,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Become a Member',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Join our fan community and stay connected '
                          'with all the latest activities.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: joinAssociation,
                        icon: const Icon(Icons.favorite),
                        label: const Text(
                          'Join Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PAGE HEADER
// ============================================================

class PageHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const PageHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.deepPurple.shade100,
          child: Icon(
            icon,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
