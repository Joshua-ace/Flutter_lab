import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/community_post.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches community forum posts from the REST API endpoint.
  /// Handles HTTP responses, network exceptions, and JSON deserialization.
  Future<List<CommunityPost>> fetchCommunityPosts({int limit = 15}) async {
    final uri = Uri.parse('$baseUrl/posts?_limit=$limit');

    try {
      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((jsonItem) => CommunityPost.fromJson(jsonItem)).toList();
      } else {
        throw HttpException('Server returned error status: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw const SocketException('No Internet connection. Please check your network.');
    } catch (e) {
      if (e is HttpException || e is SocketException) {
        rethrow;
      }
      throw Exception('Failed to fetch posts: $e');
    }
  }

  /// Creates a new community post via POST request (demonstrating write capability)
  Future<CommunityPost> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    final uri = Uri.parse('$baseUrl/posts');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'title': title,
        'body': body,
        'userId': userId,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CommunityPost.fromJson(data);
    } else {
      throw HttpException('Failed to create post. Status: ${response.statusCode}');
    }
  }
}
