class PollOption {
  final String id;
  final String text;
  final int votes;

  PollOption({
    required this.id,
    required this.text,
    this.votes = 0,
  });

  PollOption copyWith({
    String? id,
    String? text,
    int? votes,
  }) {
    return PollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      votes: votes ?? this.votes,
    );
  }
}

class Poll {
  final String id;
  final String question;
  final List<PollOption> options;
  final int? userVotedIndex;
  final bool isClosed;
  final String expiryDate;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    this.userVotedIndex,
    this.isClosed = false,
    this.expiryDate = 'Active',
  });

  int get totalVotes => options.fold(0, (sum, option) => sum + option.votes);

  Poll copyWith({
    String? id,
    String? question,
    List<PollOption>? options,
    int? userVotedIndex,
    bool? isClosed,
    String? expiryDate,
  }) {
    return Poll(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      userVotedIndex: userVotedIndex ?? this.userVotedIndex,
      isClosed: isClosed ?? this.isClosed,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
