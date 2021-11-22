/* ------------ Used in OOP Using Apex Live Session ------------ */

public class Letters implements ISortable {

    public List<String> sort(List<Object> values) {
        List<String> strings = (List<String>)values;
        for (Integer i = 1; i < strings.size(); i++) {
            String key = strings[i];
            Integer j = i - 1;
            while (j >= 0 && strings[j] < key) {
                strings[j + 1] = strings[j];
                j = j - 1;
            }
            strings[j + 1] = key;
        }
        return strings;
    }

    public static void run() {

        Letters obj1 = new Letters();
        List<String> values1 = new List<String>{'B', 'S', 'R', 'Z', 'A', 'M'};
        List<String> sorted1 = obj1.sort(values1);
        System.debug(sorted1);

        ISortable obj2 = new Letters();
        List<String> values2 = new List<String>{'B', 'S', 'R', 'Z', 'A', 'M'};
        List<String> sorted2 = (List<String>)obj2.sort(values2);
        System.debug(sorted2);

        Type t = Type.forName('Letters');
        ISortable obj3 = (ISortable)t.newInstance();
        List<String> values3 = new List<String>{'B', 'S', 'R', 'Z', 'A', 'M'};
        List<String> sorted3 = (List<String>)obj3.sort(values3);
        System.debug(sorted3);

        List<String> sorted4 = 
            (List<String>) SortingService.dynamicSort(
                'Letters', 
                new List<String>{'B', 'S', 'R', 'Z', 'A', 'M'}
            );
        System.debug(sorted4);

    }

}