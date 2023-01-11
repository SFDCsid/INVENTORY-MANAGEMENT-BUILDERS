public class ComputeBillingPlanLineItems {
    @AuraEnabled
    public static Boolean Consolidate(Id BillingId){
        system.debug('BillingId:: '+BillingId);
        Try{
            BillingPlanLineItemGroupingController.createBillingLineItemsFuture(BillingId); 
            return True;
        }
        Catch(Exception e){
            return False;
        }
    }
}