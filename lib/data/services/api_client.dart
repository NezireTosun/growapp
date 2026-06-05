import 'package:growapp/core/utils/app_logger.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/recommendation.dart';

class FeedbackResponse {
  final bool success;
  final String? message;

  const FeedbackResponse({required this.success, this.message});

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String title;
  final String? detail;

  const ApiException({
    required this.statusCode,
    required this.title,
    this.detail,
  });

  @override
  String toString() => 'ApiException($statusCode): $title${detail != null ? ' - $detail' : ''}';
}

class ApiClient {
  static const String _baseUrl = 'https://salesgrowthsteps.com';

  final FirebaseAuth _auth;

  ApiClient({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<String> _getToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) throw const ApiException(statusCode: 401, title: 'Not authenticated');
    final token = await user.getIdToken(forceRefresh);
    if (token == null) throw const ApiException(statusCode: 401, title: 'Token unavailable');
    return token;
  }

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// POST with automatic token refresh on 401 and exponential backoff on 429
  Future<http.Response> _postWithRetry(String path, String body) async {
    var token = await _getToken();
    final stopwatch = Stopwatch()..start();

    for (var attempt = 0; attempt < 3; attempt++) {
      AppLogger.i('[ApiClient]', 'POST $path${attempt > 0 ? ' (attempt ${attempt + 1})' : ''}\n$body');

      final response = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(token),
        body: body,
      ).timeout(const Duration(seconds: 20));

      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        AppLogger.i('[ApiClient]', '← ${response.statusCode} ${ms}ms\n${response.body}');
        return response;
      }

      // Token expired → refresh and retry once
      if (response.statusCode == 401 && attempt == 0) {
        AppLogger.w('[ApiClient]', '← 401 ${ms}ms — token yenileniyor');
        token = await _getToken(forceRefresh: true);
        stopwatch..reset()..start();
        continue;
      }

      // Rate limited → exponential backoff
      if (response.statusCode == 429 && attempt < 2) {
        final retryAfterHeader = response.headers['retry-after'];
        final waitSeconds = retryAfterHeader != null
            ? int.tryParse(retryAfterHeader) ?? (1 << attempt)
            : (1 << attempt);
        AppLogger.w('[ApiClient]', '← 429 ${ms}ms — ${waitSeconds}s sonra tekrar');
        await Future.delayed(Duration(seconds: waitSeconds));
        stopwatch..reset()..start();
        continue;
      }

      AppLogger.e('[ApiClient]', '← ${response.statusCode} ${ms}ms\n${response.body}');
      return response;
    }

    // Son deneme
    AppLogger.i('[ApiClient]', 'POST $path (final attempt)\n$body');
    final sw = Stopwatch()..start();
    final res = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token),
      body: body,
    ).timeout(const Duration(seconds: 20));
    sw.stop();
    AppLogger.i('[ApiClient]', '← ${res.statusCode} ${sw.elapsedMilliseconds}ms\n${res.body}');
    return res;
  }

  void _handleError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    if (response.statusCode == 429) {
      final retryAfter = response.headers['retry-after'];
      throw ApiException(
        statusCode: 429,
        title: 'Too many requests',
        detail: retryAfter != null ? 'Retry after $retryAfter seconds' : null,
      );
    }

    String title = 'Error';
    String? detail;

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      title = body['title'] as String? ?? 'Error';
      detail = body['detail'] as String?;
    } catch (_) {
      detail = response.body;
    }

    throw ApiException(
      statusCode: response.statusCode,
      title: title,
      detail: detail,
    );
  }

  /// POST /api/v1/recommendations
  /// [industry]: "rest", "cafe" vb.
  /// [answers]: {"q1": 8, "q2": 5, ...} (1-10 arası)
  Future<List<Recommendation>> getRecommendations({
    required String industry,
    required Map<String, int> answers,
  }) async {
    // Answer key'lerini sıralı gönder (q1, q2, ... q7)
    final sortedAnswers = Map.fromEntries(
      answers.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    final requestBody = jsonEncode({
      'industry': industry,
      'answers': sortedAnswers,
    });
    final response = await _postWithRetry('/api/v1/recommendations', requestBody);
    _handleError(response);

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['recommendations'] as List<dynamic>;
    return list
        .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/v1/feedbacks
  /// [action]: "Done", "Snooze", "Dismiss", "Blacklist"
  Future<FeedbackResponse> sendFeedback({
    required String industry,
    required String taskId,
    required String action,
    String? dismissReason,
  }) async {
    final body = <String, dynamic>{
      'industry': industry,
      'taskId': taskId,
      'action': action,
    };
    if (action == 'Dismiss' && dismissReason != null) {
      body['dismissReason'] = dismissReason;
    }

    final response = await _postWithRetry(
      '/api/v1/feedbacks',
      jsonEncode(body),
    );

    _handleError(response);

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return FeedbackResponse.fromJson(data);
  }
}
