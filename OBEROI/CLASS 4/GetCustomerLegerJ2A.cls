public class GetCustomerLegerJ2A {

    public String EP_XSTRING;
    public String ERROR_MESSAGE;

    public static GetCustomerLegerJ2A parse(String json) {
        return (GetCustomerLegerJ2A) System.JSON.deserialize(json, GetCustomerLegerJ2A.class);
    }
}