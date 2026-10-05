import 'package:flutter/foundation.dart';
import '../models/member.dart';
import '../models/event.dart';
import '../models/update.dart';
import '../models/gallery_item.dart';
import '../models/poll.dart';

class FanWallPost {
  final String id;
  final String authorName;
  final String authorCity;
  final String message;
  final String timestamp;
  int likes;
  bool isLiked;

  FanWallPost({
    required this.id,
    required this.authorName,
    required this.authorCity,
    required this.message,
    required this.timestamp,
    this.likes = 0,
    this.isLiked = false,
  });
}

class LeadershipMember {
  final String id;
  final String name;
  final String role;
  final String phone;
  final String imageUrl;

  LeadershipMember({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.imageUrl,
  });
}

class DatabaseService extends ChangeNotifier {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  int memberCount = 2450;
  int eventsCount = 36;
  int photosCount = 1200;

  // Announcements / Updates
  final List<UpdateItem> _updates = [
    UpdateItem(
      id: 'up_1',
      title: "Srekar's Association Grand State Meet",
      description: "Srekar's Association announces the official schedule for our state-wide fan convention and charity drive this season. Join hands to make it memorable!",
      category: 'Announcements',
      date: 'Today • 10:30 AM',
      isPinned: true,
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=600&q=80',
    ),
    UpdateItem(
      id: 'up_2',
      title: 'Fan Meet 2026 Passes Released',
      description: 'Registration passes for the upcoming Hyderabad Fan Meet are now live for all registered members. Check the Events tab.',
      category: 'News',
      date: 'Yesterday',
      imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=600&q=80',
    ),
    UpdateItem(
      id: 'up_3',
      title: 'Blood Donation Camp by Srekar Fans',
      description: 'Our youth wing organized a state-level blood donation drive collecting over 150 units in celebration of the association foundation day.',
      category: 'Association activities',
      date: '3 days ago',
      imageUrl: 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?auto=format&fit=crop&w=600&q=80',
    ),
    UpdateItem(
      id: 'up_4',
      title: 'Annual Sports Tournament Registration',
      description: 'The inter-district cricket & football cup for fans is scheduled for next month. District captains please coordinate with leadership.',
      category: 'Association activities',
      date: '5 days ago',
    ),
  ];

  // Events
  final List<Event> _events = [
    Event(
      id: 'ev_1',
      title: 'Fan Meet 2026',
      date: 'October 18, 2026',
      time: '04:00 PM - 09:00 PM',
      location: 'Hyderabad • Shilpakala Vedika',
      description: 'The mega annual convention of Srekar Fan Association featuring exclusive interactions, stage celebrations, awards, and musical performances.',
      category: 'Fan Meet',
      imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=600&q=80',
      registeredCount: 840,
      isRegistered: true,
    ),
    Event(
      id: 'ev_2',
      title: 'Charity Food & Clothes Distribution',
      date: 'November 05, 2026',
      time: '10:00 AM',
      location: 'Vijayawada • Central Grounds',
      description: 'Community outreach drive supporting local children shelters and distributing educational kits.',
      category: 'Charity',
      imageUrl: 'https://images.unsplash.com/photo-1593113598332-cd288d649433?auto=format&fit=crop&w=600&q=80',
      registeredCount: 310,
      isRegistered: false,
    ),
    Event(
      id: 'ev_3',
      title: 'Grand Birthday Celebration & Cutout Unveiling',
      date: 'December 12, 2026',
      time: '07:00 AM',
      location: 'Bengaluru • Sandhya Theatre',
      description: 'Massive cutout unveiling, cake cutting, fireworks, and fan rally.',
      category: 'Celebration',
      imageUrl: 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?auto=format&fit=crop&w=600&q=80',
      registeredCount: 520,
      isRegistered: false,
    ),
  ];

