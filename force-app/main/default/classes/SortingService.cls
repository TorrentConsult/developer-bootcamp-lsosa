/* ------------ Used in OOP Using Apex Live Session ------------ */

public with sharing class SortingService {
    public static List<Object> dynamicSort(String className, List<Object> values) {
        Type t = Type.forName(className);
        ISortable obj = (ISortable)t.newInstance();
        List<Object> sorted = obj.sort(values);
        return sorted;
    }
}