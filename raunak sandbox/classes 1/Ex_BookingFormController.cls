public class Ex_BookingFormController {
	public id bkId {get;set;}
    public id qId {get;set;}
    public Id unitID {get;set;}
    public string objectName {get;set;}
    public List<Applicant__c> lstApp {get;set;}
    public List<Booking__c> lstBk {get;set;}
    public List<Receipt__c> lstRc {get;set;}
    public List<Quotation__c> lstQt {get;set;}
    public List<Opportunity_c__c> lstOpp {get;set;}
    public List<Payment_Milestone__c> lstPSM {get;set;}
    public List<Unit__c> lstUnit {get;set;}
    public List<Payment_Milestone__c> lstBL {get;set;}
    public Decimal totalAmount {get;set;}
    public List<Business_Account__c> lstBA {get;set;}
    public List<paymentSchedule> pswList {get;set;}
    public List<Charge_Detail__c> lstCD {get;set;}
    public List<Car_Park__c	> lstCP {get;set;}
    public decimal totalCost {get;set;}
    public decimal totalTokenFlatCost {get;set;}
    public decimal totalTokenTax {get;set;}
    public Decimal totalBillAV {get;set;}
    public Decimal totalBillPercentage {get;set;}
    public Decimal psmlist {get;set;}
    public string strpsmlist {get;set;}
    public string strtotalTokenFlatCost {get;set;}
    public string strtotalTokenTax {get;set;}
    public string chequeNumbers {get;set;}
    public string taxchequeNumbers {get;set;}
    public string rcDate {get;set;}
    public string taxrcDate {get;set;}
    public string bankName {get;set;}
    public string branchName {get;set;}
    public string avInWords {get;set;}
    public string stInWords {get;set;}
    public string fav {get;set;}
    public string unitName {get;set;}
    public string gstFav{get;set;}
    public string reraNumber {get;set;}
    public List<Receipt__c> lstFCRC {get;set;}
    public List<Receipt__c> lstTxRc {get;set;}
    public string apname {get;set;}
    public string bankNames {get;set;}
    public string strtotalAmount {get;set;}
    public Ex_BookingFormController()
    {
        bkid = ApexPages.currentPage().getParameters().get('bid');
        qId = ApexPages.currentPage().getParameters().get('qid');
        unitID = ApexPages.currentPage().getParameters().get('uid');
        system.debug(bkid +' '+qId+' '+ unitID);

        reraNumber = '';
        unitName = '';
        stInWords = '';
        bankName = '';
        branchName ='';
        apname = '';
        bankNames = '';
        fav = '';
        lstBl = new List<Payment_Milestone__c>();
        pswList = new List<paymentSchedule>();
        lstUnit = new List<Unit__c>();
        lstPSM = new List<Payment_Milestone__c>();
        gstFav = '';
        totalTokenFlatCost = 0;
        totalTokenTax = 0;
        totalBillAV = 0;
        psmlist = 0;
        totalBillPercentage = 0;
        totalAmount = 0;
        strtotalTokenFlatCost = '';
        strtotalTokenTax = '';
        chequeNumbers = '';
        taxchequeNumbers = '';
        rcDate = '';
        taxrcDate = '';
        strpsmlist = '';
        strtotalAmount = '';
        system.debug('Booking Id: '+bkid);
        objectName = bkId.getSObjectType().getDescribe().getName();
        lstFCRC = new List<Receipt__c>();
        lstTxRc = new List<Receipt__c>();
        lstCD = new List<Charge_Detail__c>();
        lstCP = new List<Car_Park__c>();	
      
        system.debug('Booking Id: '+bkid);

        lstApp = masterRecordController.returnApplicantDetails(bkId);
        lstBk = masterRecordController.returnBookingDetails(bkId);
        lstRc = masterRecordController.returnReceiptDetails(bkId);
        lstQt = masterRecordController.returnQuotationDetails(bkId);
        lstOpp = masterRecordController.returnOpportunityDetails(bkId);
        lstUnit = masterRecordController.returnUnitDetails(lstBk[0].Unit__c);
        lstBL = masterRecordController.returnBLDetails(lstBk[0].Quotation__c);
		lstCD = masterRecordController.returnChargeDetails(lstBk[0].Quotation__c);
        //qId = lstBk[0].Quotation__c;
        System.debug(lstBk);
        
        String[] types = new String[]{'Payment_Milestone__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
       lstCP = [select Id,Name,Booking__c,Amount__c,Status__c,Car_Park_Type__c,Project__c,RR_Amount__c,Tower__c,Type__c from Car_Park__c where 	Booking__c =: bkId]; 
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ',Construction_Stage__r.Stage_Description__c, Construction_Stage__r.Expected_Completion_Date__c, Construction_Stage__r.Actual_Completion_Date__c from Payment_Milestone__c Where Quotation__c = \''+qId+'\' ORDER BY Sequence_No__c'; 
        system.debug(soqlQuery);
        lstPSM = Database.query(soqlQuery);
        system.debug(lstPSM);
        system.debug(lstPSM.size());

        if(!lstPSM.isEmpty())
        {
            
            for(Payment_Milestone__c bl : lstPSM)
            {
                totalBillAV = totalBillAV + bl.Charge_Bucket_1_Amount__c;
                
                if(bl.Charge_Bucket_1_Percentage__c == Null)
                {
                    bl.Charge_Bucket_1_Percentage__c = 0;
                }
                totalBillPercentage = totalBillPercentage + bl.Charge_Bucket_1_Percentage__c;
                totalAmount = totalAmount + bl.Charge_Bucket_1_Amount__c;
                strtotalAmount = Ex_INFormat.INFormating(totalAmount);
                psmlist = lstPSM[0].Charge_Bucket_1_Amount__c;
                strpsmlist = Ex_INFormat.INFormating(psmlist);
                
                paymentSchedule psw = new paymentSchedule(bl.Milestone_Name__c, bl.Charge_Bucket_1_Percentage__c, bl.Charge_Bucket_1_Amount__c, bl.Charge_Bucket_1_Total_Tax__c);
                 pswList.add(psw);
                               
            }
        
        }
    }

    public class paymentSchedule
    {
        public String paymentMilestoneName {get;set;}
        public Decimal percentDue {get;set;}
        public String milestoneAmount {get;set;}
        public String milestoneGST {get;set;}

        public paymentSchedule(string paymentMilestoneName, Decimal percentDue, Decimal milestoneAmount, Decimal milestoneGST)
        {
            this.paymentMilestoneName = paymentMilestoneName;
            this.percentDue = percentDue;
            this.milestoneAmount = Ex_INFormat.INFormating(milestoneAmount);
            this.milestoneGST = Ex_INFormat.INFormating(milestoneGST);
        }
    }
    
}