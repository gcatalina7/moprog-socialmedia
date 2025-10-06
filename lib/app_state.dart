import 'package:flutter/foundation.dart';
import 'data/mock_data.dart';
import 'models/user_model.dart';
import 'models/post_model.dart';

class AppState extends ChangeNotifier {
  User? _currentUser;
  List<Post> _posts = MockData.allPosts;
  List<User> _users = MockData.allUsers;

  User? get currentUser => _currentUser;
  List<Post> get posts => _posts;
  List<User> get users => _users;

  AppState() {
    _currentUser = MockData.user1;
  }

  // ========== POST ACTIONS ==========

  void likePost(String postId) {
    if (_currentUser == null) return;

    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _posts[postIndex] = _posts[postIndex].copyWithLike(_currentUser!.id);
      notifyListeners();
    }
  }

  void addComment(String postId, String content) {
    if (_currentUser == null) return;

    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final newComment = Comment(
        id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
        authorId: _currentUser!.id,
        content: content,
        timestamp: DateTime.now(),
      );

      _posts[postIndex] = _posts[postIndex].copyWithComment(newComment);
      notifyListeners();
    }
  }

  void createPost(String content, {String? imageUrl}) {
    if (_currentUser == null) return;

    final newPost = Post(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorId: _currentUser!.id,
      content: content,
      timestamp: DateTime.now(),
      likedBy: [],
      comments: [],
      imageUrl: imageUrl,
    );

    _posts.insert(0, newPost);
    notifyListeners();
  }

  // ========== USER ACTIONS ==========

  void followUser(String userId) {
    if (_currentUser == null) return;

    final currentUserIndex =
        _users.indexWhere((user) => user.id == _currentUser!.id);
    final targetUserIndex = _users.indexWhere((user) => user.id == userId);

    if (currentUserIndex != -1 && targetUserIndex != -1) {
      _users[currentUserIndex] =
          _users[currentUserIndex].copyWithFollowing(userId);

      _users[targetUserIndex] = User(
        id: _users[targetUserIndex].id,
        username: _users[targetUserIndex].username,
        email: _users[targetUserIndex].email,
        bio: _users[targetUserIndex].bio,
        profileImage: _users[targetUserIndex].profileImage,
        followingIds: _users[targetUserIndex].followingIds,
        followerIds: [..._users[targetUserIndex].followerIds, _currentUser!.id],
      );

      _currentUser = _users[currentUserIndex];
      notifyListeners();
    }
  }

  void unfollowUser(String userId) {
    if (_currentUser == null) return;

    final currentUserIndex =
        _users.indexWhere((user) => user.id == _currentUser!.id);
    final targetUserIndex = _users.indexWhere((user) => user.id == userId);

    if (currentUserIndex != -1 && targetUserIndex != -1) {
      _users[currentUserIndex] = User(
        id: _users[currentUserIndex].id,
        username: _users[currentUserIndex].username,
        email: _users[currentUserIndex].email,
        bio: _users[currentUserIndex].bio,
        profileImage: _users[currentUserIndex].profileImage,
        followingIds: _users[currentUserIndex]
            .followingIds
            .where((id) => id != userId)
            .toList(),
        followerIds: _users[currentUserIndex].followerIds,
      );

      _users[targetUserIndex] = User(
        id: _users[targetUserIndex].id,
        username: _users[targetUserIndex].username,
        email: _users[targetUserIndex].email,
        bio: _users[targetUserIndex].bio,
        profileImage: _users[targetUserIndex].profileImage,
        followingIds: _users[targetUserIndex].followingIds,
        followerIds: _users[targetUserIndex]
            .followerIds
            .where((id) => id != _currentUser!.id)
            .toList(),
      );

      _currentUser = _users[currentUserIndex];
      notifyListeners();
    }
  }

  bool isFollowing(String userId) {
    return _currentUser?.followingIds.contains(userId) ?? false;
  }

  User? findUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }
}
