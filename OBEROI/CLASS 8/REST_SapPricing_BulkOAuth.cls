@RestResource(urlMapping='/SAP_Integration/FlowSapPricing_BULK/*')
global class REST_SapPricing_BulkOAuth{
    @HttpPOST
     global static REST_result FlowSapPricing_Bulk(List<PricingWrapper> PricingList){
        REST_result r=new REST_result();
        List<SAP_Pricing__c > SAP_PricingToUpdate = new List<SAP_Pricing__c >();
        List<SAP_Pricing__c > SAP_PricingToInsert = new List<SAP_Pricing__c >();
        List<Property__c> u= new List<Property__c>();
        List<SAP_Pricing__c > sp= new List<SAP_Pricing__c >();

        for(PricingWrapper t: PricingList) {
            if(String.isBlank(t.Material_code)||String.isBlank(t.SR_NO)||String.isBlank(t.CONDITION_TYPE)){   
                Responce re = new Responce();
                re.returnCode =1;
                re.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED';
                r.ResponceList.add(re);
            }Else{
                u = [SELECT ID,Material_No__c FROM Property__c WHERE Material_No__c = : t.Material_code];//materialcode
                if(u.isEmpty()){
                    Responce re = new Responce();
                    re.returnCode=3;
                    re.message='The particular Unit is not available';
                    r.ResponceList.add(re);
                }Else{
                    SP= [SELECT ID,Name, Condition_Type__c FROM SAP_Pricing__c WHERE Condition_Type__c =: t.CONDITION_TYPE AND Property__c =: u[0].id];
                    if(SP.size()>0){//unit name diffrentitation (Uniqueness)
                        System.debug('SAP Prising Found');
                        //sp[0].Property__c = u[0].id;
                        sp[0].Sequence_Number__c = Decimal.valueOf(t.SR_NO);
                        sp[0].Condition_Type__c = t.CONDITION_TYPE;
                        sp[0].Condition_Description__c = t.Condition_description;
                        sp[0].Rate__c = t.RATE;
                        sp[0].Value__c = t.Value;
                        sp[0].Charge_Based_On__c = t.Charge_Based_On;
                        
                        SAP_PricingToUpdate.add(sp[0]);
                        
                        Responce re = new Responce();
                        re.returnCode=0;
                        
                        re.Material_code = t.Material_code;
                        re.CONDITION_TYPE = t.CONDITION_TYPE;
                        re.message='SAP Pricing is updated successfully!';
                        //re.SFDF_Pricing_ID= 'SAP Pricing ID is ' +sp[0].Id;
                        r.ResponceList.add(re);
                    }
                    else{
                        SAP_Pricing__c Obj=new SAP_Pricing__c();
                        Obj.Property__c = u[0].id;
                        Obj.Sequence_Number__c = Decimal.valueOf(t.SR_NO);
                        Obj.Condition_Type__c = t.CONDITION_TYPE;
                        Obj.Condition_Description__c = t.Condition_description;
                        Obj.Rate__c = t.RATE;
                        Obj.Value__c = t.Value;
                        Obj.Charge_Based_On__c = t.Charge_Based_On;
                        SAP_PricingToInsert.add(Obj);
                        
                        Responce re = new Responce();
                        re.returnCode=0;
                        
                        re.Material_code = t.Material_code;
                        re.CONDITION_TYPE = t.CONDITION_TYPE;
                        re.message='SAP Pricing is created successfully!';
                        r.ResponceList.add(re);
                    }    
                }
            } 
       }
        Update SAP_PricingToUpdate;
        Insert SAP_PricingToInsert;
        return r;
    }
    global class REST_result {
        webservice List<Responce> ResponceList;
        global Rest_result(){
            ResponceList = new List<Responce>();
        }
     } 
    global class Responce{
        webservice Integer returnCode;
        webservice String Material_code;
        webservice String CONDITION_TYPE;
        webservice String message;
    } 
    
    global class PricingWrapper{
        Public String Material_code;
        Public String SR_NO; 
        Public String CONDITION_TYPE;
        Public String Condition_description;
        Public Decimal RATE;
        Public Decimal Value; 
        Public String Charge_Based_On;

     }   
}