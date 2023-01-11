public class JSON2ApexCustomerBillingPlan {

    public String SO_NUMBER;
    public String RESULT;
    public String MESSAGE;
    public List<BPLAN> BPLAN;

    public class BPLAN {
        public String FPLNR;
        public Integer FPLTR;
        public String BILLING_DATE;
        public String DATE_DESCRIPTION;
        public String USAGE_MILESTONE;
        public String BILLING_RULE;
        public String BILLING_BLOCK;
        public String PERCENTAGE;
        public String BILLING_VALUE;
        public String MLSTN;
        public String DATE_CATEGORY;
        public String ZTERM;
    }

    
    public static JSON2ApexCustomerBillingPlan parse(String json) {
        return (JSON2ApexCustomerBillingPlan) System.JSON.deserialize(json, JSON2ApexCustomerBillingPlan.class);
    }
}