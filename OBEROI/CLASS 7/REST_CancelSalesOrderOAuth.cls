@RestResource(urlMapping='/SAP_Integration/CancelSalesOrder/*')
global class REST_CancelSalesOrderOAuth{
    @HttpPOST
    global static REST_result CancelSalesOrderOAuth(String SO_NO,String CUST_NO,String REASON_CODE,String REASON_DES,Date CANCEL_DATE,String CANCEL_NO){
        REST_result r=new REST_result();
        List<Booking__c> booklist = new List<Booking__c>();
        List<Booking__c> bookListToUpdate = new List<Booking__c>();
        List<opportunity> opplist = new List<opportunity>();
        List<opportunity> oppListToUpdate = new List<opportunity>();
        List<Property__c> Unitlist = new List<Property__c>();
        List<Property__c> UnitListToUpdate = new List<Property__c>();
        id OppId ;
        id unitId ;
        id quoteid;
        Set<String> invNo = new Set<String>();
        
        
        if(String.isBlank(SO_NO) || String.isBlank(CUST_NO)){
            Responce re = new Responce();
            re.returnCode =1;
            re.message='ALL REQUIRED PARAMETERS ARE NOT POPULATED(SO_NO/CUST_NO)';
            r.ResponceList.add(re);
        }else{
            booklist = [select id,name,Customer_Code__c,Opportunity__c,Quotation__c,Property__c,Sales_Document_SAP__c,Status__c,
                        Quotation__r.TotalAdditionalCarpark__c,Quotation__r.Total_Earmarked_Parking__c FROM Booking__c WHERE Customer_Code__c =: CUST_NO AND Sales_Document_SAP__c =: SO_NO Limit 1];
            
            if(booklist.size()>0){
                if(booklist[0].Status__c == 'Cancelled'){
                    Responce re = new Responce();
                    re.returnCode = 4;
                    re.message='Booking With SalesOrder No - '+SO_NO +' Has Been Already Cancled';
                    r.ResponceList.add(re);
                }
                Else{           
                    OppId = booklist[0].Opportunity__c;
                    unitId = booklist[0].Property__c;
                    quoteid = booklist[0].Quotation__c;
                    booklist[0].Status__c = 'Cancelled';
                    booklist[0].Booking_Cancellation_Code__c = REASON_CODE;
                    booklist[0].Booking_Cancellation_Reason__c = REASON_DES;
                    booklist[0].Booking_Cancel_Date__c = CANCEL_DATE;
                    booklist[0].Cancellation_Order_No__c = CANCEL_NO;
                    bookListToUpdate.add(booklist[0]);
                    
                    opplist = [select id,name,StageName,Property__c FROM Opportunity Where id =: OppId];
                    Unitlist = [select id,name,Booking__c,Status__c,Allotted__c,Customers__c FROM Property__c Where id =: unitId];
                    
                    if(opplist.size()>0){
                        opplist[0].StageName = 'Cancelled';
                        opplist[0].Property__c = null;
                        oppListToUpdate.add(opplist[0]);
                    }
                    if(Unitlist.size()>0){
                        Unitlist[0].Booking__c = Null;
                        Unitlist[0].Status__c = 'Available';
                        Unitlist[0].Customers__c = Null;
                        UnitListToUpdate.add(Unitlist[0]);
                    }
                    
                    Update bookListToUpdate;
                    Update oppListToUpdate;
                    Update UnitListToUpdate;
                    
                    if(((booklist[0].Quotation__r.TotalAdditionalCarpark__c)+(booklist[0].Quotation__r.Total_Earmarked_Parking__c))>0){
                        system.debug('Total car parks ;;;;;;;;;;;;;;; '+((booklist[0].Quotation__r.TotalAdditionalCarpark__c)+(booklist[0].Quotation__r.Total_Earmarked_Parking__c)));
                        
                        releaseCarParks(quoteid);
                    }else{                    }
                    
                    SyncQuote(quoteid);
                    
                    Responce re = new Responce();
                    re.returnCode = 2;
                    re.message='Booking With SalesOrder No - '+SO_NO +' Has Been Cancelled';
                    r.ResponceList.add(re);
                }
            }
            Else{
                Responce re = new Responce();
                re.returnCode = 3;
                re.message='Booking With SalesOrder No - '+SO_NO+', & Customer No '+CUST_NO+' Was Not found';
                r.ResponceList.add(re);
            }
        }
        //update SSDListToUpdate;
        return r;
    }
    
    global class REST_result {
        webservice List<Responce> ResponceList;
        global Rest_result(){
            ResponceList = new List<Responce>();
        }
    } 
    global class Responce{
        webservice Integer returnCode;
        webservice String message;
    } 
    
    global class CancelSalesOrder{
        Public String SO_NO;
        Public String CUST_NO;
        Public String REASON_CODE;
        Public String REASON_DES;
        Public Date CANCEL_DATE;
    }
    
    Global static void releaseCarParks(String Qid){
        List <Car_Parking__c>  ParkingListToUpdate = new List <Car_Parking__c>();
        List <Quotation__c> QuoteDetails  = new List <Quotation__c>();
        Map<string,decimal>additionalParkingMap = new Map<string,decimal>();
        Map<string,decimal> earMarkedParkingMap = new Map<string,decimal>();
        Map<string,List<Car_Parking__c>> addAvailableParkingMap = new Map<string,List<Car_Parking__c>>();
        Map<string,List<Car_Parking__c>> earAvailableParkingMap = new Map<string,List<Car_Parking__c>>();
        
        if (Qid != null){
            QuoteDetails = [SELECT id,Name,Booking__c,Booking__r.Legacy_Booking__c, Property__r.Project_Name__c,Property__r.Carpet_Area__c,Project__c,
                            Property__c ,Property__r.Property_Type__r.Description__c,Property__r.Material_No__c, Token_Amount_r__c,Token_Amount__c, ST_Token_Amount__c,Property__r.Tower__c ,Property__r.Tower__r.Tower_Name__c,
                            Property__r.Property_Type__r.Name__c,Property__r.Tower__r.name,Property__r.Unit_Type__c,Property__r.Floor_No__c,Property__r.name,Car_Park_Type_1__c,Car_Park_Type_2__c,Car_Park_Type_3__c,Car_Park_Type_4__c,Car_Park_Type_5__c, 
                            TotalAdditionalCarpark__c,Car_Park_Count_1__c,Property__r.Project_name__r.Site__c,Car_Park_Count_2__c,Total_Agreement_Value_Modified__c,Property__r.Floor__c,Car_Park_Count_3__c,Car_Park_Count_4__c,Car_Park_Count_5__c,
                            Earmarked_Car_Parking_Type_1__c, Earmarked_Car_Parking_Type_2__c, Earmarked_Car_Parking_Type_3__c, Earmarked_Car_Parking_Type_4__c, Earmarked_Car_Parking_Type_5__c,
                            Earmarked_Car_Parking_Count_1__c, Earmarked_Car_Parking_Count_2__c, Earmarked_Car_Parking_Count_3__c, Earmarked_Car_Parking_Count_4__c, Earmarked_Car_Parking_Count_5__c,
                            Total_Earmarked_Parking__c
                            FROM Quotation__c WHERE Id = : Qid]; //AND Booking__r.Legacy_Booking__c != True
            if (QuoteDetails.size() > 0){
                for(integer i=1;i<=5;i++){
                    string additionalCarParkName = (string)(QuoteDetails[0].get('Car_Park_Type_' + i + '__c'));
                    decimal additionalCarParkCount = (Decimal)(QuoteDetails[0].get('Car_Park_Count_' + i + '__c'));
                    
                    string earMarkedCarParkName = (string)(QuoteDetails[0].get('Earmarked_Car_Parking_Type_' + i + '__c'));
                    decimal earMarkedCarParkCount = (Decimal)(QuoteDetails[0].get('Earmarked_Car_Parking_Count_' + i + '__c'));
                    if(string.isNotBlank(additionalCarParkName) && additionalCarParkCount != null && additionalCarParkCount > 0){
                        additionalParkingMap.put(additionalCarParkName, additionalCarParkCount);
                    }
                    if(string.isNotBlank(earMarkedCarParkName) && earMarkedCarParkCount != null && earMarkedCarParkCount > 0){
                        earMarkedParkingMap.put(earMarkedCarParkName, earMarkedCarParkCount);
                    }
                }
                List<Car_Parking__c> carParking_List = [select id,Status__c,Name,Type__c From Car_Parking__c where  Status__c =: 'Allotted' and Project__c =: QuoteDetails[0].Project__c and Additional_Earmarked__c = 'Additional'];
                List<Car_Parking__c> carParking_List2 = [select id,Status__c,Name,Type__c From Car_Parking__c where  Status__c =: 'Allotted' and Project__c =: QuoteDetails[0].Project__c and Additional_Earmarked__c = 'Earmarked'];
                
                if(carParking_List != null && !carParking_List.isEmpty()){
                    for(Car_Parking__c cp : carParking_List){
                        if(addAvailableParkingMap.containsKey(cp.Type__c)){
                            List<Car_Parking__c> cc = addAvailableParkingMap.get(cp.Type__c);
                            cc.add(cp);
                            addAvailableParkingMap.put(cp.Type__c,cc);
                        }else{
                            List<Car_Parking__c> cc = new List<Car_Parking__c>();
                            cc.add(cp);
                            addAvailableParkingMap.put(cp.Type__c,cc);
                        }
                    }
                }
                if(carParking_List2 != null && !carParking_List2.isEmpty()){
                    for(Car_Parking__c cp : carParking_List2){
                        if(earAvailableParkingMap.containsKey(cp.Type__c)){
                            List<Car_Parking__c> cc = earAvailableParkingMap.get(cp.Type__c);
                            cc.add(cp);
                            earAvailableParkingMap.put(cp.Type__c,cc);
                        }else{
                            List<Car_Parking__c> cc = new List<Car_Parking__c>();
                            cc.add(cp);
                            earAvailableParkingMap.put(cp.Type__c,cc);
                        }
                    }
                }
                
                system.debug('additionalParkingMap: '+additionalParkingMap);
                system.debug('earMarkedParkingMap: '+earMarkedParkingMap);
                system.debug('addAvailableParkingMap: '+addAvailableParkingMap);
                system.debug('earAvailableParkingMap: '+earAvailableParkingMap);
                
                //Updating Parkings/////
                if(!additionalParkingMap.isEmpty()){                    
                    for(string st : additionalParkingMap.keyset()){
                        Integer s = Integer.valueOf(additionalParkingMap.get(st));
                        system.debug('Ast::'+st);
                        system.debug('addAvailableParkingMap.get(st):: '+addAvailableParkingMap.get(st));
                        for(Integer r=0; r<s; r++){
                            addAvailableParkingMap.get(st)[r].Status__c = 'Available'; 
                            ParkingListToUpdate.add(addAvailableParkingMap.get(st)[r]);
                        }
                    }
                }
                
                if(!earMarkedParkingMap.isEmpty()){
                    for(string st : earMarkedParkingMap.keyset()){
                        Integer s = Integer.valueOf(earMarkedParkingMap.get(st));
                        system.debug('s::'+s);
                        system.debug('est::'+st);
                        system.debug('earAvailableParkingMap.get(st):: '+earAvailableParkingMap.get(st));
                        for(Integer r=0; r<s; r++){
                            earAvailableParkingMap.get(st)[r].Status__c = 'Available'; 
                            ParkingListToUpdate.add(earAvailableParkingMap.get(st)[r]);
                        }
                    }
                }
                
                if(ParkingListToUpdate.size() > 0){
                    update ParkingListToUpdate;
                }                    
            }
        }
    }
    
    @future(Callout = True)
    Global static void SyncQuote(String Qid){
        List<Quotation__c> qList = New List<Quotation__c>();
        List<JSON2ApexSyncPaymentPlan.BILLING_PLAN> BpList = New List<JSON2ApexSyncPaymentPlan.BILLING_PLAN>();
        String soCode='';
        list<Quotation_Billing_Line_Item__c> QLI_List = NEW list<Quotation_Billing_Line_Item__c> ();
        list<Quotation_Billing_Line_Item__c> QliToUpdate = New list<Quotation_Billing_Line_Item__c>();
        
        qList = [Select id,Name,Booking__c,Booking__r.Sales_Document_SAP__c FROM Quotation__c WHERE id =: Qid];
        if(qList[0].Booking__c != null){
            soCode = qList[0].Booking__r.Sales_Document_SAP__c;
            Rest_SAP_SyncPaymentPlan ssoc = new Rest_SAP_SyncPaymentPlan();
            BpList = ssoc.createSalesOrder(soCode);
            //BpList.sort();
            System.debug('In Main class'+BpList);
            QLI_List = [Select id,name,Terms_of_Payment_Key__c,Quotation__c,Is_Milestone_Billed__c FROM Quotation_Billing_Line_Item__c WHERE Quotation__c =: qid];
        }
        
        if(BpList.size()>0){
            For(JSON2ApexSyncPaymentPlan.BILLING_PLAN bp : BpList){
                if(QLI_List.size()>0){
                    For(Quotation_Billing_Line_Item__c QLI : QLI_List){
                        If(bp.ZTERM == QLI.Terms_of_Payment_Key__c){
                            System.debug('zterm in for '+bp.ZTERM);
                            System.debug('bp cha FKSAF in for '+bp.FKSAF);
                            if(bp.FKSAF =='C'){
                                System.debug('bp cha FKSAF in if '+bp.FKSAF);
                                QLI.Is_Milestone_Billed__c = True;
                                QliToUpdate.add(QLI);
                            }Else{
                            }
                        }
                    }
                }
            }
        }
        System.debug('QliToUpdate Chi size:::'+QliToUpdate);
        
        If(QliToUpdate.size()>0){
            Update QliToUpdate;
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Quotation Line Items updated sucessfully.');
            ApexPages.addMessage(myMsg1);
        }
    }
}