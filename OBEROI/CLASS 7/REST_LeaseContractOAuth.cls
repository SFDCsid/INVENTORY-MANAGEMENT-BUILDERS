@RestResource(urlMapping='/SAP_Integration/FlowLeaseContract/*')
global class REST_LeaseContractOAuth{
    @HttpPOST
    global static REST_result LeaseContractUpdate(String CONTRACT_NO,String CONTRACT_INTRENO,String CONTRACT_TYPE,String DES_OF_RE_CONTRACT_TYPE,String MAIN_CONTRACT_NO,String COMPANY_CODE,
    String CONTRACT_NAME,String TENANCY_LAW_ID,String TENANCY_LAW_DES,String MASTER_TENANT_NO,String MASTER_TENANT_NAME,String BUSINESS_ENTITY_NO,String NO_OF_RENTAL_OBJ,String PROFIT_CENTRE,
    String CONTRACT_START,String CONTRACT_END,String END_OF_TERM,String CREATED_ON,String CHANGE_ON,List<Rental_Unit_List> RENTAL_UNITS,
    String SFOPPORTUNITY_ID, String AGREEMENTDATE,String LOCKINEXPIRYDATE, String NOTICEPERIODEEXPIRYDATE,String FITOUTACCESSDATE,List<Condition_Detail_List> CONDITION_DETAILS){
         
        REST_result r=new REST_result();
        List<Lease_Contract__c> Lcon = new List<Lease_Contract__c>();
        List<Leasing_Rental_Unit__c> lRUnit = new List<Leasing_Rental_Unit__c>();
        List<Leasing_Rental_Unit__c> lRUnitToUpdate = new List<Leasing_Rental_Unit__c>();
        List<Condition_Details__c> insertconList = new List<Condition_Details__c>();
        List<Condition_Details__c> conList = new List<Condition_Details__c>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Leasing_Project__c> lProj = new List<Leasing_Project__c>();
        if(String.isBlank(SFOPPORTUNITY_ID)   || String.isBlank(MASTER_TENANT_NO)){
            r.returnCode=1;
            r.message='SFOPPORTUNITY_ID OR MASTER_TENANT_NO is missing';
            return r;
        }else{
                if(String.isBlank(CONTRACT_NO) || String.isBlank(COMPANY_CODE)){//String.isBlank(INTRE_NO)||
                    r.returnCode=1;
                    r.message='CONTRACT_NO OR COMPANY_CODE is missing';
                    return r;
                }else{
                        if(RENTAL_UNITS.size()>0){
                        set<String> INTRE_No_set = new set<String>();
                        for(Rental_Unit_List ru : RENTAL_UNITS){
                            INTRE_No_set.add(ru.INTRE_NO);
                        }
                                Lcon = [select id,name,Contract_no__c,INTRENO__c,Agreement_Date__c from Lease_Contract__c where Contract_no__c =: CONTRACT_NO];
                                lRUnit = [select id, name,INTRENO__c,Company_Code__c from Leasing_Rental_Unit__c where INTRENO__c In: INTRE_No_set];
                                lProj = [select id, name,Company_Code__c from Leasing_Project__c where Company_Code__c =: COMPANY_CODE AND Business_Entity_Number__c =: BUSINESS_ENTITY_NO];
                                //oppList = [select id,name,Customer_Number__c from Opportunity where Customer_Number__c =: MASTER_TENANT_NO];
                                oppList = [select id,name,Customer_Number__c, Opportunity_Number__c  from Opportunity where 
                                        Opportunity_Number__c =: SFOPPORTUNITY_ID AND Customer_Number__c =: MASTER_TENANT_NO];
                                
                            if(oppList.Size()>0){
                                if(Lcon.Size()>0){
                                    System.debug('Leasing Contract Found');
                                    Lcon[0].Contract_no__c = CONTRACT_NO;
                                    Lcon[0].Contract_type__c = CONTRACT_TYPE;
                                    Lcon[0].Description_of_type_of_RE_contract_type__c = DES_OF_RE_CONTRACT_TYPE;
                                    Lcon[0].Main_contract_no__c = MAIN_CONTRACT_NO;
                                    Lcon[0].INTRENO__c = CONTRACT_INTRENO;
                                    Lcon[0].Company_Code__c = COMPANY_CODE;
                                    if(lProj.size()>0)
                                        Lcon[0].Leasing_Project__c = lProj[0].Id;
                                    
                                    Lcon[0].Opportunity__c = oppList[0].Id;           
                                    Lcon[0].Contract_Name__c = CONTRACT_NAME;
                                    Lcon[0].Tenancy_law_ID__c = TENANCY_LAW_ID;
                                    Lcon[0].Tenancy_law_Description__c = TENANCY_LAW_DES;
                                    Lcon[0].Master_Tenant_no__c = MASTER_TENANT_NO;
                                    Lcon[0].Master_Tenant_Name__c = MASTER_TENANT_NAME;
                                    Lcon[0].Business_Entity_Number__c = BUSINESS_ENTITY_NO;
                                    Lcon[0].Number_of_Rental_Object__c = NO_OF_RENTAL_OBJ;
                                    Lcon[0].Profit_Centre__c = PROFIT_CENTRE;
                                    if(CONTRACT_START != '0000-00-00')
                                    Lcon[0].Contract_Start__c = Date.valueof(CONTRACT_START);
                                    if(CONTRACT_END != '0000-00-00')
                                    Lcon[0].Contract_End_date__c = Date.valueof(CONTRACT_END);
                                    if(END_OF_TERM != '0000-00-00')
                                    Lcon[0].End_of_term__c = Date.valueof(END_OF_TERM);
                                    if(CREATED_ON != '0000-00-00')
                                    Lcon[0].Created_On__c = Date.valueof(CREATED_ON);
                                    if(CHANGE_ON != '0000-00-00')
                                    Lcon[0].Change_On__c = Date.valueof(CHANGE_ON);
                                    if(AGREEMENTDATE != '0000-00-00')
                                    Lcon[0].Agreement_Date__c = Date.valueof(AGREEMENTDATE);
                                    if(NOTICEPERIODEEXPIRYDATE != '0000-00-00')
                                    Lcon[0].Notice_period_expiry_date__c  = Date.valueof(NOTICEPERIODEEXPIRYDATE);
                                    if(LOCKINEXPIRYDATE != '0000-00-00')
                                    Lcon[0].Lock_In_Expiry_Date__c   = Date.valueof(LOCKINEXPIRYDATE);
                                    if(FITOUTACCESSDATE != '0000-00-00')
                                    Lcon[0].Fitout_Date_Access_Date__c  = Date.valueof(FITOUTACCESSDATE);
                                    
                                    Update Lcon;
                                    
                                    for(Leasing_Rental_Unit__c rul : lRUnit){
                                    rul.Lease_Contract__c = Lcon[0].id;
                                    lRUnitToUpdate.add(rul);
                                    }
                                    
                                    Update lRUnitToUpdate;
                                    
                                    if(CONDITION_DETAILS.Size()>0){
                                        for(Condition_Detail_List conL : CONDITION_DETAILS){
                                            conList = [select id,name,Condition_Type__c,Lease_Contract__c,Condition_Type_Description__c,Measurement_Description__c,Measurement_ID__c from Condition_Details__c where Lease_Contract__c =: Lcon[0].Id AND Condition_Type__c =: conL.CONDITION_TYPE];
                                            if(conList.size()>0){
                                                delete conList;
                                            }
                                            Condition_Details__c con = new Condition_Details__c();
                                            con.Condition_Type__c = conL.CONDITION_TYPE;
                                            con.Condition_Type_Description__c = conL.CONDITION_TYPE_DES;
                                            con.Measurement_Description__c = conL.MEASUREMENT_DESCRIPTION;
                                            con.Measurement_ID__c = conL.MEASUREMENT_ID;
                                            con.Unit_Price__c = conL.UNIT_PRICE;
                                            if(conL.VALIDFROM != '0000-00-00'){
                                                    con.Valid_From__c = Date.valueof(conL.VALIDFROM);
                                            }
                                            if(conL.VALIDTO != '0000-00-00'){
                                                    con.Valid_To__c = Date.valueof(conL.VALIDTO);
                                            }
                                            con.Lease_Contract__c = Lcon[0].Id;
                                            insertconList.add(con);
                                        }
                                        insert insertconList;
                                    }
                                
                                    r.returnCode=0;
                                    r.message='Leasing Contract '+CONTRACT_NO+' is updated successfully!';
                                    r.CONTRACT_NO= ''+CONTRACT_NO;
                                
                                }else{
                                    
                                    System.debug('Leasing Contract Found');
                                    Lease_Contract__c LCont = new Lease_Contract__c();
                                    LCont.Contract_no__c = CONTRACT_NO;
                                    LCont.Contract_type__c = CONTRACT_TYPE;
                                    LCont.Description_of_type_of_RE_contract_type__c = DES_OF_RE_CONTRACT_TYPE;
                                    LCont.Main_contract_no__c = MAIN_CONTRACT_NO;
                                    LCont.Company_Code__c = COMPANY_CODE;
                                    LCont.INTRENO__c = CONTRACT_INTRENO;
                                    LCont.Opportunity__c = oppList[0].Id;
                                    if(lProj.size()>0)
                                        LCont.Leasing_Project__c = lProj[0].Id;
                                    
                                    LCont.Contract_Name__c = CONTRACT_NAME;
                                    LCont.Tenancy_law_ID__c = TENANCY_LAW_ID;
                                    LCont.Tenancy_law_Description__c = TENANCY_LAW_DES;
                                    LCont.Master_Tenant_no__c = MASTER_TENANT_NO;
                                    LCont.Master_Tenant_Name__c = MASTER_TENANT_NAME;
                                    LCont.Business_Entity_Number__c = BUSINESS_ENTITY_NO;
                                    LCont.Number_of_Rental_Object__c = NO_OF_RENTAL_OBJ;
                                    LCont.Profit_Centre__c = PROFIT_CENTRE;
                                    if(CONTRACT_START != '0000-00-00')
                                    LCont.Contract_Start__c = Date.valueof(CONTRACT_START);
                                    if(CONTRACT_END != '0000-00-00')
                                    LCont.Contract_End_date__c = Date.valueof(CONTRACT_END);
                                    if(END_OF_TERM != '0000-00-00')
                                    LCont.End_of_term__c = Date.valueof(END_OF_TERM);
                                    if(CREATED_ON != '0000-00-00')
                                    LCont.Created_On__c = Date.valueof(CREATED_ON);
                                    if(CHANGE_ON != '0000-00-00')
                                    LCont.Change_On__c = Date.valueof(CHANGE_ON);
                                    if(AGREEMENTDATE != '0000-00-00')
                                    LCont.Agreement_Date__c = Date.valueof(AGREEMENTDATE);
                                    if(NOTICEPERIODEEXPIRYDATE != '0000-00-00')
                                    LCont.Notice_period_expiry_date__c  = Date.valueof(NOTICEPERIODEEXPIRYDATE);
                                    if(LOCKINEXPIRYDATE != '0000-00-00')
                                    LCont.Lock_In_Expiry_Date__c   = Date.valueof(LOCKINEXPIRYDATE);
                                    if(FITOUTACCESSDATE != '0000-00-00')
                                    LCont.Fitout_Date_Access_Date__c  = Date.valueof(FITOUTACCESSDATE);
                                
                                    insert LCont;
                                    
                                    for(Leasing_Rental_Unit__c rul : lRUnit){
                                    rul.Lease_Contract__c = LCont.id;
                                    lRUnitToUpdate.add(rul);
                                    }
                                    
                                    Update lRUnitToUpdate;
                                    
                                    if(CONDITION_DETAILS.Size()>0){
                                        for(Condition_Detail_List conL : CONDITION_DETAILS){
                                            Condition_Details__c con = new Condition_Details__c();
                                            con.Condition_Type__c = conL.CONDITION_TYPE;
                                            con.Condition_Type_Description__c = conL.CONDITION_TYPE_DES;
                                            con.Measurement_Description__c = conL.MEASUREMENT_DESCRIPTION;
                                            con.Measurement_ID__c = conL.MEASUREMENT_ID;
                                            con.Unit_Price__c = conL.UNIT_PRICE;
                                            if(conL.VALIDFROM != '0000-00-00'){
                                                    con.Valid_From__c = Date.valueof(conL.VALIDFROM);
                                            }
                                            if(conL.VALIDTO != '0000-00-00'){
                                                    con.Valid_To__c = Date.valueof(conL.VALIDTO);
                                            }
                                            con.Lease_Contract__c = LCont.Id;
                                            insertconList.add(con);
                                        }
                                        insert insertconList;
                                    }
                                    
                                    r.returnCode=0;
                                    r.message='Leasing Contract '+CONTRACT_NO+' is created successfully!';
                                    r.CONTRACT_NO = ''+CONTRACT_NO;
                                }
                     }else{
                        r.returnCode=3;
                        r.message='Customer not found';
                        }
                }else{
                    r.returnCode=3;
                    r.message='Rental units are missing in request';
                    }
           }
        }
        return r;
    }
    
    global class REST_result {
        webservice Integer returnCode;
        webservice String message;
        webservice String CONTRACT_NO;
    } 
    global class Rental_Unit_List{
         Public String INTRE_NO;   
    } 
    global class Condition_Detail_List{
        Public String CONDITION_TYPE;
        Public String CONDITION_TYPE_DES;
        Public Decimal UNIT_PRICE;
        Public String VALIDTO;
        Public String VALIDFROM; 
        Public String MEASUREMENT_DESCRIPTION;
        Public String MEASUREMENT_ID;
    }
    
}