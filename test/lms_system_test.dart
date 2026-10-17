import 'package:test/test.dart';

import '../lib/service/lms_system.dart';

void main() {
  // example of a test
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });
  
  // tests
  // task 1: Add and Remove course
  test('Create a course and remove it', () {
    final lms = LmsSystem();
     
     // add a course
     lms.addCourse(courseId: 'C1', courseName: 'MobileDevelopment');
     expect(lms.courses.first.id, 'C1');

     // add duplicated course but reject with exception
     expect(() => lms.addCourse(courseId: 'C1', courseName: 'WebDevelopment'), throwsException);

     // remove non-existent course
     expect(() => lms.removeCourse(courseId: 'C2'), throwsException);

     // remove a course
     lms.removeCourse(courseId: 'C1');
     expect(lms.courses.length, 0);
     
  });

  // task 2: enroll a student in a course
  test('Enroll a student in a course', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'CyberSecurity');
    lms.addStudent(studentId: 'S1', studentName: 'Bolbol');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
  });
 }
