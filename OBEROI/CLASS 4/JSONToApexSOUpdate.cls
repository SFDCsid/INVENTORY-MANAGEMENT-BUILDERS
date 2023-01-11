public class JSONToApexSOUpdate  {

    public class ORDER_ITEMS {
        public Integer POSNR;
        public String MATNR;
        public Double ZMENG;
        public String ZIEME;
        public Integer KWMENG;
    }

    public class ORDER_CONDITIONS {
        public Integer ITEM_NUMBER;
        public String COND_TYPE;
        public Double COND_RATE;
        public Double COND_VALUE;
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
    public String BROKER_PERCENT;
    public String ORDER_REASON;
    public String NOC_BANK_NAME;
    public String SFDC_ID;
    public String MARKET_VALUE;
    public string STAMP_DUTY;
    public String NOC_DATE;
    public String MNOC_DATE;
    public String ALLOTMENT_DATE;
    public String AGREEMENT_DATE;
    public String REG_DATE;
    public String REG_SR_NO;
    public String REG_CHARGES;
    public String LOAN_AMOUNT;
    public String LOAN_ROI;
    public String LOAN_TENURE;
    public String PARALLEL_FUNDING;
    public String PARALLEL_FUNDINGP;
    public String LL_NOC_DATE;
    public String LL_NOC_PERIOD;
    public string PER_MONTH_RENT;
    public string SECURITY_DEPOSIT;
    public String FLAT_STATUS;
    public String POSS_CHECKLIST_DATE;
    public String POSS_DATE;
    public String POSS_DONE;
    public String CURRENT_SCHEME;
    public String SCHEME_CHANGE_DATE;
    public String CHANGE_OF_SCHEME;
    public String ROFR_NOTICE_DATE;
    public String ROFR_NOTICE_RA_DATE;
    public String ROFR_TNOC_DATE;
    public String ROFR_RESALE_CONSIDERATION;
    public String ROFR_SALE_CONSIDERATION;
    public Double NET_VALUE;
    public Double TAX;
    public Double SALE_VALUE;
    public List<ORDER_ITEMS> ORDER_ITEMS;
    public List<ORDER_CONDITIONS> ORDER_CONDITIONS;
    public List<BILLING_PLAN> BILLING_PLAN;
    public String MESSAGE;
    public String MESSAGE_TYPE;

    public class BILLING_PLAN {
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
        public String FKSAF;
    }


    
    public static JSONToApexSOUpdate  parse(String json) {
        return (JSONToApexSOUpdate) System.JSON.deserialize(json, JSONToApexSOUpdate.class);
    }
}