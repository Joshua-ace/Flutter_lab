import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab/providers/theme_provider.dart';
import 'package:flutter_lab/providers/api_feed_provider.dart';
import 'package:flutter_lab/models/community_post.dart';

void main() {
  group('Experiment 10 - Unit Tests: Providers', () {
    test('ThemeProvider toggles between light and dark themes', () {
      final themeProvider = ThemeProvider();

      expect(themeProvider.themeMode, ThemeMode.light);
      expect(themeProvider.isDarkMode, isFalse);

      themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.dark);
      expect(themeProvider.isDarkMode, isTrue);

      themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.light);
      expect(themeProvider.isDarkMode, isFalse);

      themeProvider.setThemeMode(ThemeMode.dark);
      expect(themeProvider.themeMode, ThemeMode.dark);
    });

    test('ApiFeedProvider local post insertion and search filtering', () {
      final feedProvider = ApiFeedProvider();

      expect(feedProvider.status, ApiStatus.initial);
      expect(feedProvider.isLoading, isFalse);
      expect(feedProvider.hasError, isFalse);
      expect(feedProvider.posts, isEmpty);

      final post1 = CommunityPost(
        id: 1,
        userId: 10,
        title: 'Blood Drive Camp in Vizag',
        body: 'Volunteers please register at the local unit.',
        tag: 'Charity',
      );
      final post2 = CommunityPost(
        id: 2,
        userId: 11,
        title: 'FDFS Celebration Planning',
        body: 'Banner arrangements at Prasad IMAX.',
        tag: 'Movie Updates',
      );

      feedProvider.addLocalPost(post1);
      feedProvider.addLocalPost(post2);

      expect(feedProvider.posts.length, 2);

      // Search query filtering
      feedProvider.setSearchQuery('blood');
      expect(feedProvider.posts.length, 1);
      expect(feedProvider.posts.first.title, contains('Blood Drive'));

      feedProvider.setSearchQuery('IMAX');
      expect(feedProvider.posts.length, 1);
      expect(feedProvider.posts.first.title, contains('Celebration'));

      feedProvider.setSearchQuery('');
      expect(feedProvider.posts.length, 2);
    });
  });
}
