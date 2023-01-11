@isTest
public class TestViewFilesController {
    @isTest
    public static void TestViewFiles(){
             List<DocumentApprovalList__c> daList = new List<DocumentApprovalList__c>();
        DocumentApprovalList__c da = new DocumentApprovalList__c();
        da.Name = 'Acceptance Form';
        daList.add(da);
        
         DocumentApprovalList__c da2 = new DocumentApprovalList__c();
        da2.Name = 'Agreement Form';
        daList.add(da2);
        
         DocumentApprovalList__c da3 = new DocumentApprovalList__c();
        da3.Name = 'Allotment Form';
        daList.add(da3);
        
        
         DocumentApprovalList__c da4 = new DocumentApprovalList__c();
        da4.Name = 'Bank NOC';
        daList.add(da4);
        
         DocumentApprovalList__c da5 = new DocumentApprovalList__c();
        da5.Name = 'Provisional NOC';
        daList.add(da5);
        
         DocumentApprovalList__c da6 = new DocumentApprovalList__c();
        da6.Name = 'TPA';
        daList.add(da6);
        
        if(!daList.isEmpty()){
            insert daList;
        }
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                                 personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                          AccountId = ac.id);
        insert opp;
        
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(dataMap.get('BILLING_PLAN'));
        Id unitId = dataMap.get('PROPERTY');
        Id projectId = dataMap.get('PROJECT');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        Id planId = dataMap.get('BILLING_PLAN');
        
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'Acceptance Form';
        dt.Document_Type__c = 'Acceptance Form';
        dt.Project__c = projectId; 
        dt.Clause_0__c = '{!Booking__c.Booking_Date__c} {!Applicant__c.Salutation__c} {!Applicant__c.Name} {!olDecimal.sOLDecimal} {!olDecimal.eOLDecimal} {!olDecimal.sDecimalList} {!olDecimal.eDecimalList} {!p.pStart} {!p.pEnd} {!ol.sOL} {!ol.eOL} {!ol.sLId} {!ol.eLId} {!ol.sLIa} {!ol.eLIa} {!ol.sLIUA} {!ol.eLIUA} {!ol.sLIr} {!ol.eLIr} {!Table.TableStart} {!Table.TableEnd} {!Table.TRowStart} {!Table.TRowEnd} {!Table.TCellStart} {!Table.TCellEnd} {!Table.THeaderStart} {!Table.THeaderEnd}';
        dt.Clause_1__c = '{!OtherApplicantDetails.Second Applicant Salutation} {!OtherApplicantDetails.Third Applicant Salutation} {!OtherApplicantDetails.Fourth Applicant Salutation} {!OtherApplicantDetails.Fifth Applicant Salutation} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures} {!AllApplicantDetails.All Applicant Names with Index} {!AllApplicantDetails.All Applicant Names Inline} {!AllApplicantDetails.All Applicant Names with Index and Linebreak} {!AllApplicantDetails.All Applicant Names with Allottees} {!ReferenceNo.refno} {!FloorNo.FloorNo}';
        dt.Clause_2__c = '{!OtherApplicantDetails.Second Applicant Name} {!OtherApplicantDetails.Third Applicant Name} {!OtherApplicantDetails.Fourth Applicant Name} {!OtherApplicantDetails.Fifth Applicant Name} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures} {!PageBreak.sPageBreak} {!Justify.sJustify} {!Justify.eJustify} {!lineBreak.lineBreak}';
        dt.Clause_3__c = '{!Schedule-Bare Shell.First Schedule} {!Schedule-Bare Shell.Second Schedule} {!Schedule-Bare Shell.Third Schedule} {!Schedule-Bare Shell.Fourth Schedule} {!Schedule-Bare Shell.Fifth Schedule}';
        dt.Clause_4__c = '{!Schedule-Typical(Multi Tower Project).First Schedule} {!Schedule-Typical(Multi Tower Project).Second Schedule} {!Schedule-Typical(Multi Tower Project).Third Schedule} {!Schedule-Typical(Multi Tower Project).Fourth Schedule} {!Schedule-Typical(Multi Tower Project).Fifth Schedule}';
        dt.Clause_5__c = '{!Schedule-Typical (Tower as Seprate Project).First Schedule} {!Schedule-Typical (Tower as Seprate Project).Second Schedule} {!Schedule-Typical (Tower as Seprate Project).Third Schedule} {!Schedule-Typical (Tower as Seprate Project).Fourth Schedule} {!Schedule-Typical (Tower as Seprate Project).Fifth Schedule}';
        dt.Clause_6__c = '{!Schedule-Penthouse.First Schedule} {!Schedule-Penthouse.Second Schedule} {!Schedule-Penthouse.Third Schedule} {!Schedule-Penthouse.Fourth Schedule} {!Schedule-Penthouse.Fifth Schedule}';
        dt.Clause_7__c = '{!Property__c.Name} {!Tower__c.Name} {!opportunity.Name} {!Account.Name} {!Quotation__c.Name} {!Project__c.Name} {!Schedule-Duplex.Fifth Schedule}';
        //insert dt;
        
