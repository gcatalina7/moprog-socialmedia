import '../models/user_model.dart';
import '../models/post_model.dart';

class MockData {
  // ========== User Sampel ==========
  static final User user1 = User(
    id: 'user1',
    username: 'gio_coder',
    email: 'gio@example.com',
    bio: 'Penggemar kopi.',
    profileImage:
        'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=150&h=150&fit=crop&crop=center', // Blue floral scenery
    followingIds: ['user2', 'user3'],
    followerIds: ['user2'],
  );

  static final User user2 = User(
    id: 'user2',
    username: 'piki_design',
    email: 'piki@example.com',
    bio: 'UI/UX Designer.',
    profileImage:
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150&h=150&fit=crop&crop=center', // Mountain scenery
    followingIds: ['user1', 'user3'],
    followerIds: ['user1', 'user3'],
  );

  static final User user3 = User(
    id: 'user3',
    username: 'dimas_tech',
    email: 'dimas@example.com',
    bio: 'Tech blogger',
    profileImage:
        'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=150&h=150&fit=crop&crop=center', // Forest scenery
    followingIds: ['user2'],
    followerIds: ['user1', 'user2'],
  );

  static final User user4 = User(
    id: 'user4',
    username: 'calvin_explorer',
    email: 'calvin@example.com',
    bio: 'Travel blogger',
    profileImage:
        'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=150&h=150&fit=crop&crop=center', // Sunset scenery
    followingIds: [],
    followerIds: [],
  );

  // ========== Post Sampel ==========
  static final Post post1 = Post(
    id: 'post1',
    authorId: 'user1',
    content: 'Akhirnya Flutter pertama selesai...',
    timestamp: DateTime(2024, 1, 15, 14, 30),
    likedBy: ['user2', 'user3'],
    comments: [
      Comment(
        id: 'comment1',
        authorId: 'user2',
        content: 'Keren bro',
        timestamp: DateTime(2024, 1, 15, 15, 0),
      ),
      Comment(
        id: 'comment2',
        authorId: 'user3',
        content: 'Anjaaayyy',
        timestamp: DateTime(2024, 1, 15, 15, 30),
      ),
    ],
  );

  static final Post post2 = Post(
    id: 'post2',
    authorId: 'user2',
    content: 'Dark mode to the rescue',
    timestamp: DateTime(2024, 1, 16, 10, 15),
    likedBy: ['user1', 'user3'],
    comments: [
      Comment(
        id: 'comment3',
        authorId: 'user1',
        content: 'Niceeee',
        timestamp: DateTime(2024, 1, 16, 11, 0),
      ),
    ],
  );

  static final Post post3 = Post(
    id: 'post3',
    authorId: 'user3',
    content: 'Baru aja publish artikel baru, tolong likenya ya ges',
    timestamp: DateTime(2024, 1, 17, 9, 45),
    likedBy: ['user1'],
    comments: [],
  );

  static final Post post4 = Post(
    id: 'post4',
    authorId: 'user1',
    content: 'Seharian debugging... akhirnya berhasil juga astagaaaa...',
    timestamp: DateTime(2024, 1, 18, 20, 0),
    likedBy: ['user2', 'user3'],
    comments: [
      Comment(
        id: 'comment4',
        authorId: 'user2',
        content: 'Wkwkwkwk akhirnyaa',
        timestamp: DateTime(2024, 1, 18, 20, 30),
      ),
    ],
  );

  static final Post post5 = Post(
    id: 'post5',
    authorId: 'user4',
    content: 'Baru sampe di Tokyo! Yuk yang mau jastip',
    timestamp: DateTime(2024, 1, 19, 18, 20),
    likedBy: [],
    comments: [],
  );

  // ========== HELPER METHODS ==========

  // Get all users
  static List<User> get allUsers => [user1, user2, user3, user4];

  // Get all posts (sorted by timestamp, newest first)
  static List<Post> get allPosts => [post5, post4, post3, post2, post1];

  // Find user by ID
  static User? findUserById(String userId) {
    try {
      return allUsers.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Find post by ID
  static Post? findPostById(String postId) {
    try {
      return allPosts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  // Get posts by a specific user
  static List<Post> getPostsByUser(String userId) {
    return allPosts.where((post) => post.authorId == userId).toList();
  }

  // Get users that a specific user follows
  static List<User> getFollowingUsers(String userId) {
    final user = findUserById(userId);
    if (user == null) return [];

    return allUsers.where((u) => user.followingIds.contains(u.id)).toList();
  }

  // Get users who follow a specific user
  static List<User> getFollowerUsers(String userId) {
    final user = findUserById(userId);
    if (user == null) return [];

    return allUsers.where((u) => user.followerIds.contains(u.id)).toList();
  }
}
