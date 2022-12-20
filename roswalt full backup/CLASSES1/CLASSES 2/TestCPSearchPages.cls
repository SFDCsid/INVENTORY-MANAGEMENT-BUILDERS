@istest
public class TestCPSearchPages {

    @istest
    private static void CPSearch()
    {
         RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Channel Partner' and SObjectType = 'Account'];
        Account a = new Account(lastName='test', personEmail = 'test@gmail.com', MahaRERA_Registration_No__c= 'test9158747991', RecordType = personAccountRecordType);
        insert a;
        
        
     
      
        CPSearchPageController cp = new CPSearchPageController();
        cp.accSearch.Phone='9158747991';
        cp.accSearch.MahaRERA_Registration_No__c='test123';
        cp.search();
        cp.accSearch.Phone= '9090908890';
        cp.accSearch.MahaRERA_Registration_No__c='';
        cp.search();
        
        cp.accSearch.Phone= '';
        cp.accSearch.MahaRERA_Registration_No__c='jkikji90';
        cp.search();
        cp.continueMethod();
        cp.editMethod();
        
        Test.StartTest(); 
 
  PageReference pageRef = Page.CPFORM; 
       
  pageRef.getParameters().put('type', 'edit');
  pageRef.getParameters().put('mobile', '9158747991');
  pageRef.getParameters().put('reraId', 'test123');
  pageRef.getParameters().put('accId', a.id);  
  
   Test.setCurrentPage(pageRef);
   CPFormController cf= new CPFormController();
  
   cf.submit();
   a.Point_of_Contact_Name__c='Aditi Sarang';
   //a.Name_as_per_MahaRERA__c= 'Atest';
   //a.Name ='test';
   //a.MahaRERA_Registration_No__c = 'test45';
   a.Point_of_Contact_Mobile__c='9158747991';
   a.Location1__c ='Western';
   a.Sub_location__c='test';
   a.CP_Type__c='Institutional Channel Partner';
   a.CP_Stage__c= 'Prospect';
   a.CP_Sub_stage__c = 'High Potential';
   //a.Point_of_Contact__c = '0039D00000KgxfrQAB';
   
        update a;
        cf.submit();
        cf.Undo();
        cf.previous();
        
     
        
  PageReference pageRef2 = Page.CPFORM; 
  pageRef2.getParameters().put('type', 'create');
  pageRef2.getParameters().put('mobile', '9158747922');
  pageRef2.getParameters().put('reraId', 'test1234');
   
   Test.setCurrentPage(pageRef2);
   CPFormController cf2= new CPFormController();
   a.Point_of_Contact_Name__c='Aditi Sarang';
  // a.Name_as_per_MahaRERA__c= 'Atest';
   //a.Name ='test';
   //a.MahaRERA_Registration_No__c = 'test45';
   a.Point_of_Contact_Mobile__c='9158747991';
   a.Location1__c='Western';
   a.Sub_location__c='test';
   a.CP_Type__c='Institutional Channel Partner';
   a.CP_Stage__c= 'Prospect';
   a.CP_Sub_stage__c = 'High Potential';
  // a.Point_of_Contact__c = userinfo.getUserId();
        a.PAN_No__c = 'dfkps4567y';
        a.TAN_No__c = 'rfvt78965h';
        a.GST_No__c = 'test566';
    a.CP_Firm_Type__c = 'LLP';
        a.Description = 'tgtetst';
        update a;
    //cf2.submit(); 
        
  PageReference pageRef3 = Page.CPFORM; 
  pageRef3.getParameters().put('type', 'edit');
  pageRef3.getParameters().put('mobile', '9158747991');
  pageRef3.getParameters().put('reraId', 'test123');
  pageRef3.getParameters().put('accId', a.id);  
  
   Test.setCurrentPage(pageRef3);
   CPFormController cf3= new CPFormController();
        cf3.accList[0].Name='';
        cf3.submit();
         cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='';
        cf3.submit();
         cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c ='test';
        cf3.accList[0].CP_Firm_Type__c ='';
        cf3.submit(); 
        cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
        cf3.accList[0].phone='';
        cf3.submit(); 
        cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
        //cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].phone='9158747991';
        cf3.accList[0].Point_of_Contact_Mobile__c='';
        cf3.submit(); 
         cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
        //cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].phone='9158747991';
        cf3.accList[0].Point_of_Contact_Mobile__c='9158747991';
        cf3.accList[0].Email__c = 'test45@gmail.com';
        cf3.accList[0].Location1__c='';
        cf3.submit(); 
        cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
       // cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].Point_of_Contact_Mobile__c='9158747991';
       // cf3.accList[0].Contact_No_of_Person_Met__c='9158747991';
         cf3.accList[0].Email__c = 'test45@gmail.com';
        cf3.accList[0].Location1__c='Western';
        cf3.accList[0].Sub_location__c='';
        
        string formType = 'create';
        contact cc= new contact();
           	 cc.LastName =  cf3.accList[0].Name;
           	 cc.Phone =  cf3.accList[0].Phone;
           	 cc.Email =  cf3.accList[0].Email__c;
             //cc.AccountId =  cf3.accList[0].Id;
                 insert cc;
        cf3.submit(); 
          cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
        //cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].Point_of_Contact_Mobile__c='9158747991';
        //cf3.accList[0].Contact_No_of_Person_Met__c='9158747991';
        cf3.accList[0].Location1__c='Western';
        cf3.accList[0].Sub_location__c='test';
        cf3.accList[0].Description = '';
        cf3.submit(); 
         cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
        //cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].Point_of_Contact_Mobile__c='9158747991';
        //cf3.accList[0].Contact_No_of_Person_Met__c='9158747991';
        cf3.accList[0].Location1__c='Western';
        cf3.accList[0].Sub_location__c='test';
        cf3.accList[0].Description = 'rfvgt';
         cf3.accList[0].PAN_No__c=null;
      cf3.submit(); 
       
         cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
       // cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].Point_of_Contact_Mobile__c='9158747991';
        //cf3.accList[0].Contact_No_of_Person_Met__c='9158747991';
        cf3.accList[0].Location1__c='Western';
         cf3.accList[0].Sub_location__c ='ystemtest';
        cf3.accList[0].Description = 'rfvgt';
        cf3.accList[0].PAN_Card__c = true;
      cf3.submit(); 
         cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
       // cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].Point_of_Contact_Mobile__c='9158747991';
       //cf3.accList[0].Contact_No_of_Person_Met__c='9158747991';
        cf3.accList[0].Location1__c='Western';
        cf3.accList[0].TAN_No__c='test12345t';
        cf3.accList[0].Sub_location__c= 'yddd';
        cf3.accList[0].PAN_Card__c = false;
        cf3.submit(); 
         cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
        //cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].Point_of_Contact_Mobile__c='9158747991';
        //cf3.accList[0].Contact_No_of_Person_Met__c='9158747991';
        cf3.accList[0].Location1__c='Western';
        cf3.accList[0].Sub_location__c='test';
        cf3.accList[0].MahaRERA_Registration_No__c= 'test4456';
        cf3.accList[0].Name_as_per_MahaRERA__c='Yes';
        cf3.accList[0].CP_Stage__c='Prospect';
        cf3.accList[0].CP_Sub_stage__c='High Potential'; 
       cf3.submit(); 
        cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
        //cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].Point_of_Contact_Mobile__c='9158747991';
        //cf3.accList[0].Contact_No_of_Person_Met__c='9158747991';
        cf3.accList[0].Location1__c='Western';
        cf3.accList[0].Sub_location__c='test';
        cf3.accList[0].MahaRERA_Registration_No__c= 'test4456';
        cf3.accList[0].Name_as_per_MahaRERA__c='Yes';
        cf3.accList[0].CP_Stage__c='Prospect';   
        cf3.accList[0].CP_Sub_stage__c='Prospect'; 
        cf3.accList[0].CP_Sub_stage__c='High Potential'; 
        cf3.submit(); 
       cf3.accList[0].Name='Aditi Sarang';
        cf3.accList[0].Point_of_Contact_Name__c='test';
        //cf3.accList[0].Name_of_Person_Met__c='test';
        cf3.accList[0].Point_of_Contact_Mobile__c='9158747991';
        //cf3.accList[0].Contact_No_of_Person_Met__c='9158747991';
        cf3.accList[0].Location1__c='Western';
        cf3.accList[0].Sub_location__c='test';
        cf3.accList[0].MahaRERA_Registration_No__c= 'test4456';
        cf3.accList[0].Name_as_per_MahaRERA__c='Yes';
        cf3.accList[0].CP_Stage__c='Prospect';   
        cf3.accList[0].CP_Sub_stage__c='High Potential'; 
       cf3.submit(); 
        
        
     
        
            /*DateTime dt = System.now();
            String dateTimeStr = dt.format('yyyy/MM/dd hh:mm:ss a');
            ContentVersion cv=new Contentversion();
			cv.title='PanCard:'+dateTimeStr;
			cv.PathOnClient ='test';
            system.debug(cv.pathOnClient);
			Blob b=Blob.valueOf('OR CP ONLY');
			cv.versiondata=EncodingUtil.base64Decode('FOR CP ONLY');
        
			insert cv;*/
        
               /*Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
            
            ContentVersion contentVersion_1 = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.jpg',
                VersionData = Blob.valueOf('body'), 
                ContentLocation = 'S',
                ContentUrl = 'aa'
            );
            insert contentVersion_1;
            
            ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                            FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
            
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = cf3.accList[0].id;
            contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink;*/
        
        		//Create Document Parent Record
       Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='Header_Picture1', 
            PathOnClient ='/Header_Picture1.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
       
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = cf3.accList[0].id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink; 
        
        System.assertEquals(documents.size(), 1);
        System.assertEquals(documents[0].Id, contentVersion_2.ContentDocumentId);
        System.assertEquals(documents[0].LatestPublishedVersionId, contentVersion_2.Id);
        System.assertEquals(documents[0].Title, contentVersion_2.Title);
        System.assertEquals(contentlink.ContentDocumentId,contentVersion_2.ContentDocumentId );
        
        
        
        cf3.PfileName = 'test';
        cf3.gfileName ='test1';
        cf3.psfileName = 'test2';
        cf3.rfileName = 'test3';
      String p1base64 = 'gdghdf'; // for cp pan
      String g1base64 = 'gdghdf1'; //Gst
      String r1base64 = 'gdghdf2';  //rera
      String ps1base64 = 'gdghdf3'; //passport
        cf3.setg1base64(g1base64);
        cf3.setp1base64(p1base64);
        cf3.setps1base64(ps1base64);
        cf3.setr1base64(r1base64);
        cf3.getg1base64();
        cf3.getp1base64();
        cf3.getps1base64();
        cf3.getr1base64();
        cf3.Previous1();
        cf3.Next();
        cf3.savePanFile();
        cf3.saveGSTFile();
        cf3.savePassportFile();
        cf3.saveRERAFile();
        
      Test.StopTest();
        
    }
    
}