        Document_Template__c dt1 = new Document_Template__c();
        dt1.Name = 'Agreement Form';
        dt1.Document_Type__c = 'Agreement Form';
        dt1.Project__c = projectId; 
        dt1.Clause_0__c = '{!Booking__c.Booking_Date__c} {!Applicant__c.Salutation__c} {!Applicant__c.Name} {!olDecimal.sOLDecimal} {!olDecimal.eOLDecimal} {!olDecimal.sDecimalList} {!olDecimal.eDecimalList} {!p.pStart} {!p.pEnd} {!ol.sOL} {!ol.eOL} {!ol.sLId} {!ol.eLId} {!ol.sLIa} {!ol.eLIa} {!ol.sLIUA} {!ol.eLIUA} {!ol.sLIr} {!ol.eLIr} {!Table.TableStart} {!Table.TableEnd} {!Table.TRowStart} {!Table.TRowEnd} {!Table.TCellStart} {!Table.TCellEnd} {!Table.THeaderStart} {!Table.THeaderEnd}';
        dt1.Clause_1__c = '{!OtherApplicantDetails.Second Applicant Salutation} {!OtherApplicantDetails.Third Applicant Salutation} {!OtherApplicantDetails.Fourth Applicant Salutation} {!OtherApplicantDetails.Fifth Applicant Salutation} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures} {!ReferenceNo.refno} {!FloorNo.FloorNo}';
        dt1.Clause_2__c = '{!OtherApplicantDetails.Second Applicant Name} {!OtherApplicantDetails.Third Applicant Name} {!OtherApplicantDetails.Fourth Applicant Name} {!OtherApplicantDetails.Fifth Applicant Name} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures}';
        dt1.Clause_3__c = '{!Schedule-Bare Shell.First Schedule} {!Schedule-Bare Shell.Second Schedule} {!Schedule-Bare Shell.Third Schedule} {!Schedule-Bare Shell.Fourth Schedule} {!Schedule-Bare Shell.Fifth Schedule}';
        dt1.Clause_4__c = '{!Schedule-Typical(Multi Tower Project).First Schedule} {!Schedule-Typical(Multi Tower Project).Second Schedule} {!Schedule-Typical(Multi Tower Project).Third Schedule} {!Schedule-Typical(Multi Tower Project).Fourth Schedule} {!Schedule-Typical(Multi Tower Project).Fifth Schedule}';
        dt1.Clause_5__c = '{!Schedule-Typical (Tower as Seprate Project).First Schedule} {!Schedule-Typical (Tower as Seprate Project).Second Schedule} {!Schedule-Typical (Tower as Seprate Project).Third Schedule} {!Schedule-Typical (Tower as Seprate Project).Fourth Schedule} {!Schedule-Typical (Tower as Seprate Project).Fifth Schedule}';
        dt1.Clause_6__c = '{!Schedule-Penthouse.First Schedule} {!Schedule-Penthouse.Second Schedule} {!Schedule-Penthouse.Third Schedule} {!Schedule-Penthouse.Fourth Schedule} {!Schedule-Penthouse.Fifth Schedule}';
        dt1.Clause_7__c = '{!Property__c.Name} {!Tower__c.Name} {!opportunity.Name} {!Account.Name} {!Quotation__c.Name} {!Project__c.Name} {!Schedule-Duplex.Fifth Schedule}';
        //insert dt;
        
        Document_Template__c dt2 = new Document_Template__c();
        dt2.Name = 'Allotment Form';
        dt2.Document_Type__c = 'Allotment Form';
        dt2.Project__c = projectId; 
        dt2.Clause_0__c = '{!Booking__c.Booking_Date__c} {!Applicant__c.Salutation__c} {!Applicant__c.Name} {!olDecimal.sOLDecimal} {!olDecimal.eOLDecimal} {!olDecimal.sDecimalList} {!olDecimal.eDecimalList} {!p.pStart} {!p.pEnd} {!ol.sOL} {!ol.eOL} {!ol.sLId} {!ol.eLId} {!ol.sLIa} {!ol.eLIa} {!ol.sLIUA} {!ol.eLIUA} {!ol.sLIr} {!ol.eLIr} {!Table.TableStart} {!Table.TableEnd} {!Table.TRowStart} {!Table.TRowEnd} {!Table.TCellStart} {!Table.TCellEnd} {!Table.THeaderStart} {!Table.THeaderEnd}';
        dt1.Clause_1__c = '{!OtherApplicantDetails.Second Applicant Salutation} {!OtherApplicantDetails.Third Applicant Salutation} {!OtherApplicantDetails.Fourth Applicant Salutation} {!OtherApplicantDetails.Fifth Applicant Salutation} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures} {!ReferenceNo.refno} {!FloorNo.FloorNo}';
        dt1.Clause_2__c = '{!OtherApplicantDetails.Second Applicant Name} {!OtherApplicantDetails.Third Applicant Name} {!OtherApplicantDetails.Fourth Applicant Name} {!OtherApplicantDetails.Fifth Applicant Name} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures}';
        dt1.Clause_3__c = '{!Schedule-Bare Shell.First Schedule} {!Schedule-Bare Shell.Second Schedule} {!Schedule-Bare Shell.Third Schedule} {!Schedule-Bare Shell.Fourth Schedule} {!Schedule-Bare Shell.Fifth Schedule}';
        dt1.Clause_4__c = '{!Schedule-Typical(Multi Tower Project).First Schedule} {!Schedule-Typical(Multi Tower Project).Second Schedule} {!Schedule-Typical(Multi Tower Project).Third Schedule} {!Schedule-Typical(Multi Tower Project).Fourth Schedule} {!Schedule-Typical(Multi Tower Project).Fifth Schedule}';
        dt1.Clause_5__c = '{!Schedule-Typical (Tower as Seprate Project).First Schedule} {!Schedule-Typical (Tower as Seprate Project).Second Schedule} {!Schedule-Typical (Tower as Seprate Project).Third Schedule} {!Schedule-Typical (Tower as Seprate Project).Fourth Schedule} {!Schedule-Typical (Tower as Seprate Project).Fifth Schedule}';
        dt1.Clause_6__c = '{!Schedule-Penthouse.First Schedule} {!Schedule-Penthouse.Second Schedule} {!Schedule-Penthouse.Third Schedule} {!Schedule-Penthouse.Fourth Schedule} {!Schedule-Penthouse.Fifth Schedule}';
        dt1.Clause_7__c = '{!Property__c.Name} {!Tower__c.Name} {!opportunity.Name} {!Account.Name} {!Quotation__c.Name} {!Project__c.Name} {!Schedule-Duplex.Fifth Schedule}';
        
        
        
        PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', opp.Id);
        
        
        string othercharges_serialize = '[]';//JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
        
        string sap_serialize = JSON.serialize(SAPChrges);
        
        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        
        string discountList_serialize = '[]'; // = JSON.serialize(discountList);
        string carParKList = '[]'; //= '["TANDEM",1,100000]'; 
        string fieldSet = '[{"label":"unitId","value":"' + unitId +'"},{"label":"editschedule","value":false},{"label":"oppId","value":"' + opp.id +'"},{"label":"additionalComments","value":""},{"label":"selectedPlan","value":"' + planId + '"},{"label":"changeInSource","value":false},{"label":"revisedBookingSource","value":null},{"label":"referredBy","value":null},{"label":"referProject","value":null},{"label":"referTower","value":null},{"label":"referFlat","value":null},{"label":"referEmpCode","value":null}]';
        string qId = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
        string st1 = QuotationManagmentServices.INFormat(10);
        
