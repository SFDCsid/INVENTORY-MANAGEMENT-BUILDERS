@RestResource(urlMapping='/SAP_Integration/FlowCarParks/*')
global class REST_CarParksOAuth{
    @HttpPOST
    global static REST_result CarParks(String Material_code, String Project_ID, String Material_Description, Decimal QUANTITY) 
    {
        Decimal Count = QUANTITY;
        REST_result r=new REST_result();
        List<Car_Parking__c> CarParkingToInsert  = new List<Car_Parking__c>();
        List<Project__c> p = new List<Project__c>();
        
        if(String.isBlank(Material_code)||String.isBlank(Project_ID)|| QUANTITY == Null||String.isBlank(Material_Description))
        {
            r.returnCode=1;
            r.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED';
            return r;
        }
        
        p= [SELECT ID,Plant__c FROM Project__c WHERE Plant__c =: Project_ID];
        
        if(p.isEmpty()){
            r.returnCode=4;
            r.message='The particular Project is not available';
            return r;
        }
        Else{
            If(Count > 0){
                for(Integer i = 0; i < Count ; i++){
                    Car_Parking__c Obj = new Car_Parking__c();
                    OBJ.name = Material_code;
                    Obj.Active__c = True;
                    Obj .Project__c = p[0].id;
                    Obj.Status__c = 'Available';
                    Obj.Remarks__c = Material_Description;
                    CarParkingToInsert.add(Obj);
                }
                insert CarParkingToInsert  ;
                r.returnCode=0;
                r.message=Count +' Parkings are created successfully!';
                return r;
            }
            r.returnCode=9;
            r.message='Something went wrong Please try again!';
        }
        return r;
    }
    global class REST_result {
        webservice Integer returnCode;
        webservice String message;
        //webservice String SFDF_Unit_ID;
    } 
}