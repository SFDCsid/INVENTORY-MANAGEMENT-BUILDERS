//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 27-10-2022
//-------------------------------------------//
public class BookingHandlerServices {
    public static void updatePaymentMilestoneDueDate(Map<Id, Booking__c> quotationBookingMap, Set<Id> towerIdSet) {
		List<Payment_Milestone__c> pmList = new List<Payment_Milestone__c>();
        List<Payment_Milestone__c> updatePMList = new List<Payment_Milestone__c>();
        Map<Id, Map<String, Construction_Stage__c>> towerConStageMap = new Map<Id, Map<String, Construction_Stage__c>>();
        
        if(!towerIdSet.isEmpty()) {
            List<Construction_Stage__c> csList = [Select Id, Name, Expected_Completion_Date__c, Actual_Completion_Date__c from Construction_Stage__c
                                                  where Tower__c IN: towerIdSet];
            for(Id tId: towerIdSet) {
                Map<String, Construction_Stage__c> cMap = new Map<String, Construction_Stage__c>();
                for(Construction_Stage__c cs: csList) {
                    cMap.put(cs.Id, cs);
                }
                towerConStageMap.put(tId, cMap);
            }
        }
        
        if(quotationBookingMap != null) {
            pmList = [Select Id, Name, Milestone_Type__c, Milestone_Name__c, No_of_Days__c, Due_Date__c, Quotation__c, Construction_Stage__c from Payment_Milestone__c
                      where Quotation__c IN: quotationBookingMap.keyset()];
			system.debug('pmList: '+pmList);
            
            if(!pmList.isEmpty()) {
                for(id qId: quotationBookingMap.keyset()) {
                    DateTime dtm = quotationBookingMap.get(qId).Booking_Date__c;
                    Date dt = date.newinstance(dtm.year(), dtm.month(), dtm.day());
                    
                    for(Payment_Milestone__c pm: pmList) {
                        if(pm.Quotation__c == qId) {
                            if(String.isNotBlank(pm.Milestone_Type__c) && pm.Milestone_Type__c.equals('Date Linked')) {
                                if(pm.No_of_Days__c != null) {
                                    pm.Due_Date__c = dt.addDays(Integer.valueOf(pm.No_of_Days__c));
                                }
                            } else if(String.isNotBlank(pm.Milestone_Type__c) && pm.Milestone_Type__c.equals('Construction Linked')) {
                                Date completionDate = null;
                                Boolean IsMilestoneAchieved = False;
                                Map<String, Construction_Stage__c> conStageMap = towerConStageMap.get(quotationBookingMap.get(qId).Tower__c);
                                Construction_Stage__c cStage = conStageMap.get(pm.Construction_Stage__c);
                                
                                if(cStage.Actual_Completion_Date__c != null && cStage.Actual_Completion_Date__c > dt) {
                                    completionDate = cStage.Actual_Completion_Date__c;
                                } else if(cStage.Actual_Completion_Date__c != null && cStage.Actual_Completion_Date__c <= dt) {
                                    completionDate = dt.addDays(60);
                                    IsMilestoneAchieved = true;
                                } else if(cStage.Expected_Completion_Date__c != null && cStage.Expected_Completion_Date__c > dt) {
                                    completionDate = cStage.Expected_Completion_Date__c;
                                } else if(cStage.Expected_Completion_Date__c != null && cStage.Expected_Completion_Date__c <= dt) {
                                    completionDate = dt;
                                }
                                if(completionDate == null) {
                                    completionDate = dt.addDays(365);
                                }
                                pm.Due_Date__c = completionDate.addDays(Integer.valueOf(pm.No_Of_Days__c));
                                
                                if(IsMilestoneAchieved) {
                                    pm.Is_Raised__c = true;
                                    pm.Milestone_Complete_At_Booking__c = true;
                                } else {
                                    pm.Is_Raised__c = false;
                                }
                            }
                            updatePMList.add(pm);
                        }
                    }
                }
            }
        }
        if(!updatePMList.isEmpty() && updatePMList != null)
            update updatePMList;
    }
    
