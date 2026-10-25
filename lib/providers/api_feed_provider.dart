import 'package:flutter/foundation.dart';
import '../models/community_post.dart';
import '../services/api_service.dart';

enum ApiStatus { initial, loading, loaded, error }

class ApiFeedProvider extends ChangeNotifier {
  final ApiService _apiService;
  ApiStatus _status = ApiStatus.initial;
  List<CommunityPost> _posts = [];
  String _errorMessage = '';
  String _searchQuery = '';

  ApiFeedProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  ApiStatus get status => _status;
  bool get isLoading => _status == ApiStatus.loading;
  bool get hasError => _status == ApiStatus.error;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<CommunityPost> get posts {
    if (_searchQuery.isEmpty) return _posts;
    return _posts.where((p) {
      return p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.body.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.tag.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchPosts({bool forceRefresh = false}) async {
    if (_status == ApiStatus.loading && !forceRefresh) return;

    _status = ApiStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final fetched = await _apiService.fetchCommunityPosts(limit: 20);
      _posts = fetched;
      _status = ApiStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      _status = ApiStatus.error;
    } finally {
      notifyListeners();
    }
  }

  void addLocalPost(CommunityPost post) {
    _posts.insert(0, post);
    notifyListeners();
  }
}