        Booking__c b = new Booking__C();
        b.Opportunity__c = opp.id;
        b.Booking_Date__c = system.today();
        b.Acceptance_Form_Template__c = 'Acceptance_Form';
        b.Agreement_Form_Template__c = 'Agreement_Form';
        b.Allotment_Form_Template__c = 'Allotment_Form';
        
        
        b.Status__c = 'Booking In Process';
        
        if(qId!=null){
            if(qId.contains(',')){
                qId = qId.substring(0, qId.lastIndexOf(','));
            }
            b.Quotation__c = qId;  
        }
        b.Default_Address_of__c = '1st Applicant';
        b.Project__c = projectId;
        b.Tower__c = towerId;
        b.Property__c = unitId;
        insert b;
        
        List<Applicant__c> aplist = new List<Applicant__c>();
        Applicant__c ap = new Applicant__c();
        ap.Booking__C = b.id;
        ap.Applicant_Number__c = 'Primary Applicant';
        ap.Opportunity__c = opp.id;
        ap.Type_Of_Applicant__c = 'Individual Buyer';
        ap.PancardNo__c = 'ABCDE1234E';
        ap.Salutation__c = 'Capt.';
        ap.Applicant_Type__c = 'Primary';
        ap.Name = 'Primary Applicant';
        ap.Mobile_Number__c = '1234567890';
        ap.Nationality__c = 'Indian';
        ap.Subtype_Of_Applicant__c = 'Indian National';
        ap.Mailing_Address_same_as_PermanentAddress__c = true;
        ap.House_No__c = 'House';
        ap.Street_1__c = 'Street1';
        ap.Street_2__c = 'Street2';
        ap.City__c = 'Mumbai';
        insert ap;
        aplist.add(ap);
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Booking__C = b.id;
        ap2.Applicant_Number__c = 'Second Applicant';
        ap2.Opportunity__c = opp.id;
        ap2.Type_Of_Applicant__c = 'Individual Buyer';
        ap2.PancardNo__c = 'ABCDE1234E';
        ap2.Salutation__c = 'Capt.';
        ap2.Applicant_Type__c = 'Second';
        ap2.Name = 'Second Applicant';
        ap2.Mobile_Number__c = '1234567890';
        ap2.Nationality__c = 'Indian';
        ap2.Subtype_Of_Applicant__c = 'Indian National';
        ap2.Mailing_Address_same_as_PermanentAddress__c = true;
        ap2.House_No__c = 'House';
        ap2.Street_1__c = 'Street1';
        ap2.Street_2__c = 'Street2';
        ap2.City__c = 'Mumbai';
        insert ap2;
        aplist.add(ap2);
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Booking__C = b.id;
        ap3.Applicant_Number__c = 'Third Applicant';
        ap3.Opportunity__c = opp.id;
        ap3.Type_Of_Applicant__c = 'Individual Buyer';
        ap3.PancardNo__c = 'ABCDE1234E';
        ap3.Salutation__c = 'Capt.';
        ap3.Applicant_Type__c = 'Third';
        ap3.Name = 'Third Applicant';
        ap3.Mobile_Number__c = '1234567890';
        ap3.Nationality__c = 'Indian';
        ap3.Subtype_Of_Applicant__c = 'Indian National';
        ap3.Mailing_Address_same_as_PermanentAddress__c = true;
        ap3.House_No__c = 'House';
        ap3.Street_1__c = 'Street1';
        ap3.Street_2__c = 'Street2';
        ap3.City__c = 'Mumbai';
        insert ap3;
        aplist.add(ap3);
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Booking__C = b.id;
        ap4.Applicant_Number__c = 'Fourth Applicant';
        ap4.Opportunity__c = opp.id;
        ap4.Type_Of_Applicant__c = 'Individual Buyer';
        ap4.PancardNo__c = 'ABCDE1234E';
        ap4.Salutation__c = 'Capt.';
        ap4.Applicant_Type__c = 'Fourth';
        ap4.Name = 'Fourth Applicant';
        ap4.Mobile_Number__c = '1234567890';
        ap4.Nationality__c = 'Indian';
        ap4.Subtype_Of_Applicant__c = 'Indian National';
        ap4.Mailing_Address_same_as_PermanentAddress__c = true;
        ap4.House_No__c = 'House';
        ap4.Street_1__c = 'Street1';
        ap4.Street_2__c = 'Street2';
        ap4.City__c = 'Mumbai';
        insert ap4;
        aplist.add(ap4);
        Applicant__c ap5 = new Applicant__c();
        ap5.Booking__C = b.id;
        ap5.Applicant_Number__c = 'Fifth Applicant';
        ap5.Opportunity__c = opp.id;
        ap5.Type_Of_Applicant__c = 'Individual Buyer';
        ap5.PancardNo__c = 'ABCDE1234E';
        ap5.Salutation__c = 'Capt.';
        ap5.Applicant_Type__c = 'Fifth';
        ap5.Name = 'Fifth Applicant';
        ap5.Mobile_Number__c = '1234567890';
        ap5.Nationality__c = 'Indian';
        ap5.Subtype_Of_Applicant__c = 'Indian National';
        ap5.Mailing_Address_same_as_PermanentAddress__c = true;
        ap5.House_No__c = 'House';
        ap5.Street_1__c = 'Street1';
        ap5.Street_2__c = 'Street2';
        ap5.City__c = 'Mumbai';
        insert ap5;
        aplist.add(ap5);
        
        opportunity opr = new Opportunity();
        opr.id = opp.id;
        opr.Booking__c = b.id;
        opr.Property__c = unitId;
        opr.project__c = projectId;
        update opr;
        
        Property__c pr = new Property__c();
        pr.id = unitId;
        pr.status__C = 'Booked';
        pr.Tower__c=towerId;
        update pr;
        
