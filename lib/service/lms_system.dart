import '../model/student.dart';
import '../model/course.dart';
import '../model/course_result.dart';

class LmsSystem {
  //Global student/course list
  final List<Course> courses = [];
  final List<Student> students = [];

  // Course Functions
  // add a course
  void addCourse({required String courseId, required String courseName}){
    Course? exisitingCourse = _findCourseOrNull(courseId);
    if (exisitingCourse != null){
      throw Exception('Course with the id: $courseId, already exists');
    }

    Course newCourse = Course(id: courseId, name: courseName);
    courses.add(newCourse);
  }

  // remove a course
  void removeCourse({required String courseId}){
    Course? exisitingCourse = _findCourseOrNull(courseId);
    if (exisitingCourse == null){
      throw Exception('Course with Id: $courseId is not found!');
    }

    courses.removeWhere((c) => c.id == courseId);
  }

  // Course helper function
  Course? _findCourseOrNull(String courseId){
    return courses.where((c) => c.id == courseId).firstOrNull;
  }

  // Student Functions
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
 
  }
  // Student helper functions
  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  } 
}
