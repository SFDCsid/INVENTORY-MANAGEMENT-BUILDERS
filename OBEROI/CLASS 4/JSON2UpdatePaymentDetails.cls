public class JSON2UpdatePaymentDetails {
    
    public String PAY_TILL_DATE {get;set;} 
    public String AMT_EXC_GST {get;set;}
    public String TDS_AMT {get;set;}
    public String BAL_PAYABLE {get;set;}
    public String SAL_PRI_DUE {get;set;}
    public String SAL_PRI_REC {get;set;}
    public String GST_DUE {get;set;}
    public String GST_REC {get;set;}
    public String STATUS {get;set;} 
    
    public JSON2UpdatePaymentDetails(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'PAY_TILL_DATE') {
                        PAY_TILL_DATE = parser.getText();
                    }if (text == 'AMT_EXC_GST') {
                        AMT_EXC_GST = parser.getText();
                    } if (text == 'TDS_AMT') {
                        TDS_AMT = parser.getText();
                    } if (text == 'BAL_PAYABLE') {
                        BAL_PAYABLE = parser.getText();
                    } if (text == 'SAL_PRI_DUE') {
                        SAL_PRI_DUE = parser.getText();
                    } if (text == 'SAL_PRI_REC') {
                        SAL_PRI_REC = parser.getText();
                    } if (text == 'GST_DUE') {
                        GST_DUE = parser.getText();
                    } if (text == 'GST_REC') {
                        GST_REC = parser.getText();
                    } 
                }
            }
        }
    }
    
    
    public static JSON2UpdatePaymentDetails parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new JSON2UpdatePaymentDetails(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || curr == System.JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == System.JSONToken.END_OBJECT || curr == System.JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
}