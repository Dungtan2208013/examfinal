class Subject {
  String name;
  List<int> scores;

  Subject({required this.name, required this.scores});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      scores: List<int>.from(json['scores']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'scores': scores,
    };
  }

  @override
  String toString() {
    return 'Subject: $name, Scores: ${scores.join(", ")}';
  }
}
