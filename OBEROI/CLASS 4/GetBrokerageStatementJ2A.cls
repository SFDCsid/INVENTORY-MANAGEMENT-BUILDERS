public class GetBrokerageStatementJ2A {

    public String EP_XSTRING;
    public String ERROR_MESSAGE;
    public String EP_BROKERAGE1;
    public String EP_SERV_TAX;
    public String amount_due_incl_taxes;
    public String amount_recieved_incl_taxes;

    public static GetBrokerageStatementJ2A parse(String json) {
        return (GetBrokerageStatementJ2A) System.JSON.deserialize(json, GetBrokerageStatementJ2A.class);
    }
}