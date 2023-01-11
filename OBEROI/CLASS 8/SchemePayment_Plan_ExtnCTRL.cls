public class SchemePayment_Plan_ExtnCTRL{

    public String billingPlanId {get;set;}
    public List<BillingPaymentLI> billingPlanLineItems {get;set;}
    public Boolean isJodiPlan {get;set;}
    public Boolean isCoOwner {get;set;}
    public Boolean isSingle {get;set;}
    public Boolean isDiscount {get;set;}
    public Boolean isPercent {get;set;}
    public Boolean isTandem {get;set;}
    public Boolean isTriple {get;set;}
    public date dd= system.today();
    public String totalAmount {get;set;}
    public String netAmount {get;set;}
    public String totalAmountJodi {get;set;}
    public String isPercentJodi {get;set;}
    public String isDiscountJodi {get;set;}
    public String netAmountJodi {get;set;}
    public String isAmountDiscount {get;set;}
    public Date pdate { get { return Date.today(); }}
    public Payment_Plan__c jodiBillingPlan {get;set;}
    public Account actData {get;set;}
    public Payment_Plan__c billingPlan {get{
        billingPlan = [Select Additional_Information__c, Net_Sales_Amount_Scheme__c,Total_Sales_Amount_Scheme__c,Discount_Amount_On_PLC_Cost__c,Discount_Amount_On_Floor_Rise_Cost__c,RecordType.DeveloperName,Net_Sales_Amount__c,Discount_On_Basic_Cost__c,Discount_Amount_On_Basic_Cost__c,PLC_Cost_After_Discount_Formula__c,Floor_Rise_Cost_After_Discount_Formula__c,Basic_Cost_After_Discount_Formula__c,Scheme_Billing_Plan__c,Opportunity__r.Account.Company__c,Opportunity__r.Account.Occupation__c,Opportunity__r.Account.City__c,Opportunity__r.Account.Nationality__c,Opportunity__r.Account.Locality__c,Opportunity__r.Account.Country_Picklist__c,Opportunity__r.Account.Street_3__c,Opportunity__r.Account.Street_2__c,Opportunity__r.Account.House_No__c,Opportunity__r.Account.Street__c,Opportunity__r.Account.PersonLeadSource,Opportunity__r.Account.Company__pc,Opportunity__r.Account.Designation__pc,Opportunity__r.Account.Salutation,Opportunity__r.Account.Occupation__pc,Opportunity__r.Account.Contact_category__pc,Opportunity__r.Account.BillingCity,Opportunity__r.Account.BillingStreet,Opportunity__r.Enquiry_Type__c,Total_Cost__c,Total_Sales_Amount__c,Related_Jodi_Billing_Plan__c,Total_Sales_Amount_Time_of_Booking__c,Property__r.Triple_Parking__c,Property__r.Tandem_Parking__c,Property__r.Single_Parking__c,Property__r.Material_No__c,Basic_Cost__c,Tower__r.Project_Name__r.Name,Tower__r.Tower_Name__c,Valid_Until__c, Name, Property__c, Property__r.House_Unit_No__c, Opportunity__c,Opportunity__r.Account.Name, Opportunity__r.Primary_Contact__c, Opportunity__r.Primary_Contact__r.Name,Opportunity__r.Primary_Contact__r.MailingStreet,Opportunity__r.Primary_Contact__r.MailingCity, Opportunity__r.Primary_Contact__r.Occupation__c,Opportunity__r.Primary_Contact__r.Designation__c,Opportunity__r.Primary_Contact__r.Company__c,Opportunity__r.Primary_Contact__r.Contact_category__c,Opportunity__r.Primary_Contact__r.LeadSource,(Select Amount__c, Line_Item_Amount__c,Due_After_Days__c,Percentage_Of_Value_To_Be_Invoiced__c, Terms_of_Payment_Key__c, Payment_Plan_Line_Item_Name__c, Payment_Group__c,Description__c, Milestone_Number__c,Line_Item_Amount_Scheme__c From Billing_Plan_Line_Items__r Order By /*Milestone_Number__c,*/Order__c) From Payment_Plan__c where Id =: billingPlanId]; 
        //Payment_Plan__c propertyBillingPlan = [Select Name,(Select Amount__c, Due_After_Days__c,Percentage_Of_Value_To_Be_Invoiced__c, Terms_of_Payment_Key__c, Payment_Plan_Line_Item_Name__c, Payment_Group__c, Milestone_Number__c From Billing_Plan_Line_Items__r Order By Order__c) From Payment_Plan__c where Tower__c =: billingPlan.Tower__c AND /*Property__c =: billingPlan.Property__c AND*/ Active__c = true AND Status__c = 'Approved' AND RecordType.DeveloperName = 'Default_Billing_Plan'];
        Co_Owner__c[] Cowner = [select id,Person_Account__c from Co_Owner__c where Opportunity__c =: billingPlan.Opportunity__c Limit 1];
            
            if(Cowner.size() > 0){
                actData = [select Nationality__c,Country_Picklist__c,Locality__c,Salutation,Name,House_No__c,Street_2__c,Street_3__c,Street__c,City__c,Contact_category__pc,Occupation__c,Designation__pc,
                Company__c from Account where Id =: Cowner[0].Person_Account__c];
                isCoOwner = true;
            }
            
        //}
        system.debug('actDataactDataactData'+actData);
        system.debug('isCoOwnerisCoOwnerisCoOwner'+isCoOwner);
        //
        isDiscount = false;
        isPercent = false;
        
        List<String> args = new String[]{'0','number','###,###,###'};
        Decimal netamt = billingPlan.Net_Sales_Amount_Scheme__c.setScale(0, RoundingMode.HALF_UP);
        netAmount = String.format(netamt.format(), args);
        
        if(billingPlan.Discount_On_Basic_Cost__c > 0){
            
            isDiscount = true;
            isPercent = true;
            Decimal tAmount = 0;
            //tAmount = billingPlan.Basic_Cost_After_Discount_Formula__c + billingPlan.Floor_Rise_Cost_After_Discount_Formula__c + billingPlan.PLC_Cost_After_Discount_Formula__c;
            tAmount = billingPlan.Total_Sales_Amount_Scheme__c;
            Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
            totalAmount = String.format(rounded.format(), args);
        }
        if(billingPlan.Discount_Amount_On_Basic_Cost__c > 0 ||
            billingPlan.Discount_Amount_On_Floor_Rise_Cost__c > 0 ||
            billingPlan.Discount_Amount_On_PLC_Cost__c > 0){
            isDiscount = true;
            isAmountDiscount = '0';
            Decimal tAmount = 0;
            Decimal bsp = 0;
            bsp= billingPlan.Discount_Amount_On_Basic_Cost__c>0?billingPlan.Discount_Amount_On_Basic_Cost__c:0.00;
            Decimal flc = 0;
            flc= billingPlan.Discount_Amount_On_Floor_Rise_Cost__c>0?billingPlan.Discount_Amount_On_Floor_Rise_Cost__c:0.00;
            Decimal plc = 0;
            plc= billingPlan.Discount_Amount_On_PLC_Cost__c>0?billingPlan.Discount_Amount_On_PLC_Cost__c:0.00;
            Decimal tamt = bsp + flc + plc;
            isAmountDiscount = String.ValueOf(tamt);
            tAmount = billingPlan.Total_Sales_Amount_Scheme__c;
            Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
            totalAmount = String.format(rounded.format(), args);
        }
        if(billingPlan.Related_Jodi_Billing_Plan__c != null){
            jodiBillingPlan = [Select Additional_Information__c, Net_Sales_Amount_Scheme__c,Total_Sales_Amount_Scheme__c,Total_Sales_Amount__c ,Discount_Amount_On_PLC_Cost__c,Discount_Amount_On_Floor_Rise_Cost__c,Net_Sales_Amount__c,Discount_Amount_On_Basic_Cost__c,PLC_Cost_After_Discount_Formula__c,Floor_Rise_Cost_After_Discount_Formula__c,Basic_Cost_After_Discount_Formula__c,Discount_On_Basic_Cost__c,Total_Cost__c,Property__r.Material_No__c,Property__r.House_Unit_No__c, Name,(Select Line_Item_Amount__c,Description__c,Amount__c, Due_After_Days__c,Percentage_Of_Value_To_Be_Invoiced__c, Terms_of_Payment_Key__c, Payment_Plan_Line_Item_Name__c, Payment_Group__c, Milestone_Number__c,Line_Item_Amount_Scheme__c From Billing_Plan_Line_Items__r Order By Milestone_Number__c,Order__c) From Payment_Plan__c where Id =: billingPlan.Related_Jodi_Billing_Plan__c];
            
            //List<String> args = new String[]{'0','number','###,###,###'};
            isPercentJodi = '0';
            isDiscountJodi = '0';
            Decimal netamtJodi = jodiBillingPlan.Net_Sales_Amount_Scheme__c.setScale(0, RoundingMode.HALF_UP);
            netAmountJodi = String.format(netamtJodi.format(), args);
            if(jodiBillingPlan.Discount_On_Basic_Cost__c > 0){
            
            isPercentJodi = String.ValueOf(jodiBillingPlan.Discount_On_Basic_Cost__c);
            Decimal tAmount = 0;
            tAmount = jodiBillingPlan.Total_Sales_Amount_Scheme__c;
            //tAmount = jodiBillingPlan.Basic_Cost_After_Discount_Formula__c + jodiBillingPlan.Floor_Rise_Cost_After_Discount_Formula__c + jodiBillingPlan.PLC_Cost_After_Discount_Formula__c;
            Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
            totalAmountJodi = String.format(rounded.format(), args);
            }
            if(jodiBillingPlan.Discount_Amount_On_Basic_Cost__c > 0 ||
            jodiBillingPlan.Discount_Amount_On_Floor_Rise_Cost__c > 0 ||
            jodiBillingPlan.Discount_Amount_On_PLC_Cost__c > 0){
                
                Decimal bsp = 0;
                bsp= jodiBillingPlan.Discount_Amount_On_Basic_Cost__c>0?jodiBillingPlan.Discount_Amount_On_Basic_Cost__c:0.00;
                Decimal flc = 0;
                flc= jodiBillingPlan.Discount_Amount_On_Floor_Rise_Cost__c>0?jodiBillingPlan.Discount_Amount_On_Floor_Rise_Cost__c:0.00;
                Decimal plc = 0;
                plc= jodiBillingPlan.Discount_Amount_On_PLC_Cost__c>0?jodiBillingPlan.Discount_Amount_On_PLC_Cost__c:0.00;
            
                Decimal tamt = bsp + flc + plc;//jodiBillingPlan.Discount_Amount_On_Basic_Cost__c>0?jodiBillingPlan.Discount_Amount_On_Basic_Cost__c:0 + jodiBillingPlan.Discount_Amount_On_Floor_Rise_Cost__c>0?jodiBillingPlan.Discount_Amount_On_Floor_Rise_Cost__c:0 + jodiBillingPlan.Discount_Amount_On_PLC_Cost__c>0?jodiBillingPlan.Discount_Amount_On_PLC_Cost__c:0;
                isDiscountJodi = String.ValueOf(tamt);
                //isDiscountJodi = String.ValueOf(jodiBillingPlan.Discount_Amount_On_Basic_Cost__c);
                Decimal tAmount = 0;
                tAmount = jodiBillingPlan.Total_Sales_Amount_Scheme__c;
                //tAmount = jodiBillingPlan.Basic_Cost_After_Discount_Formula__c + jodiBillingPlan.Floor_Rise_Cost_After_Discount_Formula__c + jodiBillingPlan.PLC_Cost_After_Discount_Formula__c;
                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                totalAmountJodi = String.format(rounded.format(), args);
            }
        }
        Payment_Plan__c ptSchemeBillingPlan = new Payment_Plan__c();
        //Code for Scheme Billing Plan Start
        if(billingPlan.Scheme_Billing_Plan__c != null && billingPlan.RecordType.DeveloperName == 'Scheme_Billing_Plan'){
            ptSchemeBillingPlan = [Select Name,(Select Description__c,Amount__c, Due_After_Days__c,Percentage_Of_Value_To_Be_Invoiced__c, Terms_of_Payment_Key__c, Payment_Plan_Line_Item_Name__c, Payment_Group__c, Milestone_Number__c From Billing_Plan_Line_Items__r Order By Order__c) 
            from Payment_Plan__c where Tower__c =: billingPlan.Tower__c 
            AND Id =: billingPlan.Scheme_Billing_Plan__c
            AND Active__c = true AND Status__c = 'Approved' AND 
            RecordType.DeveloperName = 'Scheme_Billing_Plan_w_t_Tower'];
            system.debug('ptSchemeBillingPlanptSchemeBillingPlan'+ptSchemeBillingPlan);
        }
        
        //Code for Scheme Billing Plan End
        isSingle = false;
        isTandem = false;
        isTriple = false;
        if(billingPlan.Property__r.Triple_Parking__c != null && billingPlan.Property__r.Triple_Parking__c > 0){ isTriple = true;}
        if(billingPlan.Property__r.Tandem_Parking__c != null && billingPlan.Property__r.Tandem_Parking__c > 0){ isTandem = true;}
        if(billingPlan.Property__r.Single_Parking__c != null && billingPlan.Property__r.Single_Parking__c > 0){ isSingle = true;}
        Map<String, BillingPaymentLI> displayItemMap = new Map<String, BillingPaymentLI>();
        isJodiPlan = false;
        //system.debug('billingPlanbillingPlan');
        /*if(billingPlan.RecordType.DeveloperName == 'Customize_Billing_Plan'){
            for(Billing_Plan_Line_Item__c billingPlanLIObj : ptSchemeBillingPlan.Billing_Plan_Line_Items__r){
                BillingPaymentLI obj = new BillingPaymentLI();
                obj.baseLineItem = billingPlanLIObj;
                obj.customLineItem = new List<Billing_Plan_Line_Item__c>();
                obj.customJodiLineItem = new List<Billing_Plan_Line_Item__c>();
                displayItemMap.put(billingPlanLIObj.Milestone_Number__c + billingPlanLIObj.Payment_Group__c, obj);
            }
            //system.debug('AAAAAAAAAAAAAAAAAAA'+displayItemMap.size());
        }*/
        if(billingPlan.RecordType.DeveloperName == 'Scheme_Billing_Plan'){
            for(Billing_Plan_Line_Item__c billingPlanLIObj : ptSchemeBillingPlan.Billing_Plan_Line_Items__r){
                BillingPaymentLI obj = new BillingPaymentLI();
                obj.baseLineItem = billingPlanLIObj;
                obj.customLineItem = new List<Billing_Plan_Line_Item__c>();
                obj.customJodiLineItem = new List<Billing_Plan_Line_Item__c>();
                displayItemMap.put(billingPlanLIObj.Milestone_Number__c + billingPlanLIObj.Payment_Group__c, obj);
            }
        }
        system.debug('billingPlanbillingPlan');
        for(Billing_Plan_Line_Item__c billingPlanLIObj : billingPlan.Billing_Plan_Line_Items__r){
            BillingPaymentLI obj = displayItemMap.get(billingPlanLIObj.Milestone_Number__c + billingPlanLIObj.Payment_Group__c);
            if(obj != null){
                obj.customLineItem.add(billingPlanLIObj);
            }
        }
        if(jodiBillingPlan != null && jodiBillingPlan.Billing_Plan_Line_Items__r != null && jodiBillingPlan.Billing_Plan_Line_Items__r.size() > 0){
            for(Billing_Plan_Line_Item__c billingPlanLIObj : jodiBillingPlan.Billing_Plan_Line_Items__r){
                BillingPaymentLI obj = displayItemMap.get(billingPlanLIObj.Milestone_Number__c + billingPlanLIObj.Payment_Group__c);
                if(obj != null){
                    obj.customJodiLineItem.add(billingPlanLIObj);
                    isJodiPlan = true;
                }
            }
        }
        billingPlanLineItems = displayItemMap.values();
        return billingPlan ;
    }
    set;}
    
    public class BillingPaymentLI{
        public Billing_Plan_Line_Item__c baseLineItem {get;set;}
        public List<Billing_Plan_Line_Item__c> customLineItem {get;set;}
        public List<Billing_Plan_Line_Item__c> customJodiLineItem {get;set;}
    }
    
    public SchemePayment_Plan_ExtnCTRL(){    
    }
    
}