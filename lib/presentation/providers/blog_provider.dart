import 'package:growapp/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/blog_post.dart';
import '../../domain/repositories/blog_repository.dart';

class BlogProvider extends ChangeNotifier {
  final BlogRepository _repository;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  BlogProvider(this._repository);

  List<BlogPost> _posts = [];
  bool _isLoading = false;
  String? _error;
  BlogCategory? _selectedCategory;
  String _locale = 'tr';

  /// User's liked post IDs
  final Set<String> _likedPostIds = {};
  String? _userId;

  List<BlogPost> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  BlogCategory? get selectedCategory => _selectedCategory;

  List<BlogPost> get filteredPosts {
    if (_selectedCategory == null) return _posts;
    return _posts.where((p) => p.category == _selectedCategory).toList();
  }

  bool isLiked(String postId) => _likedPostIds.contains(postId);

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void setCategory(BlogCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadPosts({String? locale, String? userId}) async {
    if (locale != null) _locale = locale;
    if (userId != null) _userId = userId;

    // Postlar zaten yüklüyse sadece likes'ı yenile, tekrar fetch etme
    if (_posts.isNotEmpty) {
      if (_userId != null) await _loadUserLikes();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _posts = await _repository.getBlogPosts(locale: _locale);
      if (_userId != null) {
        await _loadUserLikes();
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
        _error = 'network_error';
      } else {
        _error = 'generic_error';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserLikes() async {
    final doc = await _db.collection('blog_likes').doc(_userId).get();
    _likedPostIds.clear();
    if (doc.exists) {
      final likes = doc.data()?['liked_posts'] as List<dynamic>? ?? [];
      _likedPostIds.addAll(likes.map((e) => e.toString()));
    }
  }

  Future<void> toggleLike(String postId) async {
    if (_userId == null) return;

    final wasLiked = _likedPostIds.contains(postId);

    // Optimistic update
    if (wasLiked) {
      _likedPostIds.remove(postId);
    } else {
      _likedPostIds.add(postId);
    }
    notifyListeners();

    try {
      // Update user's liked posts
      await _db.collection('blog_likes').doc(_userId).set({
        'liked_posts': wasLiked
            ? FieldValue.arrayRemove([postId])
            : FieldValue.arrayUnion([postId]),
        'user_id': _userId,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update post's like count
      await _db.collection('blog_posts').doc(postId).update({
        'like_count': FieldValue.increment(wasLiked ? -1 : 1),
      });
    } catch (e) {
      AppLogger.e('[BlogProvider]', 'toggleLike error', e);
      // Revert on error
      if (wasLiked) {
        _likedPostIds.add(postId);
      } else {
        _likedPostIds.remove(postId);
      }
      notifyListeners();
    }
  }
}
