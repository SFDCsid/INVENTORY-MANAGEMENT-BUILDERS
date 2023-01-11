@isTest
public class CustomerDataSheetControllerTest {
    
    @TestSetup
    private static void createTestData() {
        
        CustomerDataSheetController customerdata=new CustomerDataSheetController();
        customerdata.slctRequment='abc';
        customerdata.EliteName='xz';
        customerdata.EliteProject='BEsa';
        customerdata.EliteTower='BEwe';
        customerdata.EliteFlat='BE12';
        customerdata.carAreaSelect='Car';
        customerdata.occupation='BE';
        customerdata.industry='Agreeculture';
        customerdata.initialProject='yes';
        customerdata.generatedOTP='12345';
        customerdata.whtlkng='yes';
        customerdata.prmVal='yes';
        customerdata.sctPrty='Car';
        customerdata.eliteId='Car';
        customerdata.slctProj='Car';
        customerdata.bdgt='Car';
        customerdata.Lastname='1234';
        customerdata.CorAdress='1234';
        customerdata.carpetArea ='1234';
        customerdata.hear ='1234';
        customerdata.otherIndustry ='1234';
        customerdata.ConobjName='Account';
        customerdata.Lastname2='ABC';
        customerdata.possesionTime='noon';
        customerdata.sameApplicant='1234';
        customerdata.ProjectName ='1234';
        customerdata.contactNoRes='1234';
        customerdata.propConsultantEmail='1234';
        customerdata.resCntrCOde='1234';
        customerdata.officeCntrCOde='1234';
        customerdata.prtConsCntrCOde='1234';
        customerdata.pcEmail ='1234';
        customerdata.pcOffice='1234';
        customerdata.officeAdd='1234';
        customerdata.mbTwoCntryCode ='1234';
        
        customerdata.newPagePartialUrl='hrrp://salesforce.com';
        customerdata.mbOneCntryCode='91';
        customerdata.contactVal='1234';
        customerdata.residentStatus='booked';
        customerdata.howSoon='immediate';
        customerdata.purposeOfBuying='investment';
        customerdata.brokercontact='6767766765656';
        customerdata.accobjPCIc='ss';
        customerdata.accobjName='Account';
        customerdata.customerType='New';
        customerdata.Walkinsource='News';
        customerdata.subcustomerType='New';
        customerdata.enquirySubCategory='New';
        customerdata.checkMbNumber=TRUE;
        customerdata.mndtTrue=TRUE;
        customerdata.allowEnquiry=TRUE;
        customerdata.displayOTPPanel=TRUE;
        Lead lead=new Lead();
        lead.City__c='pune';
        lead.Contact__c='34463773';
        customerdata.leadobj=lead;
    }
    @IsTest  static void testCustomerData() {   
       CustomerDataSheetController customermethod=new CustomerDataSheetController();
        test.startTest();
       customermethod.resetOTP();
         customermethod.redirectToPage();
       
        customermethod.sendOTPMail('aa@ff.com','bulk');
        test.stopTest();
    }
}