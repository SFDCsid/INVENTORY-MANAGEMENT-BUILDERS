public class JSON2ApexCostomerCreate { 

    public String TYPE_Z {get;set;} // in json: TYPE
    public String ID {get;set;} 
    public Integer NUMBER_Z {get;set;} // in json: NUMBER
    public String MESSAGE {get;set;} 
    public String LOG_NO {get;set;} 
    public Integer LOG_MSG_NO {get;set;} 
    public String MESSAGE_V1 {get;set;} 
    public String MESSAGE_V2 {get;set;} 
    public String MESSAGE_V3 {get;set;} 
    public String MESSAGE_V4 {get;set;} 

    public JSON2ApexCostomerCreate(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'TYPE') {
                        TYPE_Z = parser.getText();
                    } else if (text == 'ID') {
                        ID = parser.getText();
                    } else if (text == 'NUMBER') {
                        NUMBER_Z = parser.getIntegerValue();
                    } else if (text == 'MESSAGE') {
                        MESSAGE = parser.getText();
                    } else if (text == 'LOG_NO') {
                        LOG_NO = parser.getText();
                    } else if (text == 'LOG_MSG_NO') {
                        LOG_MSG_NO = parser.getIntegerValue();
                    } else if (text == 'MESSAGE_V1') {
                        MESSAGE_V1 = parser.getText();
                    } else if (text == 'MESSAGE_V2') {
                        MESSAGE_V2 = parser.getText();
                    } else if (text == 'MESSAGE_V3') {
                        MESSAGE_V3 = parser.getText();
                    } else if (text == 'MESSAGE_V4') {
                        MESSAGE_V4 = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2ApexCostomerCreate consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    
    public static JSON2ApexCostomerCreate parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new JSON2ApexCostomerCreate(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    



}