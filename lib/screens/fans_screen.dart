import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class FansScreen extends StatefulWidget {
  const FansScreen({super.key});

  @override
  State<FansScreen> createState() => _FansScreenState();
}

class _FansScreenState extends State<FansScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showPostDialog(BuildContext context) {
    final currentMember = AuthService().currentMember;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('❤️ ', style: TextStyle(fontSize: 22)),
                const Text(
                  'Post on Fan Wall',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Posting as ${currentMember.name} (${currentMember.city})',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your love, wishes and cheers for Srekar...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentHeart,
                ),
                onPressed: () {
                  final text = _messageController.text.trim();
                  if (text.isNotEmpty) {
                    DatabaseService().addFanPost(
                      currentMember.name,
                      currentMember.city,
                      text,
                    );
                    _messageController.clear();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your message was posted on the Fan Wall! ❤️'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text('Publish Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

    return ListenableBuilder(
      listenable: db,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppTheme.bgLight,
          appBar: AppBar(
            title: Row(
              children: const [
                Text('❤️ ', style: TextStyle(fontSize: 20)),
                Text('Fan Community'),
              ],
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  icon: Icon(Icons.forum_outlined),
                  text: 'Fan Wall',
                ),
                Tab(
                  icon: Icon(Icons.how_to_vote_outlined),
                  text: 'Polls & Votes',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppTheme.accentHeart,
            foregroundColor: Colors.white,
            onPressed: () => _showPostDialog(context),
            icon: const Icon(Icons.favorite),
            label: const Text('Cheer / Post'),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildFanWallTab(context, db),
              _buildPollsTab(context, db),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFanWallTab(BuildContext context, DatabaseService db) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        // Community Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade50, Colors.purple.shade50],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.pink.shade100),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.accentHeart,
                child: Icon(Icons.favorite, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome to the Fan Wall',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Drop your cheers, greetings and connect with thousands of fans.',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Fan posts list
        ...db.fanPosts.map((post) => Card(
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                          child: Text(
                            post.authorName.isNotEmpty ? post.authorName[0] : 'F',
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.authorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${post.authorCity} • ${post.timestamp}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            post.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: post.isLiked ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => db.toggleFanPostLike(post.id),
                        ),
                        Text(
                          '${post.likes}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: post.isLiked ? Colors.red : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post.message,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildPollsTab(BuildContext context, DatabaseService db) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        ...db.polls.map((poll) {
          final totalVotes = poll.totalVotes;
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          poll.expiryDate,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$totalVotes votes',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    poll.question,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1B2E),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Options
                  ...List.generate(poll.options.length, (optIndex) {
                    final opt = poll.options[optIndex];
                    final isUserChoice = poll.userVotedIndex == optIndex;
                    final percentage = totalVotes == 0 ? 0.0 : (opt.votes / totalVotes);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: poll.userVotedIndex == null
                            ? () {
                                db.votePoll(poll.id, optIndex);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Voted for: ${opt.text}!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isUserChoice
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade300,
                              width: isUserChoice ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              // Progress Fill Bar
                              if (poll.userVotedIndex != null)
                                FractionallySizedBox(
                                  widthFactor: percentage,
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isUserChoice
                                          ? AppTheme.primaryColor.withValues(alpha: 0.15)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            isUserChoice
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            size: 18,
                                            color: isUserChoice
                                                ? AppTheme.primaryColor
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              opt.text,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: isUserChoice
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (poll.userVotedIndex != null)
                                      Text(
                                        '${(percentage * 100).toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isUserChoice
                                              ? AppTheme.primaryColor
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
