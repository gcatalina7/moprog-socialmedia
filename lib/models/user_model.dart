class User {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String? profileImage;
  final List<String> followingIds;
  final List<String> followerIds;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.bio,
    this.profileImage,
    this.followingIds = const [],
    this.followerIds = const [],
  });

  bool isFollowing(String userId) {
    return followingIds.contains(userId);
  }

  User copyWithFollowing(String userId) {
    return User(
      id: id,
      username: username,
      email: email,
      bio: bio,
      profileImage: profileImage,
      followingIds: [...followingIds, userId],
      followerIds: followerIds,
    );
  }
}