  // Gallery
  final List<GalleryItem> _gallery = [
    GalleryItem(
      id: 'gal_1',
      title: 'Mega Fan Meet Arena Celebrations',
      category: 'Fan meets',
      imageUrl: 'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?auto=format&fit=crop&w=800&q=80',
      date: 'Sep 2026',
      likes: 342,
    ),
    GalleryItem(
      id: 'gal_2',
      title: 'Association Flag Hoisting Ceremony',
      category: 'Events',
      imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=800&q=80',
      date: 'Aug 2026',
      likes: 198,
    ),
    GalleryItem(
      id: 'gal_3',
      title: 'Community Food Drive Gathering',
      category: 'Photos',
      imageUrl: 'https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&w=800&q=80',
      date: 'Jul 2026',
      likes: 421,
    ),
    GalleryItem(
      id: 'gal_4',
      title: 'Grand Poster & Banner Unveiling',
      category: 'Photos',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=800&q=80',
      date: 'Jun 2026',
      likes: 512,
    ),
    GalleryItem(
      id: 'gal_5',
      title: 'Youth Wing Leadership Summit',
      category: 'Events',
      imageUrl: 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?auto=format&fit=crop&w=800&q=80',
      date: 'May 2026',
      likes: 278,
    ),
    GalleryItem(
      id: 'gal_6',
      title: 'Fans Unity Walk & Rally',
      category: 'Fan meets',
      imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?auto=format&fit=crop&w=800&q=80',
      date: 'Apr 2026',
      likes: 630,
    ),
  ];

  // Polls
  final List<Poll> _polls = [
    Poll(
      id: 'poll_1',
      question: 'Which city should host the Next Grand Fan Meet 2027?',
      options: [
        PollOption(id: 'opt_1', text: 'Hyderabad', votes: 642),
        PollOption(id: 'opt_2', text: 'Bengaluru', votes: 410),
        PollOption(id: 'opt_3', text: 'Vijayawada', votes: 315),
        PollOption(id: 'opt_4', text: 'Visakhapatnam', votes: 260),
      ],
      userVotedIndex: 0,
      expiryDate: 'Ends in 4 days',
    ),
    Poll(
      id: 'poll_2',
      question: 'What association welfare initiative should we prioritize next?',
      options: [
        PollOption(id: 'opt_21', text: 'Free Student Education Kits', votes: 380),
        PollOption(id: 'opt_22', text: 'Tree Plantation & Green Drive', votes: 290),
        PollOption(id: 'opt_23', text: 'Mega Health Checkup Camp', votes: 320),
      ],
      userVotedIndex: null,
      expiryDate: 'Active',
    ),
  ];

  // Fan Wall Posts
  final List<FanWallPost> _fanPosts = [
    FanWallPost(
      id: 'fp_1',
      authorName: 'Ramesh Reddy',
      authorCity: 'Hyderabad',
      message: 'Always proud to be a part of Srekar\'s Association! The charity work we do inspires so many youngsters. Long live the brotherhood! ❤️🔥',
      timestamp: '2 hours ago',
      likes: 48,
    ),
    FanWallPost(
      id: 'fp_2',
      authorName: 'Priya Sharma',
      authorCity: 'Bengaluru',
      message: 'Booked my tickets for the Fan Meet 2026! Can\'t wait to meet fellow fans from all districts. See you all on Oct 18! 🎉🙌',
      timestamp: '5 hours ago',
      likes: 34,
    ),
    FanWallPost(
      id: 'fp_3',
      authorName: 'Vikram Karthik',
      authorCity: 'Vijayawada',
      message: 'Vijayawada chapter is ready with special celebrations. Let us make this the biggest fan club ever! 🔥🚀',
      timestamp: '1 day ago',
      likes: 72,
    ),
  ];

