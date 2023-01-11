@isTest
public class CustomerDataSheet_v2_Test {
    
    static list<Account> acc;
    static Contact cont;
    static Lead ld; 
    static Lead led;
    static Lead led1;
    static Lead led2;
    static Lead luxld;
    static site__c st ;
    static Project__c pjR;
    //static Project__c pjL;
    static Opportunity opp;
    
    static testMethod void createLeads() {
        Test.startTest();
        
        opp = TestDataFactory_Stetig.createOpportunity(1)[0];
        cont =TestDataFactory_Stetig.createContacts(5)[0];
        acc = TestDataFactory_Stetig.createAccounts(1);
        st = TestDataFactory_Stetig.createSite(1)[0];
        pjR = TestDataFactory_Stetig.createResProject(1)[0];
        insert acc;
        insert st;
        pjR.Site__c =st.Id;
        system.debug('pjR'+pjR);
        insert pjR;
        integer count =5;
        insert opp;
        insert cont;       
        
        opp.StageName = 'Lost';
        update opp;
        system.debug('Opportunity Id is '+opp.Id);
        
        
        led = TestDataFactory_Stetig.createResLead(1)[0]; 
        ld = TestDataFactory_Stetig.createResLead(1)[0];
        ld.Email ='tte@test.coe';
        ld.Project__c = pjR.Id;
        //ld.site__c=st.id;
        ld.MobilePhone ='7374393933'; 
        //  insert ld;
        led.Site__c =st.id;
        led.Country_Picklist__c ='India';
        led.Locality__c ='test Loc';
        led.City__c ='test city';
        led.Occupation_in_case_of_other__c = 'test';
        led.Project__c = pjR.Id;
        led.Industry = 'chemicals' ;
        led.LeadSource = 'Web';
        led.Country_Code_for_Other_Mobile_Number__c = '+91';
        led.Other_Mobile_Number__c ='3333333388';
        led.Partner_Email__c ='test@eee.com';
        led.Partner_s_Firm_Name__c ='test Firm Part';
        led.Partner_s_Name__c ='Part Name';
        led.Partner_s_Office_Address__c ='Off Add Part';
        led.Company_Custom__c ='test';
        led.Occupation_in_case_of_other__c = 'test';
        led.Contact_Person_Name__c = 'test';
        led.Designation__c = 'test';
        led.Company_Address__c = 'test';
        //led.Partner_Mobile__c ='6546876688';
        insert led;   
        system.debug('led:: '+led);
        system.debug('ld:: '+ld);
        ApexPages.StandardController sc = new ApexPages.standardController(led);
        ApexPages.StandardController scs = new ApexPages.standardController(ld);        
        PageReference pageRefs = Page.CustomerDataSheet_Page1_v2;
        CustomerDataSheet_v2 myPageCon = new CustomerDataSheet_v2(sc);
        CustomerDataSheet_v2 myPageCon1 = new CustomerDataSheet_v2(scs);
        CustomerDataSheet_v2.GEM ='tte@test.coe';
        Contact cont = TestDataFactory_Stetig.createContacts(5)[0];
        cont.FirstName = 'Test';
        List<String> List1 = new List<String> ();
        List1.add('Below 800');
        CustomerDataSheet_v2.Wrapper wrp = new  CustomerDataSheet_v2.Wrapper(cont, count);
        system.debug('Vaidehi'+wrp);
        myPageCon.slctRequment = '2 BHK,2.5 BHK,3 BHK,4 BHK';
        myPageCon.occupation = 'Others';
        myPageCon.industry = 'telecom';
        myPageCon.carperareasel = List1;
        myPageCon.sameApplicant = 'No';
        myPageCon.contactVal = 'Mobile,Email';
        myPageCon.whtlkng = 'Brand,Location,Accessibility,Ambience';
        myPageCon.lstwrp.add(wrp);
        myPageCon.Walkinsource ='Direct';
        myPageCon.residentStatus = 'NRI';
        myPageCon.CorAdress ='Office Address';
        myPageCon.sameApplicant ='Yes';
        myPageCon.bdgt='Above 8 cr';
        myPageCon.slctRequment='Duplex,';
        myPageCon.carpetArea='1601-2200,';
        myPageCon.hear ='Digital';
        myPageCon.howSoon ='3-6 Month';
        myPageCon.purposeOfBuying ='Investment';
        myPageCon.whtlkng ='Brand,';
        myPageCon.possesionTime ='within a year,';
        myPageCon.occupation ='Business'; 
        myPageCon.prmVal = '1';
        myPageCon.mbno ='1834124555';
        myPageCon.otmo ='33333388';
        myPageCon.slctProj =pjR.Id;
        myPageCon.ProjectId =pjR.Id;
        myPageCon.subcustomerType ='First Visit';
        myPageCon.EmailCon='tte@test.coe';
        myPageCon.LocationRating = 'Liked';
        myPageCon.mbnoOtherflg = '+91';
        myPageCon.customerType ='New Customer';
        myPageCon.GetLastName = led.LastName;
        myPageCon.GetFirstName = led.FirstName;
        myPageCon.GetMiddleName = led.MiddleName; 
        myPageCon1.mbno = '1934124555';
        myPageCon1.slctProj = pjR.Id;
        myPageCon1.ProjectId =pjR.Id;
        myPageCon1.EmailCon='tte@test.coe';
        PageReference pageRef = Page.CustomerDataSheet_Page2_v2;
        system.debug('testttt'+led+'***'+pjR.Id);
        led.company ='test comp';
        led.Country__c ='IND';
        led.Nationality__c ='Indian';
        led.Resident_Status__c ='Indian';
        ApexPages.currentPage().getParameters().put('subCat','First Visit');
        ApexPages.currentPage().getParameters().put('LN','test Ld');
        ApexPages.currentPage().getParameters().put('FN','test');
        ApexPages.currentPage().getParameters().put('EM','tte@test.coe');
        ApexPages.currentPage().getParameters().put('mbno','7374393933');
        ApexPages.currentPage().getParameters().put('PH','4537202369');
        ApexPages.currentPage().getParameters().put('PHCode','+91');
        ApexPages.currentPage().getParameters().put('PJ',pJR.Id);
        ApexPages.currentPage().getParameters().put('MN','midName');
        ApexPages.currentPage().getParameters().put('convertoppty','true');
        
        Test.setCurrentPage(pageRef);
        Test.setCurrentPage(pageRefs);
        
        myPageCon.sendOTPMail(CustomerDataSheet_v2.GEM, 'hcdh');
        myPageCon.sendOTPMail_Dummy2('test@test.in', 'hcdh');
        myPageCon.sendOTPMail_Dummy1('test@test.in', 'hcdh');
        myPageCon.resetOTP();
        myPageCon.doSave();
        myPageCon.saveDetails();
        myPageCon.doAdd();
        myPageCon.doRem();
        myPageCon.opportunityId = opp.Id;
        myPageCon.updateOppty = true;
        myPageCon.updateOppty();
        myPageCon.Dummy();
        myPageCon.saveImage();
        myPageCon.clearImage();
        myPageCon.cp_saveImage();
        myPageCon.cp_clearImage();
        CustomerDataSheet_v2.createCoOwner(acc,opp.id,'test' );
        
        
        Test.StopTest();
    }
     
