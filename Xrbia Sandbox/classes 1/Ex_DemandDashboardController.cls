public class Ex_DemandDashboardController {
    @AuraEnabled
    public static Map<String, List<String>> getProjectTowerMap() {
        Map<String, List<String>> projectTowerMap = new Map<String, List<String>>();
        List<Payment_Milestone__c> pmList = getAllPendingMilestone();

        if(pmList != null) {
            Boolean exists;
            for(Payment_Milestone__c pm: pmList) {
                exists = false;
                if(projectTowerMap.containsKey(pm.Quotation__r.Unit__r.Project__r.Name)) {
                    List<String> tempList = projectTowerMap.get(pm.Quotation__r.Unit__r.Project__r.Name);

                    for(String s: tempList) {
                        if(s.equalsIgnoreCase(pm.Quotation__r.Unit__r.Tower__r.Name)) {
                            exists = true;
                            break;
                        }
                    }
                    if(!exists) {
                        tempList.add(pm.Quotation__r.Unit__r.Tower__r.Name);
                        projectTowerMap.put(pm.Quotation__r.Unit__r.Project__r.Name, tempList);
                    }
                } else {
                    List < String > tempList = new List < String > ();
                    tempList.add(pm.Quotation__r.Unit__r.Tower__r.Name);
                    projectTowerMap.put(pm.Quotation__r.Unit__r.Project__r.Name, tempList);
                }
            }
        } 
        return projectTowerMap;
    }

    public static List<Payment_Milestone__c> getAllPendingMilestone() {
        List<Payment_Milestone__c> pmList = new List<Payment_Milestone__c>();
        pmList = [Select Id, Name, Quotation__r.Unit__r.Project__r.Name, Quotation__r.Unit__r.Tower__r.Name from Payment_Milestone__c
                where Quotation__c != null AND Quotation__r.Booking__c != null AND Quotation__r.Opportunity__c != null
                AND Quotation__r.Unit__c != null AND Quotation__r.Unit__r.Project__c != null AND Quotation__r.Unit__r.Tower__c != null
                AND Quotation__r.Opportunity__r.StageName__c = 'Booking Confirmed' AND Quotation__r.Booking__r.Booking_Stages__c = 'Booking Confirmed'
                AND Quotation__r.Unit__r.Unit_Status__c = 'Booked' AND Is_Raised__c = false
                AND(
                    (Milestone_Type__c = 'Date Linked' AND Due_Date__c != null AND Due_Date__c <= NEXT_N_DAYS:15)
                    OR(Milestone_Type__c = 'Construction Linked' AND Due_Date__c != null AND Due_Date__c <= NEXT_N_DAYS:30)
                    OR(Milestone_Type__c = 'Registration Linked' AND Due_Date__c != null AND Due_Date__c <= NEXT_N_DAYS:30)  
                )
                ORDER BY Quotation__r.Unit__r.Project__r.Name, Quotation__r.Unit__r.Tower__r.Name, Due_Date__c ASC];
        system.debug('pmList: '+pmList);
        if(!pmList.isEmpty() && pmList != null)
            return pmList;
        else
            return null;
    }
}