import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import 'like_button.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final User author;
  final User currentUser;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostCard({
    super.key,
    required this.post,
    required this.author,
    required this.currentUser,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header (Author info)
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: author.profileImage != null
                      ? Colors.transparent
                      : _getUserColor(author.id),
                  backgroundImage: author.profileImage != null
                      ? NetworkImage(author.profileImage!)
                      : null,
                  child: author.profileImage == null
                      ? Text(
                          _getUserAvatar(author.username),
                          style: const TextStyle(color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatTimestamp(post.timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Post Content
            if (post.content.isNotEmpty)
              Text(
                post.content,
                style: const TextStyle(fontSize: 14),
              ),

            // Post Image (if available)
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(post.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Post Stats (Likes & Comments)
            Row(
              children: [
                Text(
                  '${post.likeCount} ${post.likeCount == 1 ? 'like' : 'likes'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${post.commentCount} ${post.commentCount == 1 ? 'comment' : 'comments'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Action Buttons
            Row(
              children: [
                LikeButton(
                  isLiked: post.isLikedBy(currentUser.id),
                  onTap: onLike,
                ),
                const SizedBox(width: 16),
                _buildCommentButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentButton() {
    return GestureDetector(
      onTap: onComment,
      child: Row(
        children: [
          Icon(
            Icons.comment_outlined,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            'Comment',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Color _getUserColor(String userId) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    final index = userId.hashCode % colors.length;
    return colors[index];
  }

  String _getUserAvatar(String username) {
    final emojiMap = {
      'gio': '👨‍💻',
      'piki': '👩‍🎨',
      'dimas': '👨‍💼',
      'calvin': '👨‍✈️',
    };

    final lowercase = username.toLowerCase();
    for (final key in emojiMap.keys) {
      if (lowercase.contains(key)) {
        return emojiMap[key]!;
      }
    }

    return username[0].toUpperCase();
  }
}
