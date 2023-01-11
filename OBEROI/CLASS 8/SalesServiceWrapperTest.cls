@isTest
public class SalesServiceWrapperTest {
    @isTest
    public static void myUnitTest(){
        SalesServiceWrapper  wrapper= new SalesServiceWrapper ();
        cls_projects wrapper1 = new cls_projects(); 
        SalesServiceWrapper.cls_projects clr = new SalesServiceWrapper.cls_projects();
        
    }
    @TestVisible
    private class cls_projects {
        //your code
        cls_booking obj=new cls_booking();
        list<cls_booking> booking= new list<cls_booking>();
    }
   
    
    
    @TestVisible
    private class cls_booking {
        list<cls_booking> booking= new list<cls_booking>();
    }
    @istest
    public static void myTest(){
        try{
            String JSON_STRING='{"name":"Example"}';
            SalesServiceWrapper.parse(JSON_STRING);
       
        }
        catch(exception e){
            
        }
        
        
    }
    
    
}