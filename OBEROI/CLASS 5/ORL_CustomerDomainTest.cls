@isTest(seealldata = true)
public class ORL_CustomerDomainTest {
    
    @isTest  
    static void testORL_CustomerDomainTest(){
        
        ORL_CustomerDomain obj = new ORL_CustomerDomain();
        
        Booking__c objBook = new Booking__c();
        Contract conLst = new Contract();
        List<Booking__c> bookLst = [select id,name from Booking__c];
        List<Contract> cLst = new List<Contract>();
        list<string> invIds = new list<string>{'',''};
        obj.retrieveBookingByIds(invIds);
        obj.retrieveContractByIds(invIds);
        obj.retrieveApplicantsByBookingId(objBook.ID);
        obj.retrieveApplicantsByContractId(objBook.ID);
        try{
         obj.amendBooking(bookLst);   
        }catch(Exception Ex)
        {
        obj.amendContracts(cLst);   
        }
    }
}