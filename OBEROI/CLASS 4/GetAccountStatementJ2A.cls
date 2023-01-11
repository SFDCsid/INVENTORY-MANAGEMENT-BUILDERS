public class GetAccountStatementJ2A {

    public String EP_XSTRING;
    public String ERROR_MESSAGE;

    public static GetAccountStatementJ2A parse(String json) {
        return (GetAccountStatementJ2A) System.JSON.deserialize(json, GetAccountStatementJ2A.class);
    }
}