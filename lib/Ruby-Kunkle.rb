##############
# Author: Abi Kunkle
# Date: 11/20/2022
# Editor: Visual Studio 2022
# Class: Cs424
#
#######################
# Classes
#######################
# Student class
class Student
  @student_id
  @student_name
  @courses_enrolled = []
  # rather than creating getter and setter methods, we can use the built-in
  # attr_accessor method, which generates getter and setter methods
  attr_accessor :student_name, :student_id, :courses_enrolled
  def initialize(student_id, student_name, courses_enrolled)
    @student_id = student_id          # instance variables
    @student_name = student_name
    @courses_enrolled = courses_enrolled
  end


  def add_course(course, student)
    courses_enrolled = student.instance_variable_get(:@courses_enrolled).clone
    courses_enrolled.push(course)
    @courses_enrolled = courses_enrolled
    return courses_enrolled
  end
end

# Course class
class Course
  @course_crn
  @course_name
  @students_enrolled = []
  # rather than creating getter and setter methods, we can use the built-in
  # attr_accessor method, which generates getter and setter methods
  attr_accessor :course_crn, :course_name, :students_enrolled

  def initialize(course_crn, course_name, students_enrolled)
    @course_crn = course_crn       # instance variables
    @course_name = course_name
    @students_enrolled = students_enrolled
  end

  def add_student(student_name, course)
    students_enrolled = course.instance_variable_get(:@students_enrolled).clone
    students_enrolled.push(student_name)
    @students_enrolled = students_enrolled
    return students_enrolled
  end

end

# Enrollment class. I added this class as a data structure to keep track of the students enrolled overall.
class Enrollment
  # # Arrays of student and course objects
  # @students = Array.new
  # @courses = Array.new

  def initialize(students, courses)
    @students = students
    @courses = courses
  end

  attr_accessor :students, :courses
end
#######################
# Methods
#######################
# Read input from file, and store each section into a string
def read_input
  file = File.open("register.txt")
  file_data = file.read
  split_data = file_data.split(/\n{2,}/)  # splits input into an array of substrings. delimiter(pattern) is a blank line.

  # assigns each substring to a variable
  students_data = split_data[0]
  courses_data = split_data[1]
  enrollment_data = split_data[2]

  return students_data, courses_data, enrollment_data       # returns each substring!
end

def read_students_data(students_data)
  students_array = Array.new
  courses_array = Array.new
  courses_enrolled = Array.new
  enrollment = Enrollment.new(students_array, courses_array)
  students_data.each_line do |line|     # for each line in this string, assign some variables
    student_id = line.split.first  # We can get the first word in a string by calling split and first
    student_name = line.partition(" ").last.lstrip    # get everything after the first substring. string it of the leading whitespace.
    new_student = Student.new(student_id, student_name, courses_enrolled)

    enrollment.instance_variable_set(:@students,students_array.push(new_student))  # update the enrollment class' students array
  end

  return enrollment
end


def read_courses_data(courses_data, enrollment)
  courses_array = Array.new
  students_enrolled = Array.new
  courses_data.each_line do |line|     # for each line in this string, assign some variables
    course_crn = line.split.first  # We can get the first word in a string by calling split and first
    course_name = line.partition(" ").last.lstrip    # get everything after the first substring. string it of the leading whitespace.
    new_course = Course.new(course_crn, course_name, students_enrolled)

    enrollment.instance_variable_set(:@courses,courses_array.push(new_course))  # update the enrollment class' students array
  end
  return enrollment
end


def read_enrollment_data(enrollment_data, enrollment)
  students_array = enrollment.instance_variable_get(:@students).clone
  courses_array = enrollment.instance_variable_get(:@courses).clone

  enrollment_data.each_line do |line|     # for each line in this string, assign some variables
    input_student_id = line.split.first  # We can get the first word in a string by calling split and first
    input_course_num = line.partition(" ").last.lstrip.strip    # get everything after the first substring. string it of the leading whitespace.


    # # get the student and course objects with the matching ids and name
    student_by_id = students_array.find{|s| s.instance_variable_get(:@student_id) == input_student_id }
    course_by_id = courses_array.find{|c| c.instance_variable_get(:@course_crn) == input_course_num }

    full_course_name = course_by_id.instance_variable_get(:@course_name).clone
    student_name = student_by_id.instance_variable_get(:@student_name).clone
    courses_enrolled = student_by_id.add_course(full_course_name, student_by_id)
    student_enrolled = course_by_id.add_student(student_name, course_by_id)

  end

  return students_array, courses_array

end


def get_students_with_course_names(students_array)
  puts "************** Students with course names **************"
  students_array.each do |student|
    student_name = student.instance_variable_get(:@student_name)
    courses_enrolled = student.instance_variable_get(:@courses_enrolled)
    puts student_name
    puts courses_enrolled
  end
end

def get_courses_with_student_names(courses_array)
  puts "************** Courses with student names **************"
  courses_array.each do |course|
    course_crn = course.instance_variable_get(:@course_crn)
    course_name = course.instance_variable_get(:@course_name)
    students_enrolled = course.instance_variable_get(:@students_enrolled)
    puts "CRN:     " + course_crn + "   Course:     " + course_name
    puts students_enrolled
  end
end

module RubyProgCs424

  students_data, courses_data, enrollment_data = read_input()  # unpacks returned values in one line! :)
  enrollment = read_students_data(students_data)
  enrollment = read_courses_data(courses_data, enrollment)
  students_array, courses_array = read_enrollment_data(enrollment_data, enrollment)
  get_students_with_course_names(students_array)
  get_courses_with_student_names(courses_array)

end




# A few things I like about Ruby:
#  - Methods can easily return multiple values ( see line ). My go-to language, Java, does not support this, and
#    requires some finagling to achieve a similar result. Whereas in Ruby, I can unpack multiple returned values
#    in a single line! I am a big fan of this little feature.
#  Overall, this language is easy enough to use.