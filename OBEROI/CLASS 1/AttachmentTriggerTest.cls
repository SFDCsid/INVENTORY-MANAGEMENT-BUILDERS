@isTest
public class AttachmentTriggerTest {
  static testmethod void attachmentTester() {

        Case testCase = new Case(Status ='New', Priority = 'Medium', Origin = 'Email'); 
        insert testCase;

        EmailMessage msg = new EmailMessage(
            ToAddress = 'them.' + Datetime.now().format('yyyymmddhhmmss') + '@sforce.com',
            FromAddress = 'me.' + Datetime.now().format('yyyymmddhhmmss') + '@sforce.com',
            FromName = 'Thomas Train',
            TextBody = 'This is a test of the email attachment reassigner service',
            ParentId = testCase.Id);

        insert msg;

        Attachment a = new Attachment();
        a.name = 'test attachment';
        a.body = blob.valueof('attachment body');
        a.parentid = msg.Id;

        Test.startTest();
        insert a;   
        Test.stopTest();

        Attachment testAtt = [SELECT ParentId from Attachment where Id = :a.Id];
        System.assertEquals(testCase.Id, a.ParentId); 

    }   
}