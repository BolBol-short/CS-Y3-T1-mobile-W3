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

     // optional: enroll a student into said course
     lms.addStudent(studentId: 'S1', studentName: 'Bolbol');
     lms.enrollStudent(studentId: 'S1', courseId: 'C1');
     lms.addResult(studentId: 'S1', courseId: 'C1', score: 95);

     // remove a course
     lms.removeCourse(courseId: 'C1');
     expect(lms.courses.length, 0);
     expect(lms.results.length, 0);
     expect(lms.students.length, 0);
     
  });

  // task 2: enroll a student in a course
  test('Enroll a student in a course', () {
    final lms = LmsSystem();
      lms.addCourse(courseId: 'C1', courseName: 'CyberSecurity');
      lms.addStudent(studentId: 'S1', studentName: 'Bolbol');

      lms.enrollStudent(studentId: 'S1', courseId: 'C1');
      expect(lms.courses.first.studentIds.first, lms.students.first.id);

      // reject since student doesn't exisits
      expect(() => lms.enrollStudent(studentId: 'S2', courseId: 'C1'), throwsException);
      // reject since course doesn't exists
      expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C2'), throwsException);
      // reject duplication
      expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C1'), throwsException);

  });

  // task 3 : remove a student from a course
  test('Remove a student from a course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S1', studentName: 'Bolbol');
    lms.addStudent(studentId: 'S2', studentName: 'Hashmi');

    lms.addCourse(courseId: 'C1', courseName: 'MobileDevelopment');
    lms.addCourse(courseId: 'C2', courseName: 'CyberSecurity');
    lms.addCourse(courseId: 'C3', courseName: 'ProjectManagement');
    lms.addCourse(courseId: 'C4', courseName: 'GameDevelopment');
    
    // 1 course
    // enroll a student in a course
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    expect(lms.courses.first.studentIds.first, lms.students.first.id);

    // reject: re-enroll the student
    expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C1'), throwsException);

    // reject: remove a student that is not in the course
    expect(() => lms.discardStudentFromCourse(studentId: 'S2', courseId: 'C1'), throwsException);

    // reject: remove a student that is not from that course
    expect(() => lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C2'), throwsException);

    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');
    expect(lms.courses.first.studentIds.length, 0);
    expect(lms.students.first.id, 'S1');
    expect(lms.courses.first.id, 'C1');

    // several courses
    lms.enrollStudent(studentId: 'S2', courseId: 'C1');
    lms.enrollStudent(studentId: 'S2', courseId: 'C2');
    lms.enrollStudent(studentId: 'S2', courseId: 'C3');
    lms.enrollStudent(studentId: 'S2', courseId: 'C4');

    lms.addResult(studentId: 'S2', courseId: 'C3', score: 100);

    lms.discardStudentFromCourse(studentId: 'S2', courseId: 'C3');
    expect(lms.courses[0].studentIds.length, 1);
    expect(lms.courses[1].studentIds.length, 1);
    expect(lms.courses[2].studentIds.length, 0);
    expect(lms.courses[3].studentIds.length, 1);
    expect(lms.results.contains('S2'), false);
    expect(lms.results.length, isZero);

    lms.removeStudent(studentId: 'S2');
    expect(lms.courses[0].studentIds.length, 0);
    expect(lms.courses[1].studentIds.length, 0);
    expect(lms.courses[2].studentIds.length, 0);
    expect(lms.courses[3].studentIds.length, 0);
  });

  // task 4 : Add a result to a course
  test('Add a result to a course', () {
    final lms = LmsSystem();
    
    lms.addStudent(studentId: 'S1', studentName: 'Bolbol');
    lms.addStudent(studentId: 'S2', studentName: 'Hashmi');

    lms.addCourse(courseId: 'C1', courseName: 'MobileDevelopment');
    
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    // add result to a student in a course
    lms.addResult(studentId: 'S1', courseId: 'C1', score: 70);
    expect(lms.results.first.studentId, lms.students.first.id);
    expect(lms.results.first.courseId, lms.courses.first.id);
    expect(lms.results.first.score, 70);

    // reject: duplication
    expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 75), throwsException);

    // reject: not enrolled student
    expect(() => lms.addResult(studentId: 'S2', courseId: 'C1', score: 100), throwsException);

    // reject: not existent student
    expect(() => lms.addResult(studentId: 'S3', courseId: 'C1', score: 75), throwsException);

    // reject: nonexistent course
    expect(() => lms.addResult(studentId: 'S1', courseId: 'C3', score: 80), throwsException);

    // reject: invalid score (both < 0 & > 100)
    lms.enrollStudent(studentId: 'S2', courseId: 'C1');
    expect(() => lms.addResult(studentId: 'S2', courseId: 'C1', score: -1), throwsException);
    expect(() => lms.addResult(studentId: 'S2', courseId: 'C1', score: 101), throwsException);
    expect(lms.results.length, 1);
    expect(() => lms.addResult(studentId: 'S2', courseId: 'C1', score: 100), returnsNormally);
    expect(lms.results.length, 2);
  });

  // task 5 : remove a student result
  test('Remove a student\'s result', () {
    final lms = LmsSystem();
    
    lms.addStudent(studentId: 'S1', studentName: 'Bolbol');
    lms.addStudent(studentId: 'S2', studentName: 'Hashmi');

    lms.addCourse(courseId: 'C1', courseName: 'MobileDevelopment');
    
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S2', courseId: 'C1');

    lms.addResult(studentId: 'S1', courseId: 'C1', score: 70);
    lms.addResult(studentId: 'S2', courseId: 'C1', score: 100);
    expect(lms.results.length, 2);
    expect(lms.students.length, 2);
    expect(lms.courses.length, 1);
    expect(lms.results[1].score, 100);

    // remove an existing result
    lms.removeResult(studentId: 'S1', courseId: 'C1');
    expect(lms.results.length, 1);

    // reject: remove of a nonexistent result
    expect(() => lms.removeResult(studentId: 'S1', courseId: 'C1'), throwsException);

    // verify that the result is no longer available
    expect(lms.results.first.studentId == lms.students.first.id, false);

    // verify that the student, course, and unrelated result remain unchanged
    expect(lms.results.first.studentId, lms.students[1].id);

  });

  // test (scenario)
  test('Scenario', () {
    final lms = LmsSystem();
    
    lms.addStudent(studentId: 'S1', studentName: 'Bolbol');
    lms.addStudent(studentId: 'S2', studentName: 'Hashmi');

    lms.addCourse(courseId: 'C1', courseName: 'MobileDevelopment');
    
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S2', courseId: 'C1');

    lms.addResult(studentId: 'S1', courseId: 'C1', score: 70);
    lms.addResult(studentId: 'S2', courseId: 'C1', score: 100);

    lms.removeStudent(studentId: 'S1');

    // check for the existence of said student
    expect(lms.courses.length, 1);
    expect(lms.students.length, 1);
    expect(lms.students.first.id, 'S2');
    expect(lms.courses.first.studentIds.length, 1);
    expect(lms.courses.first.studentIds.contains('S1'), false);
    expect(lms.results.first.studentId, 'S2');
    expect(lms.results.first.score, 100);

    expect(() => lms.addStudent(studentId: 'S1', studentName: 'Bol'), returnsNormally);

  });
 }
