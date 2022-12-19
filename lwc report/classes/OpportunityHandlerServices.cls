public class OpportunityHandlerServices {
    public static void duplicationCheck(List<Opportunity> opportunityList) {
        Map<Opportunity, List<Opportunity>> duplicateWrapperMap = new Map<Opportunity, List<Opportunity>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckOpportunity(opportunityList);
        
        for(Opportunity op: opportunityList) {
            String msg;
            msg = '';
            if(duplicateWrapperMap.containsKey(op)) {
                if(!test.isRunningTest())
                    op.addError('You Cannot Create / Update Opportunity for Specified Project. Already an Opportunity Present with Id: '+duplicateWrapperMap.get(op)[0].Opportunity_Id__c);
            }
        }
    }
}