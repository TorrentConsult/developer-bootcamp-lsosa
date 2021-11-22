/* ------------ Used in Deep Dive into Apex Live Session ------------ */

public with sharing class Student {

    private static Integer studentCount = 0;
    private String firstName;
    private String lastName;
    private Integer studentId;

    public Student(String firstName, String lastName) {
        studentCount++;
        this.firstName = firstName;
        this.lastName = lastName;
        this.studentId = studentCount;
    }
    public static Integer getStudentCount() {
        return studentCount;
    }
    public String getStudentName() {
        return firstName + ' ' + lastName;
    }

    public static void run() {

        Student student1 = new Student('Maria', 'Gomez');
        Student student2 = new Student('Marc', 'Cruz');

        System.debug(student1.getStudentName());    //Maria Gomez
        System.debug(student2.getStudentName());    //Marc Cruz
        System.debug(Student.getStudentCount());    //2

    }

}