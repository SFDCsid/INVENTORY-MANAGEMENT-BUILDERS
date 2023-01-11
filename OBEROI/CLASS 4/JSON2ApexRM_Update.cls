public class JSON2ApexRM_Update {

    public String ZSORTL {get;set;} 
    public String MESSAGE {get;set;} 
    public String ZRM_NAME {get;set;}
    public String SMTP_ADDR {get;set;}
    public String ZRM_MOB {get;set;}
    
    public JSON2ApexRM_Update(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'ZSORTL') {
                        ZSORTL = parser.getText();
                    } else if (text == 'ZRM_NAME') {
                        ZRM_NAME = parser.getText();
                    } else if (text == 'SMTP_ADDR') {
                        SMTP_ADDR = parser.getText();
                    } else if (text == 'ZRM_MOB') {
                        ZRM_MOB = parser.getText();
                    } else if (text == 'MESSAGE') {
                        MESSAGE = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2ApexRM_Update consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    
    public static JSON2ApexRM_Update parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new JSON2ApexRM_Update(parser);
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