        opp.Property__c=pr.id;
        update opp;
        Test.StartTest();
        PageReference pageRef2 = Page.DocumentUploadPage;
        Test.setCurrentPage(pageRef2);
        //pageRef2.getParameters().put('id', dt.id);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(dt);
        DocumentUpload ts = new DocumentUpload(sc2);
        //ts.selectedObject = 'UnitCost';
        //ts.prepareFieldList();
        ts.selectedObject = 'OtherApplicantDetails';
        ts.prepareFieldList();
        ts.selectedObject = 'AllApplicantDetails';
        ts.prepareFieldList();
        ts.selectedObject = 'Schedule-Typical(Multi Tower Project)';
        ts.prepareFieldList();
        ts.selectedObject = 'Schedule-Typical (Tower as Seprate Project)';
        ts.prepareFieldList();
        ts.selectedObject = 'Schedule-Duplex';
        ts.prepareFieldList();
        ts.selectedObject = 'Schedule-Penthouse';
        ts.prepareFieldList(); 
        ts.selectedObject = 'Schedule-Bare Shell';
        ts.prepareFieldList(); 
        ts.selectedObject = 'SeventhTable1';
        ts.prepareFieldList();
        ts.selectedObject = 'Morgage NOC';
        ts.prepareFieldList();
        ts.selectedObject = 'Contact Details Update';
        ts.prepareFieldList();
        ts.selectedObject = 'Possesion';
        ts.prepareFieldList();
        ts.selectedObject = 'PageBreak';
        ts.preparemergefield();
        ts.selectedObject = 'Justify';
        ts.preparemergefield();
        ts.selectedObject = 'lineBreak';
        ts.preparemergefield();
        ts.selectedObject = 'ol';
        ts.preparemergefield();
        ts.selectedObject = 'olDecimal';
        ts.preparemergefield();
        ts.selectedObject = 'p';
        ts.preparemergefield();
        ts.selectedObject = 'Id';
        ts.preparemergefield();
        ts.save();
        ts.saveAndPriview();
        ts.addRow();
        
        PageReference pRef3 = Page.GenerateCustomerDocument;
        Test.setCurrentPage(pRef3);
        //ApexPages.currentPage().getParameters().put('oppId',oppId);
        GenerateCustomerDocument gd = new GenerateCustomerDocument();
        List<SelectOption> projectList = gd.getProjects;
        gd.selectedVal = projectId;
        //List<SelectOption> clusterList = gd.getClusterNames ;
        //gd.SelectedClusterId = clusterId;
        List<SelectOption> towerList = gd.getTowers ;
        gd.selectedTower = towerId;
        List<SelectOption> docList = gd.getDocumentNames;         
        gd.selectedDocument = 'Acceptance Form'; 
        gd.checkInput();
        gd.CustomerListNew();
        gd.customerList[0].selected = true;
        gd.generateDocument();
        gd.getDisablePrevious();
        gd.getDisableNext();
        gd.getTotal_size();
        gd.getPageNumber();
        gd.getTotalPages();
        gd.getNextCustomers();
        gd.projectchange();
        gd.towerchange();
        gd.documentchange();
        GenerateCustomerDocument.dummy();
        DocumentGenerationServices.dummy();
        
        
        
        
        PageReference pRef4 = Page.View_Document;
        Test.setCurrentPage(pRef4);
        ApexPages.currentPage().getParameters().put('oppId',opp.Id);
        ApexPages.currentPage().getParameters().put('docType','Acceptance Form'); 
        ApexPages.currentPage().getParameters().put('docName','Acceptance Form');
        ViewDocument adf = new ViewDocument();
        PaginationController.PaginationWrapper pc = new PaginationController.PaginationWrapper(10,10,10);
        PaginationController.Beginning(pc);
        PaginationController.Previous(pc);
        PaginationController.Next(pc);
        PaginationController.End(pc);
        
        PageReference pRef5 = Page.View_Document;
        Test.setCurrentPage(pRef5);
        ApexPages.currentPage().getParameters().put('oppId',opp.Id);
        ApexPages.currentPage().getParameters().put('docType','Agreement Form'); 
        ApexPages.currentPage().getParameters().put('docName','Agreement Form');
        ViewDocument adf1 = new ViewDocument();
        PaginationController.PaginationWrapper pc1 = new PaginationController.PaginationWrapper(10,10,10);
        PaginationController.Beginning(pc1);
        PaginationController.Previous(pc1);
        PaginationController.Next(pc1);
        PaginationController.End(pc1);
        Test.StopTest();
        
        String str = DocumentGenerationServices.getAllApplicantAllotmentSignature(aplist,'test');
        Map<string, string> relatedMap = DocumentGenerationServices.generateDocumentMethod('Agreement Form',opp);
        List<Related_Document_History__c> rlist = new List<Related_Document_History__c>();
        Related_Document_History__c r;
        for(String rid:relatedMap.keySet()){
            if(rid!=null){
                r = new Related_Document_History__c();
                r.id = rid;
                r.Submitted_for_Approval__c=true;
                rlist.add(r);
            }
        }
        if(!rlist.isEmpty()){
            update rlist;         
        }
        //  DocumentGenerationServices.generateDocumentMethod('NRI Declaration Form',opp);
        //  DocumentGenerationServices.generateDocumentMethod('Mortgage Release Request Letter',opp);
        // DocumentGenerationServices.generateDocumentMethod('Agreement signing undertaking',opp);
        // DocumentGenerationServices.generateDocumentMethod('Annexure B - Nomination Form',opp);
        //  DocumentGenerationServices.generateDocumentMethod('TPA',opp);
        
        //system.debug('str='+str);
        //DocumentGenerationServices dgs = new DocumentGenerationServices(); 
        //string aaa = dgs.getSeventhScheduleDetails(b,q,p,ap,t,'SeventhTable1');
        DocumentUpload dc = new DocumentUpload();
        
        PageReference vfiles = Page.ViewFilesComponent;
        Test.setCurrentPage(vfiles);
        vfiles.getParameters().put('id', rlist[0].id);
        //        ViewFilesComponentController ts2 = new ViewFilesComponentController();
        if(!rlist.isEmpty()){
            for(Related_Document_History__c r2:rlist){
                r2.Document_Approved__c = true;
            }
            update rlist;
        } 
        Profile prof = [select id from profile where name LIKE '%Luxury Sales Rep%'];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'testVFPage2';
        user.profileId = prof.id;
        user.username = 'testVFPage2@test.com';
        user.email = 'test@test.com';
        user.CompanyName = 'TEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';        
        insert user;
        system.runAs(user){
            vfiles.getParameters().put('id', rlist[0].id);
            ViewFilesComponentController ts3 = new ViewFilesComponentController();
            ts3.fileName='test.pdf';
            ts3.base64  = EncodingUtil.urlEncode('Unit Test Attachment Body','UTF-8');
            ts3.saveFile();
           // ts3.refreshView();    
        }
        
