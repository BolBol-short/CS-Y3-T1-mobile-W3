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
  // add a student
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  // remove a student
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);

    // 2- Remove the student from every course in which they enrolled
    for (var course in courses){
      course.studentIds.removeWhere((c) => c == studentId);
    }

    // 3- Remove every exisiting results belong to the student

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

  // Enrollment
  // add student to a course
  // enroll a student
  void enrollStudent({required String studentId, required String courseId}){
    
    Student? enrollStudent = _findStudentOrNull(studentId);
    if (enrollStudent == null) {
      throw Exception('Student $studentId not found');
    }
    
    Course? enrollCourse = _findCourseOrNull(courseId);
    if (enrollCourse == null){
      throw Exception('Course with Id: $courseId is not found!');
    }

    for (var s in enrollCourse.studentIds){
      if (s == enrollStudent.id){
        throw Exception('Student with Id: $studentId already enrolled in course Id: $courseId');
      }
    }

    enrollCourse.studentIds.add(enrollStudent.id);
  }

  // remove a student from a course
  void discardStudentFromCourse({required String studentId, required String courseId}){
    Student? tempStudent = _findStudentOrNull(studentId);
    if (tempStudent == null) {
      throw Exception('Student $studentId not found');
    }
    
    Course? tempCourse = _findCourseOrNull(courseId);
    if (tempCourse == null){
      throw Exception('Course with Id: $courseId is not found!');
    }

    for (var s in tempCourse.studentIds){
      if (s == studentId){
        break;
      }
      if (tempCourse.studentIds[-1] == s && s != studentId){
        throw Exception('Student with Id: $studentId is not enroll in this course Id: $courseId');
      }
    }

    tempCourse.studentIds.removeWhere((s) => s == studentId);
  }

  // Result
  // add result to a student in a course
  void addResult({required String studentId, required String courseId, required double score}){
    Student? tempStudent = _findStudentOrNull(studentId);
    if (tempStudent == null) {
      throw Exception('Student $studentId not found');
    }

    Course? exisitingCourse = _findCourseOrNull(courseId);
    if (exisitingCourse == null){
      throw Exception('Course with Id: $courseId is not found!');
    }

    
  }

  // remove result from a student in a course
  void removeResult({required String studentId, required String courseId}){
    Student? tempStudent = _findStudentOrNull(studentId);
    if (tempStudent == null) {
      throw Exception('Student $studentId not found');
    }

    Course? exisitingCourse = _findCourseOrNull(courseId);
    if (exisitingCourse == null){
      throw Exception('Course with Id: $courseId is not found!');
    }
  }
}
