import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../app_state.dart';
import '../widgets/post_card.dart';
import 'comments_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showCreatePostDialog(BuildContext context) async {
    final TextEditingController postController = TextEditingController();
    final appState = Provider.of<AppState>(context, listen: false);
    File? selectedImage;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create New Post'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: postController,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  // Image picker section
                  if (selectedImage != null)
                    Column(
                      children: [
                        Image.file(selectedImage!,
                            height: 150, fit: BoxFit.cover),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedImage = null;
                            });
                          },
                          child: const Text('Remove Image'),
                        ),
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 1000,
                          maxWidth: 1000,
                          imageQuality: 80,
                        );
                        if (image != null) {
                          setState(() {
                            selectedImage = File(image.path);
                          });
                        }
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Add Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final content = postController.text.trim();
                    if (content.isNotEmpty || selectedImage != null) {
                      // For demo, we'll create post with text only
                      // In real app, upload image and get URL
                      appState.createPost(content);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Post'),
                ),
              ],
            );
          },
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'XYZ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final posts = appState.posts;
          final currentUser = appState.currentUser;

          if (currentUser == null) {
            return const Center(
              child: Text('Please log in'),
            );
          }

          return Column(
            children: [
              // Create Post Button at Top
              Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: currentUser.profileImage != null
                        ? Colors.transparent
                        : _getUserColor(currentUser.id),
                    backgroundImage: currentUser.profileImage != null
                        ? NetworkImage(currentUser.profileImage!)
                        : null,
                    child: currentUser.profileImage == null
                        ? Text(
                            _getUserAvatar(currentUser.username),
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),
                  title: const Text('Create a new post...'),
                  onTap: () => _showCreatePostDialog(context),
                ),
              ),

              // Posts List
              if (posts.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.feed, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No posts yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Be the first to share something!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final author = appState.findUserById(post.authorId);

                      if (author == null) {
                        return const SizedBox();
                      }

                      return PostCard(
                        post: post,
                        author: author,
                        currentUser: currentUser,
                        onLike: () => appState.likePost(post.id),
                        onComment: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommentsScreen(postId: post.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