    static testMethod void createLead1() {
        opp = TestDataFactory_Stetig.createOpportunity(1)[0];
        
        cont =TestDataFactory_Stetig.createContacts(5)[0];
        acc = TestDataFactory_Stetig.createAccounts(2);
        st = TestDataFactory_Stetig.createSite(1)[0];
        pjR = TestDataFactory_Stetig.createResProject(1)[0];
        insert acc;
        insert st;
        pjR.Site__c =st.Id;
        system.debug('pjR'+pjR);
        insert pjR;
        integer count =5;
        insert opp;
        insert cont;       
        
        opp.StageName = 'Lost';
        update opp;
        List<Id> oppid = new List<Id>();
        system.debug('Opportunity Id is '+opp.Id);
        oppid.add(opp.Id);
        led = TestDataFactory_Stetig.createResLead(1)[0]; 
        ApexPages.StandardController sc = new ApexPages.standardController(led);
        CustomerDataSheet_v2 myPageCon = new CustomerDataSheet_v2(sc);
        
        Test.StartTest(); 
        
        led.Email ='tte@test.coe';
        led.Project__c = pjR.Id;
        //ld.site__c=st.id;
        led.MobilePhone ='7374393933'; 
        //insert ld;
        
        led.Site__c =st.id;
        led.Country_Picklist__c ='India';
        led.Locality__c ='test Loc';
        led.City__c ='test city';
        myPageCon.mbno ='1123ui46';        
        myPageCon.saveDetails();
        led.Other_Mobile_Number__c ='ygsu';
        myPageCon.saveDetails();
        myPageCon.customerType ='Others';
        
        OpportunityScoring.ScoreOnTask(oppid);
        
        myPageCon.searchAccounts();
        myPageCon.chboxaction();
        //myPageCon.getCPAccounts('qwerty');
        test.stopTest();
        
    }
    
