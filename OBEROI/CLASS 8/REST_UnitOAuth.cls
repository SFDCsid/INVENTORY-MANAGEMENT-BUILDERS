@RestResource(urlMapping='/SAP_Integration/FlowUnit/*')
global class REST_UnitOAuth{
    @HttpPOST
     global static REST_result UnitUpdate(String Material_code, String Project_ID, String Material_Description, String PRICING_REF_MATERIAL, String Company_code, String Sales_organisation ,
     String Tower, String UNIT_NO, String Floor_NO ,String VARIANT, String Area, String area_uom,String sale_price, String Net_value, String Tax,
     String status) 
    {
        REST_result r=new REST_result();
        List<Property__c> u= new List<Property__c>();
        List<Tower__c> t= new List<Tower__c>();
        List<Property_Type__c > Pt= new List<Property_Type__c>();
        List<Project__c> p = new List<Project__c>();
 
        if(String.isBlank(Material_code)||String.isBlank(Project_ID)||String.isBlank(Tower)||String.isBlank(PRICING_REF_MATERIAL))
        {
            r.returnCode=1;
            r.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED';
            return r;
        }
        u = [SELECT ID,Material_No__c,Allotted__c FROM Property__c WHERE Material_No__c = : Material_code];//materialcode
        Pt= [SELECT ID, Name,Material_No__c FROM Property_Type__c WHERE Material_No__c =: PRICING_REF_MATERIAL];
        p= [SELECT ID,Plant__c FROM Project__c WHERE Plant__c =: Project_ID];
        t= [SELECT ID, Project_Name__c FROM Tower__c WHERE Tower_Name__c =: Tower AND Project_Name__c =: p[0].ID];
        
        if(t.isEmpty()){
            r.returnCode=3;
            r.message='The particular Tower is not available';
            return r;
        }
       if(p.isEmpty()){
            r.returnCode=4;
            r.message='The particular Project is not available';
            return r;
        }
      if(Pt.isEmpty()){
            r.returnCode=4;
            r.message='The Property Type is not available';
            return r;
        }
       
      if(p[0].ID != t[0].Project_Name__c){
            r.returnCode=2;
            r.message='Project And Tower Does Not Match! Unit Creation Failed!';
            return r;
        }
        
        if(u.size()>0)//unit name diffrentitation (Uniqueness)
        {
            System.debug('Unit Found');
            u[0].Material_No__c = Material_code;
            u[0].Project_Name__c = p[0].ID;
            u[0].Description__c = Material_Description;
            If(pt.size()>0)
            u[0].Property_Type__c = Pt[0].ID;
            u[0].Company_Code__c = Company_code;
            u[0].Sales_Organization__c = Sales_organisation;
            u[0].Tower__c = t[0].ID;
            u[0].House_Unit_No__c = UNIT_NO;
            if(Floor_NO.contains('-')){
                Floor_NO= Floor_NO.substringAfterLast('- ');
            }
            u[0].Floor_No__c = Decimal.valueOf(Floor_NO);//letter
            u[0].Carpet_Area__c = Decimal.valueOf(Area);
            u[0].Active__c = True;
            if(u[0].Allotted__c == False){
                If(status == 'AVAILABLE'){
                    u[0].Status__c = 'Available';
                    
                }Else if(status == 'SOLD'){
                    u[0].Status__c = 'Sold';
                    //u[0].Active__c = False;
                }
            }
            update u;
            
            r.returnCode=0;
            r.message='Unit '+UNIT_NO+' is updated successfully!';
            r.SFDF_Unit_ID= 'SDFC Unit ID is ' +u[0].Id;
        }
        else
        {
            Property__c Obj=new Property__c();
            Obj.RecordTypeId = Schema.SObjectType.Property__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
            Obj.Material_No__c = Material_code;
            Obj.Project_Name__c = p[0].ID;
            Obj.Project_Name__c = p[0].ID;
            Obj.Description__c = Material_Description;
            If(pt.size() >0)
            Obj.Property_Type__c = Pt[0]?.ID;
            Obj.Company_Code__c = Company_code;
            Obj.Sales_Organization__c = Sales_organisation;
            Obj.Tower__c = t[0].ID;
            Obj.House_Unit_No__c = UNIT_NO;
            if(Floor_NO.contains('-')){
                Floor_NO= Floor_NO.substringAfterLast('- ');
            }            
            Obj.Floor_No__c = Decimal.valueOf(Floor_NO);//letter
            Obj .Carpet_Area__c = Decimal.valueOf(Area);
            Obj.Active__c = True;
            If(status == 'AVAILABLE'){
                Obj.Status__c = 'Available';
                
            }Else if(status == 'SOLD'){
                Obj.Status__c = 'Sold';
                //Obj.Active__c = False;
            }
            insert Obj;
           
            r.returnCode=0;
            r.message='Unit '+UNIT_NO+' is created successfully!';
            r.SFDF_Unit_ID= 'SDFC Unit ID is ' +Obj.Id;
            
        }
        
        return r;
    }
    
    
    
    global class REST_result {
        webservice Integer returnCode;
        webservice String message;
        webservice String SFDF_Unit_ID;
    } 
}