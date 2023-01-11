@RestResource(urlMapping='/SAP_Integration/FlowRentalUnit/*')
global class REST_RentalUnitOAuth{
    @HttpPOST
    global static REST_result RentalUnitUpdate(String INTRE_NO,String COMPANY_CODE,String BUS_ENTITY_NO,String NO_OF_RENTAL_OBJ,String RENTAL_OBJ_TYPE_ID,String RENTAL_OBJ_TYPE_DES,String USAGE_TYPE_ID,
    String USAGE_TYPE_DES,String RENTAL_OBJ_NAME,String LAND,String BUILDING,String CASH_FLOW_FROM,String OBJ_VALID_FROM,List<MeasurementList> MEASUREMENTL){
        
        REST_result r=new REST_result();
        List<Leasing_Rental_Unit__c> lRUnit = new List<Leasing_Rental_Unit__c>();
        List<Leasing_Project__c> lProj = new List<Leasing_Project__c>();
        List<Measurement__c> measList = new List<Measurement__c>();
        List<Measurement__c> updateMList = new List<Measurement__c>();
        List<Measurement__c> insertMList = new List<Measurement__c>();
        if(String.isBlank(INTRE_NO)||String.isBlank(COMPANY_CODE)){
            r.returnCode=1;
            r.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED';
            return r;
        }
        lRUnit = [select id, Name,INTRENO__c,Company_Code__c from Leasing_Rental_Unit__c where INTRENO__c =: INTRE_NO];
        lProj = [select id, name,Company_Code__c from Leasing_Project__c where Company_Code__c =: Company_Code AND Business_Entity_Number__c =: BUS_ENTITY_NO];
        
        if(lRUnit.size()>0){
            System.debug('Leasing Unit Found');
            lRUnit[0].Name = RENTAL_OBJ_NAME;
            lRUnit[0].INTRENO__c = INTRE_NO;
            lRUnit[0].Company_Code__c = COMPANY_CODE;
            lRUnit[0].Business_Entity_Number__c = BUS_ENTITY_NO;
            lRUnit[0].Number_of_Rental_Object__c = NO_OF_RENTAL_OBJ;
            lRUnit[0].Rental_Object_Type_ID__c = RENTAL_OBJ_TYPE_ID;
            lRUnit[0].Rental_Object_Type_Description__c = RENTAL_OBJ_TYPE_DES;
            lRUnit[0].Usage_Type_ID__c = USAGE_TYPE_ID;
            lRUnit[0].Usage_Type_Description__c = USAGE_TYPE_DES;
            lRUnit[0].Rental_Object_Name__c = RENTAL_OBJ_NAME;
            lRUnit[0].Land__c = LAND;
            lRUnit[0].Building_Name__c = BUILDING;
            if(lProj.size()>0){
            lRUnit[0].Building__c = lProj[0].Id;
            }else{
                r.returnCode=2;
                r.message='Project does not match';
                return r;
            }
            if(CASH_FLOW_FROM != '0000-00-00'){
                lRUnit[0].Cash_Flow_From__c = Date.valueof(CASH_FLOW_FROM);
            }
            if(OBJ_VALID_FROM != '0000-00-00'){
                lRUnit[0].Object_Valid_From__c = Date.valueof(OBJ_VALID_FROM);
            }
            update lRUnit;
            if(MEASUREMENTL.size()>0){
                for(MeasurementList ML : MEASUREMENTL){
                        measList = [select id,name,Leasing_Rental_Unit__c,Measurement_Type_ID__c from Measurement__c where Leasing_Rental_Unit__c =: lRUnit[0].Id AND Measurement_Type_ID__c =: ML.MEAS];
                        if(measList.size()>0){
                            delete measList;
                        }
                        Measurement__c meas = new Measurement__c();
                        meas.Measurement_Type_ID__c = ML.MEAS;
                        meas.Measurement_Type_Description__c = ML.XMMEAS;
                        meas.Measurement_Amount__c = ML.MEASVALUE;
                        meas.Measurement_Unit__c = ML.MEASUNIT;
                        if(ML.VALIDTO != '0000-00-00'){
                            meas.Measurement_Valid_To__c = Date.valueof(ML.VALIDTO);
                        }
                        if(ML.VALIDFROM != '0000-00-00'){
                            meas.Measurement_Valid_From__c = Date.valueof(ML.VALIDFROM);
                        }
                        meas.Leasing_Rental_Unit__c = lRUnit[0].Id;
                        insertMList.add(meas);
             
                }
                insert insertMList;
            }
            
            r.returnCode=0;
            r.message='Leasing Unit '+INTRE_NO+' is updated successfully!';
            r.SFDF_Unit_ID= 'SDFC Leasing Unit ID is ' +lRUnit[0].Id;
            r.INTRE_NO = ' ' +INTRE_NO;
        }else{
            Leasing_Rental_Unit__c LRU = new Leasing_Rental_Unit__c();
            LRU.Name = RENTAL_OBJ_NAME;
            LRU.INTRENO__c = INTRE_NO;
            LRU.Company_Code__c = COMPANY_CODE;
            LRU.Business_Entity_Number__c = BUS_ENTITY_NO;
            LRU.Number_of_Rental_Object__c = NO_OF_RENTAL_OBJ;
            LRU.Rental_Object_Type_ID__c = RENTAL_OBJ_TYPE_ID;
            LRU.Rental_Object_Type_Description__c = RENTAL_OBJ_TYPE_DES;
            LRU.Usage_Type_ID__c = USAGE_TYPE_ID;
            LRU.Usage_Type_Description__c = USAGE_TYPE_DES;
            LRU.Rental_Object_Name__c = RENTAL_OBJ_NAME;
            LRU.Land__c = LAND;
            LRU.Building_Name__c = BUILDING;
            if(lProj.size()>0){
            LRU.Building__c = lProj[0].Id;
            }else{
                r.returnCode=2;
                r.message='Project does not match';
                return r;
            }
            if(CASH_FLOW_FROM != '0000-00-00'){
                LRU.Cash_Flow_From__c = Date.valueof(CASH_FLOW_FROM);
            }
            if(OBJ_VALID_FROM != '0000-00-00'){
                LRU.Object_Valid_From__c = Date.valueof(OBJ_VALID_FROM);
            }
            insert LRU;
            if(MEASUREMENTL.size()>0){
                
                for(MeasurementList ML : MEASUREMENTL){
           
                        Measurement__c meas = new Measurement__c();
                        meas.Measurement_Type_ID__c = ML.MEAS;
                        meas.Measurement_Type_Description__c = ML.XMMEAS;
                        meas.Measurement_Amount__c = ML.MEASVALUE;
                        meas.Measurement_Unit__c = ML.MEASUNIT;
                        if(ML.VALIDTO != '0000-00-00'){
                            meas.Measurement_Valid_To__c = Date.valueof(ML.VALIDTO);
                        }
                        if(ML.VALIDFROM != '0000-00-00'){
                            meas.Measurement_Valid_From__c = Date.valueof(ML.VALIDFROM);
                        }
                        meas.Leasing_Rental_Unit__c = LRU.Id;
                        insertMList.add(meas);
                    
                }
                insert insertMList;
            }
            
            r.returnCode=0;
            r.message='Leasing Rental Unit '+INTRE_NO+' is created successfully!';
            r.SFDF_Unit_ID= 'SDFC Leasing Rental Unit ID is ' +LRU.Id;
            r.INTRE_NO = ' '+INTRE_NO;
        }
        return r;
    }
    
    global class REST_result {
        webservice Integer returnCode;
        webservice String message;
        webservice String SFDF_Unit_ID;
        webservice String INTRE_NO;
    } 
    
    global class MeasurementList{
        Public String MEAS;
        Public String XMMEAS;
        Public Decimal MEASVALUE;
        Public String MEASUNIT;
        Public String VALIDTO;
        Public String VALIDFROM; 
    }
}