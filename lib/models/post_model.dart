class Post {
  final String id;
  final String authorId;
  final String content;
  final DateTime timestamp;
  final List<String> likedBy;
  final List<Comment> comments;
  final String? imageUrl;

  Post({
    required this.id,
    required this.authorId,
    required this.content,
    required this.timestamp,
    this.likedBy = const [],
    this.comments = const [],
    this.imageUrl,
  });

  int get likeCount => likedBy.length;
  int get commentCount => comments.length;

  bool isLikedBy(String userId) {
    return likedBy.contains(userId);
  }

  Post copyWithLike(String userId) {
    if (likedBy.contains(userId)) {
      return Post(
        id: id,
        authorId: authorId,
        content: content,
        timestamp: timestamp,
        likedBy: likedBy.where((id) => id != userId).toList(),
        comments: comments,
        imageUrl: imageUrl,
      );
    } else {
      return Post(
        id: id,
        authorId: authorId,
        content: content,
        timestamp: timestamp,
        likedBy: [...likedBy, userId],
        comments: comments,
        imageUrl: imageUrl,
      );
    }
  }

  Post copyWithComment(Comment comment) {
    return Post(
      id: id,
      authorId: authorId,
      content: content,
      timestamp: timestamp,
      likedBy: likedBy,
      comments: [...comments, comment],
      imageUrl: imageUrl,
    );
  }
}

class Comment {
  final String id;
  final String authorId;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.authorId,
    required this.content,
    required this.timestamp,
  });
}
