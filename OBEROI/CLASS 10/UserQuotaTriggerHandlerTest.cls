@isTest
public class UserQuotaTriggerHandlerTest {
    static TestMethod void testDataInsertion() {
        List<Site__c> lstOfSites = TestDataFactory.createSite(1);
        INSERT lstOfSites;
        Id customerRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        List<Account> accounts = new List<Account>();       
        Account personAcc = new Account(lastname='Person Account',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Individual',Residential_Status__pc='Resident Citizen');
        accounts.add(personAcc);
        
        Account personAcc2 = new Account(lastname='Person Account2',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Individual');
        accounts.add(personAcc2);
        
        insert accounts;
        
        Id KYCRecordId = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        KYC_Details__c kycDetails = new KYC_Details__c( Person_Account__c = personAcc.Id,
                                                       Board_Resolution__c=true, 
                                                       Cert_of_Incorporation__c=true, 
                                                       Company_PAN__c=true,
                                                       HUF_PAN__c=true, 
                                                       Latest_ITR_optional__c=true, 
                                                       List_of_Designated_Partners__c=true, 
                                                       List_of_Directors__c=true, 
                                                       List_of_HUF_Members__c=true, 
                                                       List_of_Partners__c=true, 
                                                       List_of_Trustees__c=true, 
                                                       LLP_Agreement__c=true, 
                                                       LLP_PAN__c=true, 
                                                       M_O_A_A_O_A__c=true, 
                                                       NRI_Declaration__c=true, 
                                                       OCI_PIO_Card__c=true, 
                                                       PAN_Card__c=false, 
                                                       Passport_Election_ID__c=false, 
                                                       Proprietorship_PAN__c=true,
                                                       Registered_Partnership_Deed__c=true, 
                                                       Registered_Trust_Deed__c=true, 
                                                       Resolution__c=true,
                                                       recordtypeid = KYCRecordId,
                                                       Bank_Confirmation_Letter__c=true);
        insert kycDetails;
        
        KYC_Details__c kycDetails2 = new KYC_Details__c( Person_Account__c = personAcc2.Id,
                                                        Board_Resolution__c=true, 
                                                        Cert_of_Incorporation__c=true, 
                                                        Company_PAN__c=true,
                                                        HUF_PAN__c=true, 
                                                        Latest_ITR_optional__c=true, 
                                                        List_of_Designated_Partners__c=true, 
                                                        List_of_Directors__c=true, 
                                                        List_of_HUF_Members__c=true, 
                                                        List_of_Partners__c=true, 
                                                        List_of_Trustees__c=true, 
                                                        LLP_Agreement__c=true, 
                                                        LLP_PAN__c=true, 
                                                        M_O_A_A_O_A__c=true, 
                                                        NRI_Declaration__c=true, 
                                                        OCI_PIO_Card__c=true, 
                                                        PAN_Card__c=false, 
                                                        Passport_Election_ID__c=false, 
                                                        Proprietorship_PAN__c=true,
                                                        Registered_Partnership_Deed__c=true, 
                                                        Registered_Trust_Deed__c=true, 
                                                        Resolution__c=true,
                                                        recordtypeid = KYCRecordId,
                                                        Bank_Confirmation_Letter__c=true);
        insert kycDetails2;
        
        List<Project__c> lstOfProject = TestDataFactory.createResProject(1);
        lstOfProject[0].Site__c = lstOfSites[0].Id;
        lstOfProject[0].X_of_Single_Parking__c = 5;
        lstOfProject[0].X_of_Single_Parking_Remaining__c = 5;
        lstOfProject[0].X_of_Tandem_Parking_Remaining__c = 5;
        lstOfProject[0].X_of_Triple_Parking_Remaining__c = 5;
        lstOfProject[0].X_of_Tandem_Parking__c = 5;
        lstOfProject[0].X_of_Triple_Parking__c = 5;
        INSERT lstOfProject;
        
        Project_Quota__c projQuota = TestDataFactory.createProjectQuota(lstOfProject[0].Id, DateTime.now().format('MMMMM'), Date.today().year(), 10000);
        insert projQuota;
        
        User_Quota__c userQuota = TestDataFactory.createUserQuota(projQuota.Id, lstOfProject[0].Id, DateTime.now().format('MMMMM'), Date.today().year(), 5000);
        insert userQuota;
        
        userQuota.Year__c = Date.today().year() + 1;
        update userQuota;
    }
}