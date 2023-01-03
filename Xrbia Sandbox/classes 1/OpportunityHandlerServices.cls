//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class OpportunityHandlerServices {
    public static void duplicationCheck(List<Opportunity__c> opportunityList) {
        Map<Opportunity__c, List<Opportunity__c>> duplicateWrapperMap = new Map<Opportunity__c, List<Opportunity__c>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckOpportunity(opportunityList);
        
        for(Opportunity__c op: opportunityList) {
            if(duplicateWrapperMap.containsKey(op)) {
                //if(!test.isRunningTest())
                    op.addError('You Cannot Create / Update Opportunity for Specified Project. Already an Opportunity Present with Id: '+duplicateWrapperMap.get(op)[0].Opportunity_Id__c);
            }
        }
    }
}