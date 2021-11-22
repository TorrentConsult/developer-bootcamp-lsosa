/* ------------ Git in Action Live Session ------------ */

@isTest
class ArithmeticTest {

    static testMethod void leastCommonMultiple_test() {

        Integer a = -10;
        Integer b = 11;
        Integer lcm = Arithmetic.leastCommonMultiple(a, b);
        System.assertEquals(110, lcm, 'Should be equal to 110');
    }

}