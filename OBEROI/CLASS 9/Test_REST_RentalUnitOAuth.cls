@isTest
Public Class Test_REST_RentalUnitOAuth{
    @isTest
    public static void RentalUnit(){
        Leasing_Project__c LP = new Leasing_Project__c();
        LP.Company_Code__c = '1200';
        LP.Business_Entity_Number__c = '1200';
        LP.Customer_Account_Group__c = '3400';
        LP.Leasing_Team__c = UserInfo.getUserId();
        LP.Sales_Organization__c = '1131';
        LP.Plant__c = '11AM';
        LP.Leasing_HOD__c = UserInfo.getUserId();
        insert LP;      
        
        Leasing_Rental_Unit__c lr = new Leasing_Rental_Unit__c();
        lr.INTRENO__c = 'IM00100001590';
        lr.Company_Code__c = '1200';
        lr.Business_Entity_Number__c = '1200';
        lr.Number_of_Rental_Object__c = 'F40';
        lr.Rental_Object_Type_ID__c = 'RU';
        lr.Rental_Object_Type_Description__c = 'Rental Unit';
        lr.Object_Valid_From__c = System.Today();
        lr.Usage_Type_ID__c = '5';
        lr.Usage_Type_Description__c = 'Usage Des';
        lr.Rental_Object_Name__c = 'F-40';
        lr.Building__c = LP.Id;
        lr.Building_Name__c = '00007030';
        lr.Cash_Flow_From__c = System.Today();
        lr.Unit_Type__c = 'Main Entity';
        insert lr;
        
        Measurement__c Mea = new Measurement__c();
        Mea.Measurement_Type_ID__c = 'A001';
        Mea.Measurement_Type_Description__c = 'Meas Des';
        Mea.Measurement_Amount__c = 100;
        Mea.Measurement_Unit__c = 'FT2';
        Mea.Measurement_Valid_To__c = System.Today();
        Mea.Measurement_Valid_From__c = System.Today();
        Mea.Leasing_Rental_Unit__c = lr.Id;
        insert Mea;
        
        Test.StartTest();
        List<REST_RentalUnitOAuth.MeasurementList> MEL = new List<REST_RentalUnitOAuth.MeasurementList>();
        
        REST_RentalUnitOAuth.MeasurementList ML = new REST_RentalUnitOAuth.MeasurementList();
        ML.MEAS = 'A001';
        ML.XMMEAS = 'Meas Des';
        ML.MEASVALUE = 100;
        ML.MEASUNIT = 'FT2';
        ML.VALIDTO = '2021-09-24';
        ML.VALIDFROM = '2021-09-24';
        MEL.add(ML);
        
        REST_RentalUnitOAuth.RentalUnitUpdate('IM00100001590','1200','1200','F40','RU','Rental Unit','5','Usage Des','F-40','','00003470','2021-09-24','2021-09-24',MEL);
        REST_RentalUnitOAuth.RentalUnitUpdate('IM00100001234','1200','1200','F40','RU','Rental Unit','5','Usage Des','F-40','','00003470','2021-09-24','2021-09-24',MEL);
        Test.StopTest();
    }
}