    public static void getApprovalDetails(Map<Id, List<Booking__c>> bookingMap) {
        Map<Id, List<Team_Member__c>> approverMap = new Map<Id, List<Team_Member__c>>();
        List<Team_Member__c> tmList = new List<Team_Member__c>();
        List<Booking__c> bList = new List<Booking__c>();
        
        
        approverMap = getCancellationApprovalTeam(bookingMap.keySet());
        
        for(Id pId: bookingMap.keySet()) {
            if(approverMap.containsKey(pId)) {
                tmList = approverMap.get(pId);
                
                if(!tmList.isEmpty() && tmList != null) {
                    bList = bookingMap.get(pId);
                    
                    for(Booking__c b: bList) {
                        for(Integer i = 1; i <= tmList.size(); i++) {
                            b.put('Booking_Cancellation_Approver_'+i+'__c', tmList[i-1].User__c);
                        }
                    }
                }
            }
        }
    }
    
    public static void bookingCancellation(List<Booking__c> bList) {
        Set<Id> uIdSet = new Set<Id>();
        Set<Id> oIdSet = new Set<Id>();
        List<Unit__c> updateUnitList = new List<Unit__c>();
        List<Opportunity__c> updateOpportunityList = new List<Opportunity__c>();
        
        for(Booking__c b: bList) {
            if(b.Unit__c != null)
                uIdSet.add(b.Unit__c);
            if(b.Opportunity__c != null)
                oIdSet.add(b.Opportunity__c);
        }
        
        if(!uIdSet.isEmpty() && uIdSet != null) {
            List<Unit__c> uList = [Select Id, Name, Opportunity__c, Booking__c, Unit_Status__c from Unit__c where Id IN: uIdSet];
            system.debug('uList: '+uList);
            
            if(uList != null) {
                for(Unit__c u: uList) {
                    u.Unit_Status__c = 'Vacant';
                    u.Opportunity__c = null;
                    u.Booking__c = null;
                    updateUnitList.add(u);
                }
            }
        }
        
        if(!oIdSet.isEmpty() && oIdSet != null) {
            List<Opportunity__c> oppList = [Select Id, Name, StageName__c from Opportunity__c where Id IN: oIdSet];
            system.debug('oppList: '+oppList);
            
            if(oppList != null) {
                for(Opportunity__c op: oppList) {
                    op.StageName__c = 'Booking Cancelled';
                    updateOpportunityList.add(op);
                }
            }
        }
        if(!updateUnitList.isEmpty() && updateUnitList != null)
            update updateUnitList;
        if(!updateOpportunityList.isEmpty() && updateOpportunityList != null)
            update updateOpportunityList;
    }
    
    public static Map<Id, List<Team_Member__c>> getCancellationApprovalTeam(Set<Id> pIdSet) {
        Map<Id, List<Team_Member__c>> approverMap = new Map<Id, List<Team_Member__c>>();
        List<Team_Member__c> tmList = new List<Team_Member__c>();
        
        tmList = [Select Id, Name, User__c, Sequence_Number__c, User_Active_Status__c, Availability__c, Team__r.Project__c from Team_Member__c
                  where Team__r.Project__c IN: pIdSet AND Team__r.Team_Type__c = 'Cancellation Team' AND User_Active_Status__c = true ORDER BY Sequence_Number__c ASC];
        system.debug('tmList: '+tmList);
        
        if(!tmList.isEmpty() && tmList != null) {
            for(Team_Member__c tm: tmList) {
                if(!approverMap.containsKey(tm.Team__r.Project__c)) {
                    List<Team_Member__c> newList = new List<Team_Member__c>();
                    newList.add(tm);
                    approverMap.put(tm.Team__r.Project__c, newList);
                } else {
                    approverMap.get(tm.Team__r.Project__c).add(tm);
                }
            }
        }
        return approverMap;
    }

