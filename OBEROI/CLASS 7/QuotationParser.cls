public class QuotationParser{

    public String label;
    public String value;

    
    public static List<QuotationParser> parse(String json) {
        return (List<QuotationParser>) System.JSON.deserialize(json, List<QuotationParser>.class);
    }
}