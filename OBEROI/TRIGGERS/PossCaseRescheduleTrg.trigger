trigger PossCaseRescheduleTrg on Case (After Update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        List<Case> newCase = new List<Case>();
        Set<id> caseid = New Set<id>();
        for(Case c : Trigger.New){
            if((c.Type == 'Possession' || c.Type == 'Possession Rejected/Rescheduled') && c.Stage__c == 'Proceed with Possession'){ 
                if(c.Next_Action__c != trigger.oldmap.get(c.id).Next_Action__c && (c.Next_Action__c == 'Possession Rejected' || c.Next_Action__c == 'Possession Reschedule')){
                    Case newCa = new Case();
                    newCa.Type = 'Possession Rejected/Rescheduled';
                    newCa.Stage__c = 'Confirm Possession schedule';
                    newCa.Origin = c.Origin;
                    newCa.Subject = 'Possession Rejected/Rescheduled';
                    newCa.Status = 'Inprocess';
                    newCa.Priority = c.Priority;
                    newCa.OwnerId = c.OwnerId;
                    newCa.RecordTypeId = c.RecordTypeId;
                    newCa.Booking__c = c.Booking__c;
                    newCa.Request_received_date__c = c.Request_received_date__c;
                    newCa.Possession_request_raised_by_RM_date__c = c.Possession_request_raised_by_RM_date__c;
                    newCa.Possession_checklist_initiation_date__c = c.Possession_checklist_initiation_date__c;
                    newCa.Possession_Checklist_received_from_CS_L1__c = c.Possession_Checklist_received_from_CS_L1__c;
                    newCa.Possession_Checklist_cleared_by_CS_L2__c = c.Possession_Checklist_cleared_by_CS_L2__c;
                    newCa.Possession_Checklist_cleared_by_AR__c = c.Possession_Checklist_cleared_by_AR__c;
                    newCa.Possession_Scheduled_Date_1__c = c.Possession_Scheduled_Date_1__c;
                    newCa.Possession_Scheduled_Date_2__c = c.Possession_Scheduled_Date_2__c;
                    newCa.Possession_Scheduled_Date_3__c = c.Possession_Scheduled_Date_3__c;
                    newCa.Possession_Scheduled_Date_4__c = c.Possession_Scheduled_Date_4__c;
                    newCa.Possession_Scheduled_Date_5__c = c.Possession_Scheduled_Date_5__c;
                    newCase.add(newCa);
                    
                    caseid.add(c.id);
                    
                }
            }
        }
        insert newCase;
        
        List<Case> updateC = new List<Case>();
        for(Case ca : [select id,Status,Stage__c from Case where id in : caseid]){
            ca.Status = 'Closed';
            ca.Stage__c = 'Close';
            updateC.add(ca);
        }
        update updateC;
        
        List<Checklist__c> CheckListL = [select id,Name,Case__c,AFS_Registration_Done__c,All_dues_cleared__c,Penal_Interest_recovered_NA_Yes_No__c ,TDS_Certificates_received__c
                                        ,Factual_Details_in_L_L_NOC__c,Cheklist_from_AR_is_cleared__c,IOM_approval_required_Yes_No__c,Car_Park_Number_allotment__c,Electricity_Meter_details__c
                                        ,Key_Handover_Date__c,Customer_Feedback__c,Reason_for_rejection__c,Possession_Letter_cust_sign__c,Undertaking_cust_sign__c,Car_Park_Number_allotment_acknowledgemen__c
                                        ,Doc_handover_Checklist__c,Flat_Inspection_Form__c,Pendencies_Compliance_Yes_No_NA__c,Signed_by_POA_Yes_No_NA__c,POA_Compliance_Yes_No_NA__c,No_alteration_is_done__c
                                        ,Obtain_Customer_acknowledgement__c,Is_Checklist_Complete__c from Checklist__c where Case__c in : caseid];
        List<Checklist__c> ClistToinsert = new List<Checklist__c>();
        if(CheckListL.Size()>0){
            for(Checklist__c checkL : CheckListL){
                Checklist__c cl = new Checklist__c();
                cl.Case__c = newCase[0].id;
                cl.Recordtypeid = Schema.SObjectType.Checklist__C.getRecordTypeInfosByName().get('Possession').getRecordTypeId();
                cl.Name = newCase[0].Type;
                cl.AFS_Registration_Done__c = checkL.AFS_Registration_Done__c;
                cl.All_dues_cleared__c = checkL.All_dues_cleared__c;
                cl.Penal_Interest_recovered_NA_Yes_No__c = checkL.Penal_Interest_recovered_NA_Yes_No__c;
                cl.TDS_Certificates_received__c = checkL.TDS_Certificates_received__c;
                cl.Factual_Details_in_L_L_NOC__c = checkL.Factual_Details_in_L_L_NOC__c;
                cl.Cheklist_from_AR_is_cleared__c = checkL.Cheklist_from_AR_is_cleared__c;
                cl.IOM_approval_required_Yes_No__c = checkL.IOM_approval_required_Yes_No__c;
                cl.Car_Park_Number_allotment__c = checkL.Car_Park_Number_allotment__c;
                cl.Electricity_Meter_details__c = checkL.Electricity_Meter_details__c;
                cl.Key_Handover_Date__c = checkL.Key_Handover_Date__c;
                cl.Customer_Feedback__c = checkL.Customer_Feedback__c;
                cl.Reason_for_rejection__c = checkL.Reason_for_rejection__c;
                cl.Possession_Letter_cust_sign__c = checkL.Possession_Letter_cust_sign__c;
                cl.Undertaking_cust_sign__c = checkL.Undertaking_cust_sign__c;
                cl.Car_Park_Number_allotment_acknowledgemen__c = checkL.Car_Park_Number_allotment_acknowledgemen__c;
                cl.Doc_handover_Checklist__c = checkL.Doc_handover_Checklist__c;
                cl.Flat_Inspection_Form__c = checkL.Flat_Inspection_Form__c;
                cl.Pendencies_Compliance_Yes_No_NA__c = checkL.Pendencies_Compliance_Yes_No_NA__c;
                cl.Signed_by_POA_Yes_No_NA__c = checkL.Signed_by_POA_Yes_No_NA__c;
                cl.POA_Compliance_Yes_No_NA__c = checkL.POA_Compliance_Yes_No_NA__c;
                cl.No_alteration_is_done__c = checkL.No_alteration_is_done__c;
                cl.Obtain_Customer_acknowledgement__c = checkL.Obtain_Customer_acknowledgement__c;
                cl.Is_Checklist_Complete__c = checkL.Is_Checklist_Complete__c;
                
                ClistToinsert.add(cl);
                
            }
      }
        insert ClistToinsert;
    }

    if(Trigger.isAfter && Trigger.isUpdate){
       List<Case> clist = Trigger.New;
       Id Bookid = clist[0].Booking__c;
       List<Booking__c> updatebList = new List<Booking__c>();
       List<Booking__c> bList = [select id,Name,Possession_Schedule_Date_Time__c from Booking__c where id =: Bookid];
       
       if(bList.Size()>0){
           for(Case c : Trigger.New){
               if(c.Possession_Scheduled_Date_5__c != trigger.oldmap.get(c.id).Possession_Scheduled_Date_5__c && c.Possession_Scheduled_Date_5__c != Null){
                   bList[0].Possession_Schedule_Date_Time__c = c.Possession_Scheduled_Date_5__c;
               }else if(c.Possession_Scheduled_Date_4__c != trigger.oldmap.get(c.id).Possession_Scheduled_Date_4__c && c.Possession_Scheduled_Date_4__c != Null){
                   bList[0].Possession_Schedule_Date_Time__c = c.Possession_Scheduled_Date_4__c;
               }else if(c.Possession_Scheduled_Date_3__c != trigger.oldmap.get(c.id).Possession_Scheduled_Date_3__c && c.Possession_Scheduled_Date_3__c != Null){
                   bList[0].Possession_Schedule_Date_Time__c = c.Possession_Scheduled_Date_3__c;
               }else if(c.Possession_Scheduled_Date_2__c != trigger.oldmap.get(c.id).Possession_Scheduled_Date_2__c && c.Possession_Scheduled_Date_2__c != Null){
                   bList[0].Possession_Schedule_Date_Time__c = c.Possession_Scheduled_Date_2__c;
               }else if(c.Possession_Scheduled_Date_1__c != trigger.oldmap.get(c.id).Possession_Scheduled_Date_1__c && c.Possession_Scheduled_Date_1__c != Null){
                   bList[0].Possession_Schedule_Date_Time__c = c.Possession_Scheduled_Date_1__c;
               }
               updatebList.add(bList[0]);
           }
       }
       update updatebList;
    }
}