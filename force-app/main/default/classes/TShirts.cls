/* ------------ Used in OOP Using Apex Live Session ------------ */

public class TShirts implements ISortable {

    Map<String, Integer> sizeToValue= new Map<String, Integer>{'S'=>1, 'M'=>2, 'L'=>3}; //Assign a Numeric Value to each Size
    public List<String> sort(List<Object> values) {
        List<String> sizes = (List<String>)values;
        Boolean sorted = false;
        while (!sorted) {
            sorted = true;
            for (Integer i = 0; i < sizes.size() - 1; i++) {
                //If this shirt is bigger than the next shirt
                if (sizeToValue.get(sizes[i]) > sizeToValue.get(sizes[i + 1])) {  
                    String size = sizes[i];     
                    sizes[i] = sizes[i+1];  //Swap the two shirts
                    sizes[i+1] = size;
                    sorted = false;         //Need to run until we no longer need to swap anything
                }
            }
        }   
        return sizes;
    }

    public static void run() {

        TShirts obj1 = new TShirts();
        List<String> values1 = new List<String>{'M', 'L', 'S', 'S', 'L', 'M'};
        List<String> sorted1 = obj1.sort(values1);
        System.debug(sorted1);

        ISortable obj2 = new TShirts();
        List<String> values2 = new List<String>{'M', 'L', 'S', 'S', 'L', 'M'};
        List<String> sorted2 = (List<String>)obj2.sort(values2);
        System.debug(sorted2);

        Type t = Type.forName('TShirts');
        ISortable obj3 = (ISortable)t.newInstance();
        List<String> values3 = new List<String>{'M', 'L', 'S', 'S', 'L', 'M'};
        List<String> sorted3 = (List<String>)obj3.sort(values3);
        System.debug(sorted3);

        List<String> sorted4 = 
            (List<String>) SortingService.dynamicSort(
                'TShirts', new List<String>{'M', 'L', 'S', 'S', 'L', 'M'}
            );
        System.debug(sorted4);

    }

}