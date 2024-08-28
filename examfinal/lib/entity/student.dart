import 'subject.dart';

class Student {
  String id;
  String name;
  List<Subject> subjects;

  Student({required this.id, required this.name, required this.subjects});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      subjects: (json['subjects'] as List)
          .map((subject) => Subject.fromJson(subject))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ID: $id, Name: $name, Subjects: $subjects';
  }
}
