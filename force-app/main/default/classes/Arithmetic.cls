/* ------------ Git in Action Live Session ------------ */

public with sharing class Arithmetic {

    public static Integer leastCommonMultiple(Integer number1, Integer number2) {

        if (number1 == 0 || number2 == 0) {
            return 0;
        }

        Integer higherNumber = Math.max(number1, number2);
        Integer lowerNumber = Math.min(number1, number2);
        Integer lcm = higherNumber;
        while (Math.mod(lcm, lowerNumber) != 0) {
            lcm += higherNumber;
        }

        return lcm;
    }
    
    public static Integer leastCommonMultiple2(Integer number1, Integer number2) {

        if (number1 == 0 || number2 == 0) {
            return 0;
        }

        number1 = Math.abs(number1);
        number2 = Math.abs(number2);
        Integer higherNumber = Math.max(number1, number2);
        Integer lowerNumber = Math.min(number1, number2);
        Integer lcm = higherNumber;
        while (Math.mod(lcm, lowerNumber) != 0) {
            lcm += higherNumber;
        }

        return lcm;
    }

    public static Integer leastCommonMultiple(Integer number1, Integer number2, Integer number3) {

        if (number1 == 0 || number2 == 0 || number3 == 0) {
            return 0;
        }

        //Find lcm of first two numbers
        Integer higherNumber = Math.max(number1, number2);
        Integer lowerNumber = Math.min(number1, number2);
        Integer lcm = higherNumber;
        while (Math.mod(lcm, lowerNumber) != 0) {
            lcm += higherNumber;
        }

        //Find lcm of calculation from first two numbers with the third number
        higherNumber = Math.max(lcm, number3);
        lowerNumber = Math.min(lcm, number3);
        lcm = higherNumber;
        while (Math.mod(lcm, lowerNumber) != 0) {
            lcm += higherNumber;
        }
        return lcm;
    }    

    public static Integer leastCommonMultiple(List<Integer> numbers) {

        if (numbers.isEmpty()) {
            return 0;
        } else if (numbers.size() == 1) {
            return numbers[0];
        } else if (numbers[0] == 0 || numbers[1] == 0) {
            return 0;
        }

        Integer higherNumber = Math.max(Math.abs(numbers[0]), Math.abs(numbers[1]));
        Integer lowerNumber = Math.min(Math.abs(numbers[0]), Math.abs(numbers[1]));
        Integer lcm = higherNumber;
        while (Math.mod(lcm, lowerNumber) != 0) {
            lcm += higherNumber;
        }

        //Return lcm if there are only two numbers
        if (numbers.size() == 2) {
            return lcm;
        } else {
        //Else rerun and Remove number1 from list and replace number2 with lcm
            numbers.remove(0);
            numbers[0] = lcm;
            return leastCommonMultiple(numbers);
        }   
    }

    public static void run() {

        Integer a = 4;
        Integer b = 6;
        Integer c = 18;
        Integer d = 22;
        Integer e = 30;
        System.debug(Arithmetic.leastCommonMultiple(a, b));
        System.debug(Arithmetic.leastCommonMultiple(a, b, c));
    }

}