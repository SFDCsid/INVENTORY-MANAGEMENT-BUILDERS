public class JSONParserController {
    public class trackIDParser {
        
        public String results;
        public List<trackIDParser_Field_data> field_data;
  }

  public class trackIDParser_Field_data {
    //public String address_components;
    public string formatted_address;
    public List<String> values;
  }
  
  public static JSONParserController parse(String json) {
    return (JSONParserController) System.JSON.deserialize(json, JSONParserController.class);
    }
}