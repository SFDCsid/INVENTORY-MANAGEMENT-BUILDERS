public class JSONToApexSOCreate {

    public class ORDER_ITEMS {
        public Integer POSNR;
        public String MATNR;
        public Double ZMENG;
        public String ZIEME;
        public Integer KWMENG;
    }

    public class ORDER_CONDITIONS {
    }

    public String SO_NUMBER;
    public String DOC_TYPE;
    public String VKORG;
    public String VTWEG;
    public String SPART;
    public String VKBUR;
    public String VKGRP;
    public String CUST_REF_NO;
    public String CUST_REF_DATE;
    public String PROJECT_ID;
    public String TOWER;
    public String KUNNR;
    public String LIFNR;
    public Double BROKER_PERCENT;
    public String ORDER_REASON;
    public String NOC_BANK_NAME;
    public string MARKET_VALUE;
    public string STAMP_DUTY;
    public String NOC_DATE;
    public String REG_DATE;
    public String MNOC_DATE;
    public String ALLOTMENT_DATE;
    public String AGREEMENT_DATE;
    public String REG_SR_NO;
    public string LOAN_AMOUNT;
    public string LOAN_ROI;
    public String LOAN_TENURE;
    public String LL_NOC_DATE;
    public String LL_NOC_PERIOD;
    public String FLAT_STATUS;
    public String POSS_DATE;
    public String SCHEME_CHANGE_DATE;
    public String PER_MONTH_RENT;
    public String SECURITY_DEPOSIT;
    public String SFDC_ID;
    public Double NET_VALUE;
    public Double TAX;
    public Double SALE_VALUE;
    public List<ORDER_ITEMS> ORDER_ITEMS;
    public List<ORDER_CONDITIONS> ORDER_CONDITIONS;
    public List<ORDER_CONDITIONS> BILLING_PLAN;
    public String MESSAGE;
    public String MESSAGE_TYPE;
    

    
    public static JSONToApexSOCreate parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return (JSONToApexSOCreate) System.JSON.deserialize(json,JSONToApexSOCreate.class);
    }
}