      static testMethod void createLeads2() {
        Test.startTest();
        
        opp = TestDataFactory_Stetig.createOpportunity(1)[0];
        cont =TestDataFactory_Stetig.createContacts(5)[0];
        acc = TestDataFactory_Stetig.createAccounts(1);
        st = TestDataFactory_Stetig.createSite(1)[0];
        pjR = TestDataFactory_Stetig.createResProject(1)[0];
        insert acc;
        insert st;
        pjR.Site__c =st.Id;
        system.debug('pjR'+pjR);
        insert pjR;
        integer count =5;
        insert opp;
        insert cont;       
        
        //opp.StageName = 'Lost';
        //update opp;
        system.debug('Opportunity Id is '+opp.Id);
        
        
        led = TestDataFactory_Stetig.createResLead(1)[0]; 
        ld = TestDataFactory_Stetig.createResLead(1)[0];
        ld.Email ='tte@test.coe';
        ld.Project__c = pjR.Id;
        //ld.site__c=st.id;
        ld.MobilePhone ='7374393933'; 
        //  insert ld;
        led.Site__c =st.id;
        led.Country_Picklist__c ='India';
        led.Locality__c ='test Loc';
        led.City__c ='test city';
        led.Occupation_in_case_of_other__c = 'test';
        led.Project__c = pjR.Id;
        led.Industry = 'chemicals' ;
        led.LeadSource = 'Web';
        led.Country_Code_for_Other_Mobile_Number__c = '+91';
        led.Other_Mobile_Number__c ='3333333388';
        led.Partner_Email__c ='test@eee.com';
        led.Partner_s_Firm_Name__c ='test Firm Part';
        led.Partner_s_Name__c ='Part Name';
        led.Partner_s_Office_Address__c ='Off Add Part';
        led.Company_Custom__c ='test';
        led.Occupation_in_case_of_other__c = 'test';
        led.Contact_Person_Name__c = 'test';
        led.Designation__c = 'test';
        led.Company_Address__c = 'test';
        //led.Partner_Mobile__c ='6546876688';
        insert led;   
        system.debug('led:: '+led);
        system.debug('ld:: '+ld);
        ApexPages.StandardController sc = new ApexPages.standardController(led);
        ApexPages.StandardController scs = new ApexPages.standardController(ld);        
        PageReference pageRefs = Page.CustomerDataSheet_Page1_v2;
        CustomerDataSheet_v2 myPageCon = new CustomerDataSheet_v2(sc);
        CustomerDataSheet_v2 myPageCon1 = new CustomerDataSheet_v2(scs);
        CustomerDataSheet_v2.GEM ='tte@test.coe';
        Contact cont = TestDataFactory_Stetig.createContacts(5)[0];
        cont.FirstName = 'Test';
        List<String> List1 = new List<String> ();
        List1.add('Below 800');
        CustomerDataSheet_v2.Wrapper wrp = new  CustomerDataSheet_v2.Wrapper(cont, count);
        system.debug('Vaidehi'+wrp);
        myPageCon.slctRequment = '2 BHK,2.5 BHK,3 BHK,4 BHK';
        myPageCon.occupation = 'Others';
        myPageCon.industry = 'telecom';
        myPageCon.carperareasel = List1;
        myPageCon.sameApplicant = 'No';
        myPageCon.contactVal = 'Mobile,Email';
        myPageCon.whtlkng = 'Brand,Location,Accessibility,Ambience';
        myPageCon.lstwrp.add(wrp);
        myPageCon.Walkinsource ='Direct';
        myPageCon.residentStatus = 'NRI';
        myPageCon.CorAdress ='Office Address';
        myPageCon.sameApplicant ='Yes';
        myPageCon.bdgt='Above 8 cr';
        myPageCon.slctRequment='Duplex,';
        myPageCon.carpetArea='1601-2200,';
        myPageCon.hear ='Digital';
        myPageCon.howSoon ='3-6 Month';
        myPageCon.purposeOfBuying ='Investment';
        myPageCon.whtlkng ='Brand,';
        myPageCon.possesionTime ='within a year,';
        myPageCon.occupation ='Business'; 
        myPageCon.prmVal = '1';
        myPageCon.mbno ='1834124555';
        myPageCon.otmo ='33333388';
        myPageCon.slctProj =pjR.Id;
        myPageCon.ProjectId =pjR.Id;
        myPageCon.subcustomerType ='First Visit';
        myPageCon.EmailCon='tte@test.coe';
        myPageCon.LocationRating = 'Liked';
        myPageCon.mbnoOtherflg = '+91';
        myPageCon.customerType ='New Customer';
        myPageCon.GetLastName = led.LastName;
        myPageCon.GetFirstName = led.FirstName;
        myPageCon.GetMiddleName = led.MiddleName; 
        myPageCon1.mbno = '1934124555';
        myPageCon1.slctProj = pjR.Id;
        myPageCon1.ProjectId =pjR.Id;
        myPageCon1.EmailCon='tte@test.coe';
        PageReference pageRef = Page.CustomerDataSheet_Page2_v2;
        system.debug('testttt'+led+'***'+pjR.Id);
        led.company ='test comp';
        led.Country__c ='IND';
        led.Nationality__c ='Indian';
        led.Resident_Status__c ='Indian';
        ApexPages.currentPage().getParameters().put('subCat','First Visit');
        ApexPages.currentPage().getParameters().put('LN','test Ld');
        ApexPages.currentPage().getParameters().put('FN','test');
        ApexPages.currentPage().getParameters().put('EM','tte@test.coe');
        ApexPages.currentPage().getParameters().put('mbno','7374393933');
        ApexPages.currentPage().getParameters().put('PH','4537202369');
        ApexPages.currentPage().getParameters().put('PHCode','+91');
        ApexPages.currentPage().getParameters().put('PJ',pJR.Id);
        ApexPages.currentPage().getParameters().put('MN','midName');
        ApexPages.currentPage().getParameters().put('convertoppty','true');
        
        Test.setCurrentPage(pageRef);
        Test.setCurrentPage(pageRefs);
        
        myPageCon.sendOTPMail(CustomerDataSheet_v2.GEM, 'hcdh');
        myPageCon.sendOTPMail_Dummy2('test@test.in', 'hcdh');
        myPageCon.sendOTPMail_Dummy1('test@test.in', 'hcdh');
        myPageCon.resetOTP();
        myPageCon.doSave();
        myPageCon.saveDetails();
        myPageCon.doAdd();
        myPageCon.doRem();
        myPageCon.opportunityId = opp.Id;
        myPageCon.updateOppty = true;
        myPageCon.updateOppty();
        myPageCon.Dummy();
        myPageCon.saveImage();
        myPageCon.clearImage();
        myPageCon.cp_saveImage();
        myPageCon.cp_clearImage();
        CustomerDataSheet_v2.createCoOwner(acc,opp.id,'test' );
        
        
        Test.StopTest();
    }
    
    
}