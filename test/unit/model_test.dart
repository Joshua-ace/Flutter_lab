import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab/models/community_post.dart';
import 'package:flutter_lab/models/member.dart';
import 'package:flutter_lab/models/event.dart';

void main() {
  group('Experiment 10 - Unit Tests: Models', () {
    test('CommunityPost serialization and deserialization', () {
      final jsonMap = {
        'id': 42,
        'userId': 3,
        'title': 'Charity Blood Donation Camp',
        'body': 'Join us this Sunday at the Community Hall.',
      };

      final post = CommunityPost.fromJson(jsonMap);

      expect(post.id, 42);
      expect(post.userId, 3);
      expect(post.title, 'Charity Blood Donation Camp');
      expect(post.body, 'Join us this Sunday at the Community Hall.');
      expect(post.likes, isPositive);
      expect(post.tag, isNotEmpty);
      expect(post.authorName, isNotEmpty);

      final exportedJson = post.toJson();
      expect(exportedJson['id'], 42);
      expect(exportedJson['userId'], 3);
      expect(exportedJson['title'], 'Charity Blood Donation Camp');
    });

    test('Member model properties and copyWith', () {
      final member = Member(
        id: 'MEM-001',
        name: 'Srekar Fan',
        phone: '9876543210',
        city: 'Hyderabad',
        bloodGroup: 'O+',
        tier: 'Platinum',
        membershipId: 'SREKAR-VIP-001',
        joinedDate: DateTime(2026, 10, 1),
      );

      expect(member.name, 'Srekar Fan');
      expect(member.bloodGroup, 'O+');
      expect(member.tier, 'Platinum');
      expect(member.membershipId, 'SREKAR-VIP-001');

      final updated = member.copyWith(city: 'Bengaluru', tier: 'Gold');
      expect(updated.id, 'MEM-001');
      expect(updated.name, 'Srekar Fan');
      expect(updated.city, 'Bengaluru');
      expect(updated.tier, 'Gold');
    });

    test('Event model registration toggle', () {
      final event = Event(
        id: 'EVT-101',
        title: 'Grand Fan Meet 2026',
        date: 'Nov 15, 2026',
        time: '5:00 PM',
        location: 'Convention Center',
        description: 'Annual gathering of all chapter leads.',
        category: 'Meetup',
        imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865',
        isRegistered: false,
      );

      expect(event.isRegistered, isFalse);
      final registeredEvent = event.copyWith(isRegistered: true);
      expect(registeredEvent.isRegistered, isTrue);
      expect(registeredEvent.title, 'Grand Fan Meet 2026');
      expect(registeredEvent.imageUrl, isNotEmpty);
    });
  });
}
