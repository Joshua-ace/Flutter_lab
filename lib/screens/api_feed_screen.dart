import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/community_post.dart';
import '../providers/api_feed_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/tilt_3d_card.dart';

class ApiFeedScreen extends StatefulWidget {
  const ApiFeedScreen({super.key});

  @override
  State<ApiFeedScreen> createState() => _ApiFeedScreenState();
}

class _ApiFeedScreenState extends State<ApiFeedScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ApiFeedProvider>();
      if (provider.status == ApiStatus.initial) {
        provider.fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreatePostDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.post_add, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('New Community Post', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Topic / Title'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: bodyController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Message Body'),
                validator: (val) => val == null || val.trim().length < 5 ? 'Message must be at least 5 chars' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newPost = CommunityPost(
                  id: DateTime.now().millisecondsSinceEpoch % 10000,
                  userId: 1,
                  title: titleController.text.trim(),
                  body: bodyController.text.trim(),
                  authorName: 'You (Official Member)',
                  tag: 'Member Post',
                  likes: 1,
                );
                context.read<ApiFeedProvider>().addLocalPost(newPost);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post published to Fan Community feed! 🎉'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = context.watch<ApiFeedProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text('🌐 ', style: TextStyle(fontSize: 20)),
            Text('REST API Live Feed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Feed',
            onPressed: () => feedProvider.fetchPosts(forceRefresh: true),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePostDialog,
        icon: const Icon(Icons.edit),
        label: const Text('Post Discussion'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Banner introducing REST API concept
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              border: Border(bottom: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.15))),
            ),
            child: Row(
              children: [
                const Icon(Icons.cloud_sync, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Experiment 9: REST API Integration',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryDark),
                      ),
                      Text(
                        'Fetching real JSON data via HTTP GET, parsing into Dart models, handling loading & error states.',
                        style: TextStyle(fontSize: 11, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: feedProvider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search community posts by title or keyword...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          feedProvider.setSearchQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                filled: true,
                fillColor: Theme.of(context).cardTheme.color ?? Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),

          // Main Content with 3 States: Loading, Error, Success
          Expanded(
            child: Builder(
              builder: (context) {
                if (feedProvider.isLoading) {
                  return _buildLoadingState();
                }

                if (feedProvider.hasError) {
                  return _buildErrorState(feedProvider);
                }

                if (feedProvider.posts.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildPostsList(feedProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: AppTheme.primaryColor,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Fetching posts from REST API...',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          SizedBox(height: 6),
          Text(
            'GET https://jsonplaceholder.typicode.com/posts',
            style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ApiFeedProvider feedProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off, size: 48, color: Colors.red),
            ),
            const SizedBox(height: 16),
            const Text(
              'Network Request Failed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              feedProvider.errorMessage.isNotEmpty
                  ? feedProvider.errorMessage
                  : 'Unable to reach the server. Please check your connection.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => feedProvider.fetchPosts(forceRefresh: true),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Request'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No matching posts found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            'Try searching with a different keyword.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(ApiFeedProvider feedProvider) {
    return RefreshIndicator(
      onRefresh: () => feedProvider.fetchPosts(forceRefresh: true),
      color: AppTheme.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
        itemCount: feedProvider.posts.length,
        itemBuilder: (context, index) {
          final post = feedProvider.posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Tilt3DCard(
              borderRadius: 16,
              elevation: 8,
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
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
                          post.authorName[0],
                          style: const TextStyle(
                            color: AppTheme.primaryDark,
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
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              'Post ID #${post.id} • User #${post.userId}',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          post.tag,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        '${post.likes} likes',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Liked discussion "${post.title.substring(0, post.title.length > 25 ? 25 : post.title.length)}..."'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.favorite_border, size: 16, color: AppTheme.accentHeart),
                        label: const Text('Cheer', style: TextStyle(color: AppTheme.accentHeart, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ),
        );
      },
      ),
    );
  }
}
