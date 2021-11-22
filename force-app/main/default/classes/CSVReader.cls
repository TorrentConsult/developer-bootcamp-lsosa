public class CSVReader {
    
    public static final String COMMA = String.fromCharArray(new List<Integer> {44});
    public static final String CR = '\r';
    public static final String DQUOTE = '\"';
    public static final String LF = '\n';
    public static final String CRLF = CR + LF;
    public static final String LFCR = LF + CR;
    public static final String DQUOTEDQUOTE = DQUOTE + DQUOTE;
    
    public static List<List<String>> readCSVFile(Blob file) {
        
        String fileString = file.toString();
        
        if (!fileString.endsWith(CRLF)) {
            fileString = fileString + CRLF;
        }
        
        List<List<String>> fileValues = new List<List<String>>();
        List<String> rowValues = new List<String>();
        CsvValue csvValue = new CsvValue();
        
        Boolean eod = false; 
        
        while (!eod) {
            csvValue = readCSVValue(fileString);
            rowValues.add(csvValue.value);
            
            if (csvValue.delimiter == CRLF || csvValue.delimiter == LF) {
                fileValues.add(rowValues);
                if (fileValues.size() > 0) {
                    System.assertEquals(fileValues.get(0).size(), rowValues.size());
                }
                rowValues = new List<String>();
            }
            
            if (csvValue.biteSize() == fileString.length()) {
                eod = true;
            } else {
                fileString = fileString.substring(csvValue.biteSize());
            }
        }
        return fileValues;
    }
    
    public static CsvValue readCSVValue(String data) {
        
        System.assert(data.endsWith(CRLF));
        CsvValue csvValue = new CsvValue();
        
        if (data.startsWith(DQUOTE)) {
            
            csvValue.enclosed = true;
            Integer searchIndex = 1;      // starting index to search
            Integer dquoteIndex = -1;     // index of DQUOTE
            Integer dquotesIndex = -1;    // index of DQUOTEDQUOTE
            Boolean closerFound = false;
            
            while (!closerFound) {
                dquoteIndex = data.indexOf(DQUOTE, searchIndex);
                dquotesIndex = data.indexOf(DQUOTEDQUOTE, searchIndex);
                System.assert(dquoteIndex != -1);
                if (dquoteIndex == dquotesIndex) {
                    searchIndex = dquotesIndex + DQUOTEDQUOTE.length();
                } else {
                    closerFound = true;
                }
            }
            
            csvValue.value = data.substring(DQUOTE.length(), dquoteIndex)
                .replaceAll(DQUOTEDQUOTE, DQUOTE);
            
            Integer commaIndex = data.indexOf(COMMA, dquoteIndex);
            Integer crlfIndex = data.indexOf(CRLF, dquoteIndex);
			Integer lfIndex = data.indexOf(LF, dquoteIndex);
            
            if (commaIndex != -1 && commaIndex < crlfIndex && commaIndex < lfIndex) {
                csvValue.delimiter = COMMA;
            } else {
                if (lfIndex < crlfIndex) {
                    csvValue.delimiter = LF;
                } else {
                    csvValue.delimiter = CRLF;
                }
            }
            
        } else {
            csvValue.enclosed = false;
            Integer commaIndex = data.indexOf(COMMA);
            Integer crlfIndex = data.indexOf(CRLF);
            Integer lfIndex = data.indexOf(LF);

            if (commaIndex != -1 && commaIndex < crlfIndex && commaIndex < lfIndex) {
                csvValue.value = data.substring(0, commaIndex);
                csvValue.delimiter = COMMA;
            } else {
                if (lfIndex < crlfIndex) {
                    csvValue.value = data.substring(0, lfIndex);
                    csvValue.delimiter = LF;
                } else {
                    csvValue.value = data.substring(0, crlfIndex);
                    csvValue.delimiter = CRLF;
                }
            }
        }
        return csvValue;
    }

    public class CsvValue {
        
        public String value;
        public Boolean enclosed;
        public String delimiter;
        
        public CsvValue() {
            this(null, null, null);
        }
        
        public CsvValue(String value, Boolean enclosed, String delimiter) {
            this.value = value;
            this.enclosed = enclosed;
            this.delimiter = delimiter;
        }
        
        public Integer biteSize() {
            Integer biteSize = value
                .replaceAll(DQUOTE, DQUOTEDQUOTE).length() + delimiter.length();
            if (enclosed) {
                biteSize += DQUOTE.length() * 2;
            }
            return biteSize;
        }
        
        public Boolean equals(CsvValue compCsvValue) {
            return this.value.equals(compCsvValue.value)
                && this.enclosed == compCsvValue.enclosed
                && this.delimiter == compCsvValue.delimiter;
        }

        public void assertEquals(CsvValue compCsvValue) {
            System.assertEquals(value, compCsvValue.value);
            System.assertEquals(enclosed, compCsvValue.enclosed);
            System.assertEquals(delimiter, compCsvValue.delimiter);
        }
    }
    
}