  // Leadership Team
  final List<LeadershipMember> _leadership = [
    LeadershipMember(
      id: 'ldr_1',
      name: 'Joshua',
      role: 'President',
      phone: '+91 99887 76655',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
    ),
    LeadershipMember(
      id: 'ldr_2',
      name: 'Arun Kumar',
      role: 'General Secretary',
      phone: '+91 98765 12345',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
    ),
    LeadershipMember(
      id: 'ldr_3',
      name: 'Suresh Varma',
      role: 'Treasurer',
      phone: '+91 97654 32109',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80',
    ),
    LeadershipMember(
      id: 'ldr_4',
      name: 'Kiran Deep',
      role: 'Manager',
      phone: '+91 96543 21098',
      imageUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=400&q=80',
    ),
    LeadershipMember(
      id: 'ldr_5',
      name: 'Manoj Prasad',
      role: 'Coordinator',
      phone: '+91 95432 10987',
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  // Registered members
  final List<Member> _members = [
    Member(
      id: 'm_1',
      name: 'Joshua',
      phone: '+91 99887 76655',
      city: 'Hyderabad',
      membershipId: 'SKR-2026-0001',
      joinedDate: DateTime(2024, 1, 1),
      role: 'President',
      tier: 'President / Founder',
    ),
    Member(
      id: 'm_2',
      name: 'Ramesh Reddy',
      phone: '+91 98480 22334',
      city: 'Hyderabad',
      membershipId: 'SKR-2026-0120',
      joinedDate: DateTime(2024, 5, 12),
      role: 'District Leader',
      tier: 'Platinum VIP',
    ),
    Member(
      id: 'm_3',
      name: 'Priya Sharma',
      phone: '+91 94401 55667',
      city: 'Bengaluru',
      membershipId: 'SKR-2026-0345',
      joinedDate: DateTime(2024, 8, 20),
      role: 'Member',
      tier: 'Gold Fan',
    ),
  ];

  // Getters
  List<UpdateItem> get updates => List.unmodifiable(_updates);
  List<Event> get events => List.unmodifiable(_events);
  List<GalleryItem> get gallery => List.unmodifiable(_gallery);
  List<Poll> get polls => List.unmodifiable(_polls);
  List<FanWallPost> get fanPosts => List.unmodifiable(_fanPosts);
  List<LeadershipMember> get leadership => List.unmodifiable(_leadership);
  List<Member> get members => List.unmodifiable(_members);

  // Updates & announcements
  void addUpdate(UpdateItem update) {
    _updates.insert(0, update);
    notifyListeners();
  }

  void deleteUpdate(String id) {
    _updates.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Events
  void addEvent(Event event) {
    _events.add(event);
    eventsCount++;
    notifyListeners();
  }

  void toggleEventRegistration(String eventId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final ev = _events[index];
      final newStatus = !ev.isRegistered;
      _events[index] = ev.copyWith(
        isRegistered: newStatus,
        registeredCount: newStatus ? ev.registeredCount + 1 : ev.registeredCount - 1,
      );
      notifyListeners();
    }
  }

  void deleteEvent(String id) {
    _events.removeWhere((item) => item.id == id);
    eventsCount--;
    notifyListeners();
  }

  // Gallery
  void addGalleryItem(GalleryItem item) {
    _gallery.insert(0, item);
    photosCount++;
    notifyListeners();
  }

  void toggleGalleryLike(String id) {
    final index = _gallery.indexWhere((g) => g.id == id);
    if (index != -1) {
      final g = _gallery[index];
      final newLiked = !g.isLiked;
      _gallery[index] = g.copyWith(
        isLiked: newLiked,
        likes: newLiked ? g.likes + 1 : g.likes - 1,
      );
      notifyListeners();
    }
  }

  void deleteGalleryItem(String id) {
    _gallery.removeWhere((g) => g.id == id);
    photosCount--;
    notifyListeners();
  }

  // Polls
  void votePoll(String pollId, int optionIndex) {
    final pollIdx = _polls.indexWhere((p) => p.id == pollId);
    if (pollIdx != -1) {
      final poll = _polls[pollIdx];
      if (poll.userVotedIndex != null) return; // already voted

      final options = List<PollOption>.from(poll.options);
      final opt = options[optionIndex];
      options[optionIndex] = opt.copyWith(votes: opt.votes + 1);

      _polls[pollIdx] = poll.copyWith(
        options: options,
        userVotedIndex: optionIndex,
      );
      notifyListeners();
    }
  }

  void addPoll(Poll poll) {
    _polls.insert(0, poll);
    notifyListeners();
  }

  void deletePoll(String id) {
    _polls.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Fan Posts
  void addFanPost(String name, String city, String message) {
    _fanPosts.insert(
      0,
      FanWallPost(
        id: 'fp_${DateTime.now().millisecondsSinceEpoch}',
        authorName: name,
        authorCity: city,
        message: message,
        timestamp: 'Just now',
      ),
    );
    notifyListeners();
  }

  void toggleFanPostLike(String id) {
    final post = _fanPosts.firstWhere((p) => p.id == id);
    post.isLiked = !post.isLiked;
    post.likes += post.isLiked ? 1 : -1;
    notifyListeners();
  }

  void deleteFanPost(String id) {
    _fanPosts.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Members
  void registerNewMember(Member member) {
    _members.add(member);
    memberCount++;
    notifyListeners();
  }

  void deleteMember(String id) {
    _members.removeWhere((m) => m.id == id);
    memberCount--;
    notifyListeners();
  }
}
