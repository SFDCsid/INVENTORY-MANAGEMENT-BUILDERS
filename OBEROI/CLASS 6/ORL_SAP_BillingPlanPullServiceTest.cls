@isTest
public class ORL_SAP_BillingPlanPullServiceTest {
    
    @isTest(SeeAllData=True)
    static void testPullBillingPlanFromSAP(){
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());
        Test.startTest();
        ORL_SAP_BillingPlanPullService orlSapBilling = new ORL_SAP_BillingPlanPullService();
        orlSapBilling.pullBillingPlanFromSAP();
        Test.stopTest();
    }
    
    private class YourWebServiceMock implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName, 
            String responseType) {
                ORL_SAP_BillingPlanPull.ZSD_FM_BILLING_PLANResponse_element response_x =  new ORL_SAP_BillingPlanPull.ZSD_FM_BILLING_PLANResponse_element();
                ORL_SAP_BillingPlanPull.TABLE_OF_ZSDST_BILLING_PLAN EX_BILLING_PLAN = new ORL_SAP_BillingPlanPull.TABLE_OF_ZSDST_BILLING_PLAN();
                ORL_SAP_BillingPlanPull.TABLE_OF_ZSDST_BILLING_PLAN EX_BILLING_PLAN_FULL = new ORL_SAP_BillingPlanPull.TABLE_OF_ZSDST_BILLING_PLAN();
                ORL_SAP_BillingPlanPull.TABLE_OF_BAPIRET2 RETURN_x = new ORL_SAP_BillingPlanPull.TABLE_OF_BAPIRET2();
                ORL_SAP_BillingPlanPull.BAPIRET2[] item_x = new List<ORL_SAP_BillingPlanPull.BAPIRET2>();
                ORL_SAP_BillingPlanPull.BAPIRET2 item_y = new ORL_SAP_BillingPlanPull.BAPIRET2();
                ORL_SAP_BillingPlanPull.ZSDST_BILLING_PLAN[] item = new List<ORL_SAP_BillingPlanPull.ZSDST_BILLING_PLAN>();
                ORL_SAP_BillingPlanPull.ZSDST_BILLING_PLAN item1 = new ORL_SAP_BillingPlanPull.ZSDST_BILLING_PLAN();
                item1.INDICATOR = 'I';
                item1.TOWER = 'C';
                item1.PLANT = '4786';
                item1.BP_NO = '0000018406';
                item1.BP_ITEM_NO = '000226';
                item1.DATE_CATEGORY = 'CC';
                item1.BILLING_DATE = '2019-01-30';
                item1.DATE_DESC = 'EL01';
                item1.MILESTONE = 'SL26';
                item1.DESCRIPTION = 'Completion of Elevators';
                item1.VALUE_PERCENTAGE = '0.0';
                item1.WAERS = '';
                item1.BILLING_VALUE = '0.0';
                item1.BILLING_BLOCK = '';
                item1.BP_RULE = '';
                item1.MILESTONE_NO = '000000000000';
                item1.PAYMENT_TERM = 'INEL';
                item1.BP_ID = '';
                
                ORL_SAP_BillingPlanPull.ZSDST_BILLING_PLAN item2 = new ORL_SAP_BillingPlanPull.ZSDST_BILLING_PLAN();
                item2.INDICATOR = 'D';
                item2.TOWER = 'C';
                item2.PLANT = '';
                item2.BP_NO = '0000018406';
                item2.BP_ITEM_NO = '000113';
                item2.DATE_CATEGORY = 'CC';
                item2.BILLING_DATE = '0000-00-00';
                item2.DATE_DESC = '';
                item2.MILESTONE = 'SL27';
                item2.DESCRIPTION = '';
                item2.VALUE_PERCENTAGE = '0.0';
                item2.WAERS = '';
                item2.BILLING_VALUE = '0.0';
                item2.BILLING_BLOCK = '';
                item2.BP_RULE = '';
                item2.MILESTONE_NO = '000000000000';
                item2.PAYMENT_TERM = 'C';
                item2.BP_ID = '';
                
                item.add(item1);
                item.add(item2);
                
                System.debug('item : : ' + item);
                
                item_y.TYPE_x = '';
                item_y.ID = '';
                item_y.NUMBER_x = '000';
                item_y.MESSAGE = '';
                item_y.LOG_NO = '';
                item_y.LOG_MSG_NO = '000000';
                item_y.MESSAGE_V1 = '';
                item_y.MESSAGE_V2 = '';
                item_y.MESSAGE_V3 = '';
                item_y.MESSAGE_V4 = '';
                item_y.PARAMETER = '';
                item_y.ROW = 0;
                item_y.FIELD = '';
                item_y.SYSTEM_x = '';
                item_x.add(item_y);
                RETURN_x.item =  item_x;               
                EX_BILLING_PLAN.item = item;
                EX_BILLING_PLAN_FULL = EX_BILLING_PLAN;
                Map<String, ORL_SAP_BillingPlanPull.ZSD_FM_BILLING_PLANResponse_element> response_map_x = new Map<String, ORL_SAP_BillingPlanPull.ZSD_FM_BILLING_PLANResponse_element>();
                response_x.EX_BILLING_PLAN = EX_BILLING_PLAN;
                response_x.EX_BILLING_PLAN_FULL = EX_BILLING_PLAN_FULL;
                response_x.RETURN_x = RETURN_x;
                response_map_x.put('response_x', response_x);
                response_x = response_map_x.get('response_x');
                response.put('response_x', response_x);
            }
    }
    
}