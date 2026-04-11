enum BlogCategory { general, instagram, whatsapp }

class BlogPost {
  final String id;
  final String authorId;
  final String title;
  final String summary;
  final String content;
  final String imageUrl;
  final BlogCategory category;
  final bool isPublished;
  final List<String> tips;
  final String? template;
  final DateTime createdAt;
  final int likeCount;

  const BlogPost({
    required this.id,
    this.authorId = '',
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.category,
    this.isPublished = true,
    this.tips = const [],
    this.template,
    required this.createdAt,
    this.likeCount = 0,
  });
}
