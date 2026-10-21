# W3 Layered Architecture: LMS

## Layers

model/ holds the data classes (Student, Course, CourseResult).
service/ holds LmsSystem, which owns the lists and enforces the rules.
test/ calls the service and checks the results.

## Where relationships are stored

- Enrollment: stored in `Course.studentIds` as a list of String.
  I chose this because students can enroll in multiple courses.
- Results: stored in a separate list in lms_system,
  with student's id, course's id, and score on each result.
  I chose this so `Course` stays small and does not hold many list.

## Rules I chose

- Removing a course: remove every result related to that course, results and enrollments go, students stay, & course will be removed from the courses list in LMS system.
- Discarding a student from a course: will delete the student's result from that course and discard the student from the list of students in the course.
- Removing a student: will delete everything related to the student including in the students list, student's courses/enrollment, and student's results.
- Adding a result: needs student & course to exist, score range 0-100,
  and only one result per student per course.
- Removing a result: needs student, course to exist, check whether if the student in already enrolled in the course, and the result exists.

## Tests

Each task has a test, plus a scenario test that removes one student
and checks the other student's data is unchanged.