    public static void updateBookingCBILStatus(Booking__c b) {
        Set<Id> oIdSet = new Set<Id>();
        List<Booking__c> bList = new List<Booking__c>();
        string bookingStatus = '';
        string bookingSubStatus = '';
        List<Opportunity__c> updateOpportunityList = new List<Opportunity__c>();
        
        //for(Booking__c b: bList) {
            if(b.Opportunity__c != null)
                oIdSet.add(b.Opportunity__c);
            if (b.CBIL_Approved__c == 'Yes') {
                bookingStatus = 'Booking in-process';
                bookingSubStatus = 'Cibil Approved';
            }
            else if(b.CBIL_Approved__c == 'No')    
            {
                bookingStatus = 'Under Cancellation';
                bookingSubStatus = 'Cibil Unapproved';
            }
        //}
        if (bookingStatus != '' && bookingSubStatus != '') {
            b.Booking_Stages__c = bookingStatus;
            b.Booking_Sub_Stage__c = bookingSubStatus;
        }
            //if(!bList.isEmpty() && bList != null)
            //update bList;
        if(!oIdSet.isEmpty() && oIdSet != null) {
            List<Opportunity__c> oppList = [Select Id, Name, StageName__c 
                                            from Opportunity__c 
                                            where 
                                            Id IN: oIdSet];
            system.debug('oppList: '+oppList);
            
            if(oppList != null) {
                for(Opportunity__c op: oppList) {
                    if (bookingStatus != '' && bookingSubStatus != '') {
                    op.StageName__c = bookingStatus;
                    op.Sub_Stage__c = bookingSubStatus;
                    updateOpportunityList.add(op);
                    }
                }
            }
        }
        if(!updateOpportunityList.isEmpty() && updateOpportunityList != null)
            update updateOpportunityList;
    }

    public static void updateBookingWelcomeCallStatus(Booking__c b) {
        Set<Id> oIdSet = new Set<Id>();
        List<Booking__c> bList = new List<Booking__c>();
        string bookingStatus = '';
        string bookingSubStatus = '';
        List<Opportunity__c> updateOpportunityList = new List<Opportunity__c>();
        
        //for(Booking__c b: bList) {
            if(b.Opportunity__c != null)
                oIdSet.add(b.Opportunity__c);
            if (b.Welcome_Call_Status__c == 'Welcome Call Done') {
                bookingStatus = 'Booking in-process';
                bookingSubStatus = 'Welcome Call Done';
            }
            
        //}
        if (bookingStatus != '' && bookingSubStatus != '') {
            b.Booking_Stages__c = bookingStatus;
            b.Booking_Sub_Stage__c = bookingSubStatus;
        }
            //if(!bList.isEmpty() && bList != null)
            //update bList;
        if(!oIdSet.isEmpty() && oIdSet != null) {
            List<Opportunity__c> oppList = [Select Id, Name, StageName__c 
                                            from Opportunity__c 
                                            where 
                                            Id IN: oIdSet];
            system.debug('oppList: '+oppList);
            
            if(oppList != null) {
                for(Opportunity__c op: oppList) {
                    if (bookingStatus != '' && bookingSubStatus != '') {
                    op.StageName__c = bookingStatus;
                    op.Sub_Stage__c = bookingSubStatus;
                    updateOpportunityList.add(op);
                    }
                }
            }
        }
        if(!updateOpportunityList.isEmpty() && updateOpportunityList != null)
            update updateOpportunityList;
    }

    public static void updateBookingTransactionStatus(Booking__c b) {
        Set<Id> oIdSet = new Set<Id>();
        List<Booking__c> bList = new List<Booking__c>();
        string bookingStatus = '';
        string bookingSubStatus = '';
        List<Opportunity__c> updateOpportunityList = new List<Opportunity__c>();
        
        //for(Booking__c b: bList) {
            if(b.Opportunity__c != null)
                oIdSet.add(b.Opportunity__c);
            if (b.Transaction_Status__c == 'Cheque Bounce') {
                bookingStatus = 'Under Cancellation';
                bookingSubStatus = 'Cheque Bounce';
            }
            if (b.Transaction_Status__c == 'Successful') {
                bookingStatus = 'Booking in-process';
                bookingSubStatus = 'Amount Cleared';
            }
            
        //}
            if (bookingStatus != '' && bookingSubStatus != '') {
                b.Booking_Stages__c = bookingStatus;
                b.Booking_Sub_Stage__c = bookingSubStatus;
            }
            
            
            //if(!bList.isEmpty() && bList != null)
            //update bList;
        if(!oIdSet.isEmpty() && oIdSet != null) {
            List<Opportunity__c> oppList = [Select Id, Name, StageName__c 
                                            from Opportunity__c 
                                            where 
                                            Id IN: oIdSet];
            system.debug('oppList: '+oppList);
            
            if(oppList != null) {
                for(Opportunity__c op: oppList) {
                    if (bookingStatus != '' && bookingSubStatus != '') {
                    op.StageName__c = 'Booking in-process';
                    op.Sub_Stage__c = bookingSubStatus;
                    updateOpportunityList.add(op);
                    }
                }
            }
        }
        if(!updateOpportunityList.isEmpty() && updateOpportunityList != null)
            update updateOpportunityList;
    }
}