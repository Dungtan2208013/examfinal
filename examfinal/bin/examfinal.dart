import 'dart:convert';
import 'dart:io';
import '../lib/entity/student.dart';
import '../lib/entity/subject.dart';

void main() {
  List<Student> students = loadStudents();

  while (true) {
    print("\nStudent Management System");
    print("1. Hiển thị toàn bộ sinh viên");
    print("2. Thêm sinh viên");
    print("3. Sửa thông tin sinh viên");
    print("4. Tìm kiếm sinh viên theo Tên hoặc ID");
    print("5. Thoát");

    stdout.write("Chọn một tùy chọn: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        displayAllStudents(students);
        break;
      case '2':
        students.add(addStudent());
        saveStudents(students);
        break;
      case '3':
        editStudent(students);
        saveStudents(students);
        break;
      case '4':
        searchStudent(students);
        break;
      case '5':
        print("Thoát chương trình.");
        return;
      default:
        print("Lựa chọn không hợp lệ, vui lòng thử lại.");
    }
  }
}

List<Student> loadStudents() {
  try {
    final file = File('Student.json');
    String content = file.readAsStringSync();
    List<dynamic> jsonData = jsonDecode(content);
    return jsonData.map((data) => Student.fromJson(data)).toList();
  } catch (e) {
    print("Lỗi khi đọc file: $e");
    return [];
  }
}

void saveStudents(List<Student> students) {
  final file = File('Student.json');
  String jsonContent = jsonEncode(students.map((s) => s.toJson()).toList());
  file.writeAsStringSync(jsonContent);
}

void displayAllStudents(List<Student> students) {
  if (students.isEmpty) {
    print("Không có sinh viên nào trong danh sách.");
    return;
  }

  print("Danh sách sinh viên:");
  for (var student in students) {
    print("ID: ${student.id}, Tên: ${student.name}");

    // Hiển thị thông tin môn học
    if (student.subjects.isNotEmpty) {
      for (var subject in student.subjects) {
        print("  Môn học: ${subject.name}");
        print("  Điểm: ${subject.scores.join(", ")}");
      }
    } else {
      print("  Không có môn học nào.");
    }
    print(""); // Dòng trống để phân cách giữa các sinh viên
  }
}

Student addStudent() {
  stdout.write("Nhập ID: ");
  String id = stdin.readLineSync() ?? '';

  stdout.write("Nhập tên: ");
  String name = stdin.readLineSync() ?? '';

  List<Subject> subjects = [];
  while (true) {
    stdout.write("Nhập tên môn học (hoặc nhấn Enter để dừng): ");
    String subjectName = stdin.readLineSync() ?? '';
    if (subjectName.isEmpty) break;

    stdout.write("Nhập điểm thi (cách nhau bằng dấu phẩy): ");
    List<int> scores = (stdin.readLineSync() ?? '')
        .split(',')
        .map((s) => int.tryParse(s.trim()) ?? 0)
        .toList();

    subjects.add(Subject(name: subjectName, scores: scores));
  }

  return Student(id: id, name: name, subjects: subjects);
}

void editStudent(List<Student> students) {
  stdout.write("Nhập ID sinh viên cần sửa: ");
  String id = stdin.readLineSync() ?? '';

  Student? student = students.firstWhere(
    (s) => s.id == id, 
    orElse: () {
      print("Không tìm thấy sinh viên với ID đã nhập.");
      return Student(id: '', name: '', subjects: []); // Trả về một sinh viên rỗng thay vì null
    }
  );

  // Nếu ID không tìm thấy, in ra thông báo và thoát hàm
  if (student.id.isEmpty) {
    return;
  }

  stdout.write("Nhập tên mới (hoặc nhấn Enter để giữ nguyên): ");
  String newName = stdin.readLineSync() ?? '';
  if (newName.isNotEmpty) student.name = newName;

  // Sửa, thêm hoặc xóa môn học
  print("Sửa thông tin môn học:");
  student.subjects.forEach((subject) {
    print(subject);
  });

  // Thêm logic thêm/sửa/xóa môn học ở đây nếu cần
}

void searchStudent(List<Student> students) {
  stdout.write("Nhập tên hoặc ID sinh viên: ");
  String query = stdin.readLineSync() ?? '';

  List<Student> results = students
      .where((student) =>
          student.id.contains(query) || student.name.contains(query))
      .toList();

  if (results.isEmpty) {
    print("Không tìm thấy sinh viên.");
  } else {
    results.forEach(print);
  }
}
