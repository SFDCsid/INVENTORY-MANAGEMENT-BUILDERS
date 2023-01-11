public class SummaryOfAmounts {
    public string bId {
        get;
        set{
            bId = value;
            if(bId != null)
                DemaindDebitDetails();
        }
    }
    Public String TA{get;set;}
    Public String tm{get;set;}
    Public String totalam{get;set;}
    Public List<SAP_Demands_and_Debits__c> SDList{get;set;}
    
    Public SummaryOfAmounts(){
        SDList = new List<SAP_Demands_and_Debits__c>();
    }
    
    Public void DemaindDebitDetails(){
        Decimal Total = 0;
        SDList = [Select id, Name,Invoice_Date__c,Invoice_Number__c,Due_Date__c,Amount_Billed_Total__c,
                  Ageing_0_3_Days__c,Ageing_4_22_Days__c,Ageing_23_52_Days__c,Ageing_53_82_Days__c,
                  Ageing_83_112_Days__c,Ageing_112_Days__c,Total_Amount__c,Billing_Stage__c from 
                  SAP_Demands_and_Debits__c where Booking__c =: bId AND Is_canceled__c != true
                  And Total_Amount__c > 0 Order by CreatedDate ASC];
        
        for(SAP_Demands_and_Debits__c sd: SDList){
            if(sd.Ageing_0_3_Days__c != null){
                Total += sd.Ageing_0_3_Days__c;
            }
            if(sd.Ageing_4_22_Days__c != null){
                Total += sd.Ageing_4_22_Days__c;
            }
            if(sd.Ageing_23_52_Days__c != null){
                Total += sd.Ageing_23_52_Days__c;
            }
            if(sd.Ageing_53_82_Days__c != null){
                Total += sd.Ageing_53_82_Days__c;
            }
            if(sd.Ageing_83_112_Days__c != null){
                Total += sd.Ageing_83_112_Days__c;
            }
            if(sd.Ageing_112_Days__c != null){
                Total += sd.Ageing_112_Days__c;
            }
        }
        
        if(Total != null){
            String TotAm = String.valueOf(Total);
            TA = addComma(TotAm);
        }
    }
    
    public static String addComma(String TotalAmount){
        if(TotalAmount.length() == 14){ 
            TotalAmount = TotalAmount.left(2) +  ',' + TotalAmount.substring(2, 4) + ',' + TotalAmount.substring(4, 6) + ',' + TotalAmount.substring(6, 8) + ',' + TotalAmount.substring(8, 11) + TotalAmount.right(3);
            system.debug('TotalAmount14:::'+TotalAmount);
        }
        else if(TotalAmount.length() == 13){ 
            TotalAmount = TotalAmount.left(1) +  ',' + TotalAmount.substring(1, 3) + ',' + TotalAmount.substring(3, 5) + ',' + TotalAmount.substring(5, 7) + ',' + TotalAmount.substring(7, 10) + TotalAmount.right(3);
            system.debug('TotalAmount13:::'+TotalAmount);
        }
        else if(TotalAmount.length() == 12){
            TotalAmount = TotalAmount.left(2) +  ',' + TotalAmount.substring(2, 4) + ',' + TotalAmount.substring(4, 6) + ',' + TotalAmount.substring(6, 9) + TotalAmount.right(3);
            system.debug('TotalAmount12:::'+TotalAmount);
        }
        else if(TotalAmount.length() == 11){
            TotalAmount = TotalAmount.left(1) +  ',' + TotalAmount.substring(1, 3) + ',' + TotalAmount.substring(3, 5) + ',' + TotalAmount.substring(5, 8) + TotalAmount.right(3);
            system.debug('TotalAmount11:::'+TotalAmount);
        }
        else if(TotalAmount.length() == 10){
            TotalAmount = TotalAmount.left(2) +  ',' + TotalAmount.substring(2, 4) + ',' + TotalAmount.substring(4, 7) + TotalAmount.right(3);
            system.debug('TotalAmount10:::'+TotalAmount);
        }
        else if(TotalAmount.length() == 9){
            TotalAmount = TotalAmount.left(1) +  ',' + TotalAmount.substring(1, 3) + ',' + TotalAmount.substring(3, 6) + TotalAmount.right(3);
            system.debug('TotalAmount9:::'+TotalAmount);
        }
        else if(TotalAmount.length() == 8){
            TotalAmount = TotalAmount.left(2) +  ',' + TotalAmount.substring(2, 5) + TotalAmount.right(3);
            system.debug('TotalAmount8:::'+TotalAmount);
        }
        return TotalAmount;
    }
}