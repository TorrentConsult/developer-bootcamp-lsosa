/* ------------ Used in OOP Using Apex Live Session ------------ */

public class Numbers implements ISortable {

    public List<Integer> sort(List<Object> values) {
        List<Integer> integers = (List<Integer>)values;
        for (Integer i = 1; i < integers.size(); i++) {
            Integer key = integers[i];
            Integer j = i - 1;
            while (j >= 0 && integers[j] > key) {
                integers[j + 1] = integers[j];
                j = j - 1;
            }
            integers[j + 1] = key;
        }
        return integers;
    }

    public static void run() {

        Numbers obj1 = new Numbers();
        List<Integer> values1 = new List<Integer>{1, 5, 8, 3, 9};
        List<Integer> sorted1 = obj1.sort(values1);
        System.debug(sorted1);

        ISortable obj2 = new Numbers();
        List<Integer> values2 = new List<Integer>{1, 5, 8, 3, 9};
        List<Integer> sorted2 = (List<Integer>)obj2.sort(values2);
        System.debug(sorted2);

        Type t = Type.forName('Numbers');
        ISortable obj3 = (ISortable)t.newInstance();
        List<Integer> values3 = new List<Integer>{1, 5, 8, 3, 9};
        List<Integer> sorted3 = (List<Integer>)obj3.sort(values3);
        System.debug(sorted3);

        List<Integer> sorted4 = 
            (List<Integer>) SortingService.dynamicSort(
                'Numbers', 
                new List<Integer>{1, 5, 8, 3, 9}
            );
        System.debug(sorted4);

    }

}