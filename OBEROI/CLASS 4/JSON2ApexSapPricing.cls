public class JSON2ApexSapPricing {

    public String KUNNR;
    public String VKORG;
    public String VTWEG;
    public String KSCHL;
    public String MATNR;
    public Double DMBTR;
    public Double SCMNG;
    public String SCHME;
    public String RESULT;
    public String MESSAGE;

    
    public static JSON2ApexSapPricing parse(String json) {
        return (JSON2ApexSapPricing) System.JSON.deserialize(json, JSON2ApexSapPricing.class);
    }
}