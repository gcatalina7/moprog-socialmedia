import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/post_model.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  Color _getUserColor(String userId) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal
    ];
    final index = userId.hashCode % colors.length;
    return colors[index];
  }

  String _getUserAvatar(String username) {
    final emojiMap = {
      'gio': '👨‍💻',
      'piki': '👩‍🎨',
      'dimas': '👨‍💼',
      'calvin': '👨‍✈️'
    };
    final lowercase = username.toLowerCase();
    for (final key in emojiMap.keys) {
      if (lowercase.contains(key)) return emojiMap[key]!;
    }
    return username[0].toUpperCase();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final post = appState.posts.firstWhere(
            (p) => p.id == widget.postId,
            orElse: () => Post(
              id: '',
              authorId: '',
              content: '',
              timestamp: DateTime.now(),
            ),
          );

          final currentUser = appState.currentUser;

          return Column(
            children: [
              // Post preview
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.black),
                ),
                title: Text(
                  appState.findUserById(post.authorId)?.username ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(post.content),
              ),
              const Divider(),

              // Comments list
              Expanded(
                child: ListView.builder(
                  itemCount: post.comments.length,
                  itemBuilder: (context, index) {
                    final comment = post.comments[index];
                    final commentAuthor =
                        appState.findUserById(comment.authorId);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getUserColor(commentAuthor?.id ?? ''),
                        child: Text(
                          _getUserAvatar(commentAuthor?.username ?? '?'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(commentAuthor?.username ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.content),
                          Text(
                            _formatTimestamp(comment.timestamp),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Add comment input with send button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.black,
                      onPressed: () {
                        final commentText = _commentController.text.trim();
                        if (commentText.isNotEmpty && currentUser != null) {
                          appState.addComment(widget.postId, commentText);
                          _commentController.clear();
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