        Contentversion cv = new Contentversion();
        cv.Title = 'ABC';
        cv.PathOnClient = 'test';
        cv.isDocGen__c = true;
        cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.urlEncode('Unit Test Attachment Body','UTF-8'));
        insert cv;
        
        cv.isApproved__c = true;
        Database.SaveResult result = Database.update(cv, false);
       // cv.isDocGen__c = true;
       // Database.SaveResult result2 = Database.update(cv, false);
        
        
        if(!rlist.isEmpty()){
            for(Related_Document_History__c r2:rlist){
                r2.Document_Approved__c = false;
                r2.Document_Rejected__c= true;
            }
            update rlist;
        } 
        system.runAs(user){
            vfiles.getParameters().put('id', rlist[0].id);
            ViewFilesComponentController ts3 = new ViewFilesComponentController();
            ts3.refreshView();    
        }      
    }  
    @isTest
    public static void TestViewFiles2(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                                 personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                          AccountId = ac.id);
        insert opp;
        
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(dataMap.get('BILLING_PLAN'));
        Id unitId = dataMap.get('PROPERTY');
        Id projectId = dataMap.get('PROJECT');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        Id planId = dataMap.get('BILLING_PLAN');
        
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'Acceptance Form';
        dt.Document_Type__c = 'Acceptance Form';
        dt.Project__c = projectId; 
        dt.Clause_0__c = '{!Booking__c.Booking_Date__c} {!Applicant__c.Salutation__c} {!Applicant__c.Name} {!olDecimal.sOLDecimal} {!olDecimal.eOLDecimal} {!olDecimal.sDecimalList} {!olDecimal.eDecimalList} {!p.pStart} {!p.pEnd} {!ol.sOL} {!ol.eOL} {!ol.sLId} {!ol.eLId} {!ol.sLIa} {!ol.eLIa} {!ol.sLIUA} {!ol.eLIUA} {!ol.sLIr} {!ol.eLIr} {!Table.TableStart} {!Table.TableEnd} {!Table.TRowStart} {!Table.TRowEnd} {!Table.TCellStart} {!Table.TCellEnd} {!Table.THeaderStart} {!Table.THeaderEnd}';
        dt.Clause_1__c = '{!OtherApplicantDetails.Second Applicant Salutation} {!OtherApplicantDetails.Third Applicant Salutation} {!OtherApplicantDetails.Fourth Applicant Salutation} {!OtherApplicantDetails.Fifth Applicant Salutation} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures} {!AllApplicantDetails.All Applicant Names with Index} {!AllApplicantDetails.All Applicant Names Inline} {!AllApplicantDetails.All Applicant Names with Index and Linebreak} {!AllApplicantDetails.All Applicant Names with Allottees} {!ReferenceNo.refno} {!FloorNo.FloorNo}';
        dt.Clause_2__c = '{!OtherApplicantDetails.Second Applicant Name} {!OtherApplicantDetails.Third Applicant Name} {!OtherApplicantDetails.Fourth Applicant Name} {!OtherApplicantDetails.Fifth Applicant Name} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures} {!PageBreak.sPageBreak} {!Justify.sJustify} {!Justify.eJustify} {!lineBreak.lineBreak}';
        dt.Clause_3__c = '{!Schedule-Bare Shell.First Schedule} {!Schedule-Bare Shell.Second Schedule} {!Schedule-Bare Shell.Third Schedule} {!Schedule-Bare Shell.Fourth Schedule} {!Schedule-Bare Shell.Fifth Schedule}';
        dt.Clause_4__c = '{!Schedule-Typical(Multi Tower Project).First Schedule} {!Schedule-Typical(Multi Tower Project).Second Schedule} {!Schedule-Typical(Multi Tower Project).Third Schedule} {!Schedule-Typical(Multi Tower Project).Fourth Schedule} {!Schedule-Typical(Multi Tower Project).Fifth Schedule}';
        dt.Clause_5__c = '{!Schedule-Typical (Tower as Seprate Project).First Schedule} {!Schedule-Typical (Tower as Seprate Project).Second Schedule} {!Schedule-Typical (Tower as Seprate Project).Third Schedule} {!Schedule-Typical (Tower as Seprate Project).Fourth Schedule} {!Schedule-Typical (Tower as Seprate Project).Fifth Schedule}';
        dt.Clause_6__c = '{!Schedule-Penthouse.First Schedule} {!Schedule-Penthouse.Second Schedule} {!Schedule-Penthouse.Third Schedule} {!Schedule-Penthouse.Fourth Schedule} {!Schedule-Penthouse.Fifth Schedule}';
        dt.Clause_7__c = '{!Property__c.Name} {!Tower__c.Name} {!opportunity.Name} {!Account.Name} {!Quotation__c.Name} {!Project__c.Name} {!Schedule-Duplex.Fifth Schedule}';
        //insert dt;
        
        Document_Template__c dt1 = new Document_Template__c();
        dt1.Name = 'Agreement Form';
        dt1.Document_Type__c = 'Agreement Form';
        dt1.Project__c = projectId; 
        dt1.Clause_0__c = '{!Booking__c.Booking_Date__c} {!Applicant__c.Salutation__c} {!Applicant__c.Name} {!olDecimal.sOLDecimal} {!olDecimal.eOLDecimal} {!olDecimal.sDecimalList} {!olDecimal.eDecimalList} {!p.pStart} {!p.pEnd} {!ol.sOL} {!ol.eOL} {!ol.sLId} {!ol.eLId} {!ol.sLIa} {!ol.eLIa} {!ol.sLIUA} {!ol.eLIUA} {!ol.sLIr} {!ol.eLIr} {!Table.TableStart} {!Table.TableEnd} {!Table.TRowStart} {!Table.TRowEnd} {!Table.TCellStart} {!Table.TCellEnd} {!Table.THeaderStart} {!Table.THeaderEnd}';
        dt1.Clause_1__c = '{!OtherApplicantDetails.Second Applicant Salutation} {!OtherApplicantDetails.Third Applicant Salutation} {!OtherApplicantDetails.Fourth Applicant Salutation} {!OtherApplicantDetails.Fifth Applicant Salutation} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures} {!ReferenceNo.refno} {!FloorNo.FloorNo}';
        dt1.Clause_2__c = '{!OtherApplicantDetails.Second Applicant Name} {!OtherApplicantDetails.Third Applicant Name} {!OtherApplicantDetails.Fourth Applicant Name} {!OtherApplicantDetails.Fifth Applicant Name} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures}';
        dt1.Clause_3__c = '{!Schedule-Bare Shell.First Schedule} {!Schedule-Bare Shell.Second Schedule} {!Schedule-Bare Shell.Third Schedule} {!Schedule-Bare Shell.Fourth Schedule} {!Schedule-Bare Shell.Fifth Schedule}';
        dt1.Clause_4__c = '{!Schedule-Typical(Multi Tower Project).First Schedule} {!Schedule-Typical(Multi Tower Project).Second Schedule} {!Schedule-Typical(Multi Tower Project).Third Schedule} {!Schedule-Typical(Multi Tower Project).Fourth Schedule} {!Schedule-Typical(Multi Tower Project).Fifth Schedule}';
        dt1.Clause_5__c = '{!Schedule-Typical (Tower as Seprate Project).First Schedule} {!Schedule-Typical (Tower as Seprate Project).Second Schedule} {!Schedule-Typical (Tower as Seprate Project).Third Schedule} {!Schedule-Typical (Tower as Seprate Project).Fourth Schedule} {!Schedule-Typical (Tower as Seprate Project).Fifth Schedule}';
        dt1.Clause_6__c = '{!Schedule-Penthouse.First Schedule} {!Schedule-Penthouse.Second Schedule} {!Schedule-Penthouse.Third Schedule} {!Schedule-Penthouse.Fourth Schedule} {!Schedule-Penthouse.Fifth Schedule}';
        dt1.Clause_7__c = '{!Property__c.Name} {!Tower__c.Name} {!opportunity.Name} {!Account.Name} {!Quotation__c.Name} {!Project__c.Name} {!Schedule-Duplex.Fifth Schedule}';
        //insert dt;
        
        Document_Template__c dt2 = new Document_Template__c();
        dt2.Name = 'Allotment Form';
        dt2.Document_Type__c = 'Allotment Form';
        dt2.Project__c = projectId; 
        dt2.Clause_0__c = '{!Booking__c.Booking_Date__c} {!Applicant__c.Salutation__c} {!Applicant__c.Name} {!olDecimal.sOLDecimal} {!olDecimal.eOLDecimal} {!olDecimal.sDecimalList} {!olDecimal.eDecimalList} {!p.pStart} {!p.pEnd} {!ol.sOL} {!ol.eOL} {!ol.sLId} {!ol.eLId} {!ol.sLIa} {!ol.eLIa} {!ol.sLIUA} {!ol.eLIUA} {!ol.sLIr} {!ol.eLIr} {!Table.TableStart} {!Table.TableEnd} {!Table.TRowStart} {!Table.TRowEnd} {!Table.TCellStart} {!Table.TCellEnd} {!Table.THeaderStart} {!Table.THeaderEnd}';
        dt1.Clause_1__c = '{!OtherApplicantDetails.Second Applicant Salutation} {!OtherApplicantDetails.Third Applicant Salutation} {!OtherApplicantDetails.Fourth Applicant Salutation} {!OtherApplicantDetails.Fifth Applicant Salutation} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures} {!ReferenceNo.refno} {!FloorNo.FloorNo}';
        dt1.Clause_2__c = '{!OtherApplicantDetails.Second Applicant Name} {!OtherApplicantDetails.Third Applicant Name} {!OtherApplicantDetails.Fourth Applicant Name} {!OtherApplicantDetails.Fifth Applicant Name} {!AllApplicantDetails.All Applicant Names} {!AllApplicantDetails.All Applicant Signatures}';
        dt1.Clause_3__c = '{!Schedule-Bare Shell.First Schedule} {!Schedule-Bare Shell.Second Schedule} {!Schedule-Bare Shell.Third Schedule} {!Schedule-Bare Shell.Fourth Schedule} {!Schedule-Bare Shell.Fifth Schedule}';
        dt1.Clause_4__c = '{!Schedule-Typical(Multi Tower Project).First Schedule} {!Schedule-Typical(Multi Tower Project).Second Schedule} {!Schedule-Typical(Multi Tower Project).Third Schedule} {!Schedule-Typical(Multi Tower Project).Fourth Schedule} {!Schedule-Typical(Multi Tower Project).Fifth Schedule}';
        dt1.Clause_5__c = '{!Schedule-Typical (Tower as Seprate Project).First Schedule} {!Schedule-Typical (Tower as Seprate Project).Second Schedule} {!Schedule-Typical (Tower as Seprate Project).Third Schedule} {!Schedule-Typical (Tower as Seprate Project).Fourth Schedule} {!Schedule-Typical (Tower as Seprate Project).Fifth Schedule}';
        dt1.Clause_6__c = '{!Schedule-Penthouse.First Schedule} {!Schedule-Penthouse.Second Schedule} {!Schedule-Penthouse.Third Schedule} {!Schedule-Penthouse.Fourth Schedule} {!Schedule-Penthouse.Fifth Schedule}';
        dt1.Clause_7__c = '{!Property__c.Name} {!Tower__c.Name} {!opportunity.Name} {!Account.Name} {!Quotation__c.Name} {!Project__c.Name} {!Schedule-Duplex.Fifth Schedule}';
        
        
        
        PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', opp.Id);
        
        
        string othercharges_serialize = '[]';//JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
        
        string sap_serialize = JSON.serialize(SAPChrges);
        
        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        
        string discountList_serialize = '[]'; // = JSON.serialize(discountList);
        string carParKList = '[]'; //= '["TANDEM",1,100000]'; 
        string fieldSet = '[{"label":"unitId","value":"' + unitId +'"},{"label":"editschedule","value":false},{"label":"oppId","value":"' + opp.id +'"},{"label":"additionalComments","value":""},{"label":"selectedPlan","value":"' + planId + '"},{"label":"changeInSource","value":false},{"label":"revisedBookingSource","value":null},{"label":"referredBy","value":null},{"label":"referProject","value":null},{"label":"referTower","value":null},{"label":"referFlat","value":null},{"label":"referEmpCode","value":null}]';
        string qId = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
        string st1 = QuotationManagmentServices.INFormat(10);
        
        Booking__c b = new Booking__C();
        b.Opportunity__c = opp.id;
        b.Booking_Date__c = system.today();
        b.Acceptance_Form_Template__c = 'Acceptance_Form';
        b.Agreement_Form_Template__c = 'Agreement_Form';
        b.Allotment_Form_Template__c = 'Allotment_Form';
        
        
        b.Status__c = 'Booking In Process';
        
        if(qId!=null){
            if(qId.contains(',')){
                qId = qId.substring(0, qId.lastIndexOf(','));
            }
            b.Quotation__c = qId;  
        }
        b.Default_Address_of__c = '1st Applicant';
        b.Project__c = projectId;
        b.Tower__c = towerId;
        b.Property__c = unitId;
        insert b;
        
        List<Applicant__c> aplist = new List<Applicant__c>();
        Applicant__c ap = new Applicant__c();
        ap.Booking__C = b.id;
        ap.Applicant_Number__c = 'Primary Applicant';
        ap.Opportunity__c = opp.id;
        ap.Type_Of_Applicant__c = 'Individual Buyer';
        ap.PancardNo__c = 'ABCDE1234E';
        ap.Salutation__c = 'Capt.';
        ap.Applicant_Type__c = 'Primary';
        ap.Name = 'Primary Applicant';
        ap.Mobile_Number__c = '1234567890';
        ap.Nationality__c = 'Indian';
        ap.Subtype_Of_Applicant__c = 'Indian National';
        ap.Mailing_Address_same_as_PermanentAddress__c = true;
        ap.House_No__c = 'House';
        ap.Street_1__c = 'Street1';
        ap.Street_2__c = 'Street2';
        ap.City__c = 'Mumbai';
        insert ap;
        aplist.add(ap);
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Booking__C = b.id;
        ap2.Applicant_Number__c = 'Second Applicant';
        ap2.Opportunity__c = opp.id;
        ap2.Type_Of_Applicant__c = 'Individual Buyer';
        ap2.PancardNo__c = 'ABCDE1234E';
        ap2.Salutation__c = 'Capt.';
        ap2.Applicant_Type__c = 'Second';
        ap2.Name = 'Second Applicant';
        ap2.Mobile_Number__c = '1234567890';
        ap2.Nationality__c = 'Indian';
        ap2.Subtype_Of_Applicant__c = 'Indian National';
        ap2.Mailing_Address_same_as_PermanentAddress__c = true;
        ap2.House_No__c = 'House';
        ap2.Street_1__c = 'Street1';
        ap2.Street_2__c = 'Street2';
        ap2.City__c = 'Mumbai';
        insert ap2;
        aplist.add(ap2);
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Booking__C = b.id;
        ap3.Applicant_Number__c = 'Third Applicant';
        ap3.Opportunity__c = opp.id;
        ap3.Type_Of_Applicant__c = 'Individual Buyer';
        ap3.PancardNo__c = 'ABCDE1234E';
        ap3.Salutation__c = 'Capt.';
        ap3.Applicant_Type__c = 'Third';
        ap3.Name = 'Third Applicant';
        ap3.Mobile_Number__c = '1234567890';
        ap3.Nationality__c = 'Indian';
        ap3.Subtype_Of_Applicant__c = 'Indian National';
        ap3.Mailing_Address_same_as_PermanentAddress__c = true;
        ap3.House_No__c = 'House';
        ap3.Street_1__c = 'Street1';
        ap3.Street_2__c = 'Street2';
        ap3.City__c = 'Mumbai';
        insert ap3;
        aplist.add(ap3);
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Booking__C = b.id;
        ap4.Applicant_Number__c = 'Fourth Applicant';
        ap4.Opportunity__c = opp.id;
        ap4.Type_Of_Applicant__c = 'Individual Buyer';
        ap4.PancardNo__c = 'ABCDE1234E';
        ap4.Salutation__c = 'Capt.';
        ap4.Applicant_Type__c = 'Fourth';
        ap4.Name = 'Fourth Applicant';
        ap4.Mobile_Number__c = '1234567890';
        ap4.Nationality__c = 'Indian';
        ap4.Subtype_Of_Applicant__c = 'Indian National';
        ap4.Mailing_Address_same_as_PermanentAddress__c = true;
        ap4.House_No__c = 'House';
        ap4.Street_1__c = 'Street1';
        ap4.Street_2__c = 'Street2';
        ap4.City__c = 'Mumbai';
        insert ap4;
        aplist.add(ap4);
        Applicant__c ap5 = new Applicant__c();
        ap5.Booking__C = b.id;
        ap5.Applicant_Number__c = 'Fifth Applicant';
        ap5.Opportunity__c = opp.id;
        ap5.Type_Of_Applicant__c = 'Individual Buyer';
        ap5.PancardNo__c = 'ABCDE1234E';
        ap5.Salutation__c = 'Capt.';
        ap5.Applicant_Type__c = 'Fifth';
        ap5.Name = 'Fifth Applicant';
        ap5.Mobile_Number__c = '1234567890';
        ap5.Nationality__c = 'Indian';
        ap5.Subtype_Of_Applicant__c = 'Indian National';
        ap5.Mailing_Address_same_as_PermanentAddress__c = true;
        ap5.House_No__c = 'House';
        ap5.Street_1__c = 'Street1';
        ap5.Street_2__c = 'Street2';
        ap5.City__c = 'Mumbai';
        insert ap5;
        aplist.add(ap5);
        
        opportunity opr = new Opportunity();
        opr.id = opp.id;
        opr.Booking__c = b.id;
        opr.Property__c = unitId;
        opr.project__c = projectId;
        update opr;
        
        Property__c pr = new Property__c();
        pr.id = unitId;
        pr.status__C = 'Booked';
        pr.Tower__c=towerId;
        update pr;
        
        opp.Property__c=pr.id;
        update opp;
        Test.StartTest();
        PageReference pageRef2 = Page.DocumentUploadPage;
        Test.setCurrentPage(pageRef2);
        //pageRef2.getParameters().put('id', dt.id);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(dt);
        DocumentUpload ts = new DocumentUpload(sc2);
        //ts.selectedObject = 'UnitCost';
        //ts.prepareFieldList();
        ts.selectedObject = 'OtherApplicantDetails';
        ts.prepareFieldList();
        ts.selectedObject = 'AllApplicantDetails';
        ts.prepareFieldList();
        ts.selectedObject = 'Schedule-Typical(Multi Tower Project)';
        ts.prepareFieldList();
        ts.selectedObject = 'Schedule-Typical (Tower as Seprate Project)';
        ts.prepareFieldList();
        ts.selectedObject = 'Schedule-Duplex';
        ts.prepareFieldList();
        ts.selectedObject = 'Schedule-Penthouse';
        ts.prepareFieldList(); 
        ts.selectedObject = 'Schedule-Bare Shell';
        ts.prepareFieldList(); 
        ts.selectedObject = 'SeventhTable1';
        ts.prepareFieldList();
        ts.selectedObject = 'Morgage NOC';
        ts.prepareFieldList();
        ts.selectedObject = 'Contact Details Update';
        ts.prepareFieldList();
        ts.selectedObject = 'Possesion';
        ts.prepareFieldList();
        ts.selectedObject = 'PageBreak';
        ts.preparemergefield();
        ts.selectedObject = 'Justify';
        ts.preparemergefield();
        ts.selectedObject = 'lineBreak';
        ts.preparemergefield();
        ts.selectedObject = 'ol';
        ts.preparemergefield();
        ts.selectedObject = 'olDecimal';
        ts.preparemergefield();
        ts.selectedObject = 'p';
        ts.preparemergefield();
        ts.selectedObject = 'Id';
        ts.preparemergefield();
        ts.save();
        ts.saveAndPriview();
        ts.addRow();
        
        PageReference pRef3 = Page.GenerateCustomerDocument;
        Test.setCurrentPage(pRef3);
        //ApexPages.currentPage().getParameters().put('oppId',oppId);
        GenerateCustomerDocument gd = new GenerateCustomerDocument();
        List<SelectOption> projectList = gd.getProjects;
        gd.selectedVal = projectId;
        //List<SelectOption> clusterList = gd.getClusterNames ;
        //gd.SelectedClusterId = clusterId;
        List<SelectOption> towerList = gd.getTowers ;
        gd.selectedTower = towerId;
        List<SelectOption> docList = gd.getDocumentNames;         
        gd.selectedDocument = 'Acceptance Form'; 
        gd.checkInput();
        gd.CustomerListNew();
        gd.customerList[0].selected = true;
        gd.generateDocument();
        gd.getDisablePrevious();
        gd.getDisableNext();
        gd.getTotal_size();
        gd.getPageNumber();
        gd.getTotalPages();
        gd.getNextCustomers();
        gd.projectchange();
        gd.towerchange();
        gd.documentchange();
        GenerateCustomerDocument.dummy();
        DocumentGenerationServices.dummy();
        
        
        
        
        PageReference pRef4 = Page.View_Document;
        Test.setCurrentPage(pRef4);
        ApexPages.currentPage().getParameters().put('oppId',opp.Id);
        ApexPages.currentPage().getParameters().put('docType','Acceptance Form'); 
        ApexPages.currentPage().getParameters().put('docName','Acceptance Form');
        ViewDocument adf = new ViewDocument();
        PaginationController.PaginationWrapper pc = new PaginationController.PaginationWrapper(10,10,10);
        PaginationController.Beginning(pc);
        PaginationController.Previous(pc);
        PaginationController.Next(pc);
        PaginationController.End(pc);
        
        PageReference pRef5 = Page.View_Document;
        Test.setCurrentPage(pRef5);
        ApexPages.currentPage().getParameters().put('oppId',opp.Id);
        ApexPages.currentPage().getParameters().put('docType','Agreement Form'); 
        ApexPages.currentPage().getParameters().put('docName','Agreement Form');
        ViewDocument adf1 = new ViewDocument();
        PaginationController.PaginationWrapper pc1 = new PaginationController.PaginationWrapper(10,10,10);
        PaginationController.Beginning(pc1);
        PaginationController.Previous(pc1);
        PaginationController.Next(pc1);
        PaginationController.End(pc1);
        Test.StopTest();
        
        String str = DocumentGenerationServices.getAllApplicantAllotmentSignature(aplist,'test');
        Map<string, string> relatedMap = DocumentGenerationServices.generateDocumentMethod('Agreement Form',opp);
        List<Related_Document_History__c> rlist = new List<Related_Document_History__c>();
        Related_Document_History__c r;
        for(String rid:relatedMap.keySet()){
            if(rid!=null){
                r = new Related_Document_History__c();
                r.id = rid;
                r.Submitted_for_Approval__c=true;
                rlist.add(r);
            }
        }
        if(!rlist.isEmpty()){
            update rlist;         
        }
        //  DocumentGenerationServices.generateDocumentMethod('NRI Declaration Form',opp);
        //  DocumentGenerationServices.generateDocumentMethod('Mortgage Release Request Letter',opp);
        // DocumentGenerationServices.generateDocumentMethod('Agreement signing undertaking',opp);
        // DocumentGenerationServices.generateDocumentMethod('Annexure B - Nomination Form',opp);
        //  DocumentGenerationServices.generateDocumentMethod('TPA',opp);
        
        //system.debug('str='+str);
        //DocumentGenerationServices dgs = new DocumentGenerationServices(); 
        //string aaa = dgs.getSeventhScheduleDetails(b,q,p,ap,t,'SeventhTable1');
        DocumentUpload dc = new DocumentUpload();
        
        Contentversion cv = new Contentversion();
        cv.Title = 'ABC';
        cv.PathOnClient = 'test';
        cv.isDocGen__c = true;
        cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.urlEncode('Unit Test Attachment Body','UTF-8'));
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = rlist[0].id; // <----- put your record id here, example: an account tid
        cdl.ShareType = 'V';
        insert cdl;
        
        if(!rlist.isEmpty()){
            for(Related_Document_History__c r2:rlist){
                r2.Document_Approved__c = false;
                r2.Document_Rejected__c= true;
            }
            update rlist;
        } 
        
        PageReference vfiles2 = Page.ViewFilesComponent;
        Test.setCurrentPage(vfiles2);
        vfiles2.getParameters().put('id', rlist[0].id);
        ViewFilesComponentController ts5 = new ViewFilesComponentController();
        ts5.refreshView();    
        
        
        // }
        
    }  
}