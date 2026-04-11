import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/blog_post.dart';
import '../../domain/repositories/blog_repository.dart';

class BlogRepositoryImpl implements BlogRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<BlogPost>> getBlogPosts({String locale = 'en'}) async {
    final snapshot = await _db
        .collection('blog_posts')
        .where('is_published', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['created_at'] as Timestamp?;

      return BlogPost(
        id: doc.id,
        authorId: data['author_id'] as String? ?? '',
        title: _localizedString(data['title'], locale),
        summary: _localizedString(data['summary'], locale),
        content: _localizedString(data['content'], locale),
        imageUrl: data['image_url'] as String? ?? '',
        category: _mapCategory(data['category'] as String? ?? 'general'),
        isPublished: data['is_published'] as bool? ?? true,
        tips: _localizedStringList(data['tips'], locale),
        template: data['template'] as String?,
        createdAt: timestamp?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  /// Reads a localized string field.
  /// Supports both `Map<locale, value>` (new) and plain String (legacy).
  String _localizedString(dynamic field, String locale) {
    if (field == null) return '';
    if (field is String) return field;
    if (field is Map) {
      return (field[locale] ?? field['en'] ?? '').toString();
    }
    return field.toString();
  }

  /// Reads a localized string list field.
  /// Supports both `Map<locale, List>` (new) and plain `List<String>` (legacy).
  List<String> _localizedStringList(dynamic field, String locale) {
    if (field == null) return [];
    if (field is List) {
      return List<String>.from(field);
    }
    if (field is Map) {
      final localized = field[locale] ?? field['en'];
      if (localized is List) return List<String>.from(localized);
    }
    return [];
  }

  BlogCategory _mapCategory(String category) {
    return switch (category) {
      'instagram' => BlogCategory.instagram,
      'whatsapp' => BlogCategory.whatsapp,
      _ => BlogCategory.general,
    };
  }
}
