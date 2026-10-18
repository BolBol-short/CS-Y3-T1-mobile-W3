import '../model/student.dart';
import '../model/course.dart';
import '../model/course_result.dart';

class LmsSystem {
  //Global student/course list
  final List<Course> courses = [];
  final List<Student> students = [];
  final List<CourseResult> results = [];

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
    results.removeWhere((r) => r.courseId == courseId);
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
      throw Exception('Student $studentId already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  // remove a student
  // precondition: student exists
  // postcondition: remove every refernece to the student
  // rule: everything related (enroll in courses and student's results) to student will be removed
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

    // 3- Remove every existing results belong to the student
    results.removeWhere((r) => r.studentId == studentId);
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
  // precondition: student exists, course need to be exist, and student should be enroll in the course
  // postcondition: remove every reference to the student from said course and result from said course but doesn't remove the student entirely from other courses and results
  // rule: discarding a student from a course, will remove the student from the course and remove their results on that course
  void discardStudentFromCourse({required String studentId, required String courseId}){
    Student? tempStudent = _findStudentOrNull(studentId);
    if (tempStudent == null) {
      throw Exception('Student $studentId not found');
    }
    
    Course? tempCourse = _findCourseOrNull(courseId);
    if (tempCourse == null){
      throw Exception('Course with Id: $courseId is not found!');
    }

    if (!tempCourse.studentIds.contains(studentId)){
      throw Exception('Student with Id: $studentId is not enroll in this course Id: $courseId');
    }

    tempCourse.studentIds.removeWhere((s) => s == studentId);
    results.removeWhere((r) => r.studentId == studentId && r.courseId == courseId);
  }

  // Result
  // add result to a student in a course
  // precondition: the student exists, the course exists, the student is enrolled in the course, the score is between 0 and 100, and the student has no result for this course yet.
  // postcondition: results holds 1 new CourseResult for this student and course.
  // rule: 1 result per student per course.

  void addResult({required String studentId, required String courseId, required double score}){
    Student? tempStudent = _findStudentOrNull(studentId);
    if (tempStudent == null) {
      throw Exception('Student $studentId not found');
    }

    Course? exisitingCourse = _findCourseOrNull(courseId);
    if (exisitingCourse == null){
      throw Exception('Course with Id: $courseId is not found!');
    }

    if (!exisitingCourse.studentIds.contains(studentId)){
      throw Exception('Student with Id: $studentId is not enroll in this course Id: $courseId');
    }

    if (score < 0 || score > 100){
      throw Exception('Student\'s score is out of range (0-100)');
    }

    if (results.any((r) => r.studentId == studentId && r.courseId == courseId)){
      throw Exception('Student\'s result already exist');
    }

    results.add(CourseResult(studentId: studentId, courseId: courseId, score: score));
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

    if (!exisitingCourse.studentIds.contains(studentId)){
      throw Exception('Student with Id: $studentId is not enroll in this course Id: $courseId');
    }

    if (!results.any((r) => r.studentId == studentId && r.courseId == courseId)){
      throw Exception('Student\'s result does not exist');
    }

    results.removeWhere((r) => r.studentId == studentId && r.courseId == courseId);
  }
}
