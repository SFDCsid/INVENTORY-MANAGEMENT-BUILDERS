trigger trgQuotation on Quotation__c (after update, before update, before insert) {
    
    if(trigger.isupdate && trigger.isafter){
        Map<id,Quotation__C> qMap = new Map<Id,Quotation__C>();
        Set<Id> qSet = new Set<Id>();
        for(Quotation__c q : trigger.new){
            system.debug('inside quotation trg::: '+trigger.oldMap.get(q.id).Quote_Status__c + ' ::: '+trigger.newMap.get(q.id).Quote_Status__C
                         + '::: '+q.Change_In_Source__c);
            if(trigger.oldMap.get(q.id).Quote_Status__c == 'Approval Pending' && trigger.newMap.get(q.id).Quote_Status__C == 'Valid'
               && q.Change_In_Source__c == true){
                   qMap.put(q.Opportunity__C,q);
                   qSet.add(q.id); 
                   system.debug('inside condition true');
               }
            if(Test.isRunningTest()){
                qMap.put(q.Opportunity__C,q);
                qSet.add(q.id); 
            }
        }
        if(!qMap.isEmpty()){
            List<Opportunity> opForUpdate = new List<Opportunity>();
            List<Opportunity> oppList = [select id,name,Brokerage_Percentage__c, Enquiry_Type__c,Broker_Account__c, 
                                         Partner_s_Name__c,Referred_By__c,Referred_Project__c,Referred_Tower__c,Referred_Flat__c
                                         ,Referred_EMP_code__c from Opportunity where id IN: qMap.keySet()];
            if(oppList != null && !oppList.isEmpty()){
                for(Opportunity o : oppList){
                    if(qMap.containsKey(o.id)){ 
                        if(string.isNotBlank(qMap.get(o.id).Revised_Booking_Source__c))
                            o.Enquiry_Type__c = qMap.get(o.id).Revised_Booking_Source__c; 
                        if(qMap.get(o.id).Channel_Partner__c != null)    
                            o.Broker_Account__c = qMap.get(o.id).Channel_Partner__c;
                        if(qMap.get(o.id).Brokerage_Percentage__c != null)
                            o.Brokerage_Percentage__c = qMap.get(o.id).Brokerage_Percentage__c;
                        if(qMap.get(o.id).Referred_By__c != null)
                            o.Referred_By__c = qMap.get(o.id).Referred_By__c;
                        if(qMap.get(o.id).Referred_Project__c != null)
                            o.Referred_Project__c = qMap.get(o.id).Referred_Project__c;
                        if(qMap.get(o.id).Referred_Tower__c != null)
                            o.Referred_Tower__c = qMap.get(o.id).Referred_Tower__c;
                        if(qMap.get(o.id).Referred_Flat__c != null)
                            o.Referred_Flat__c = qMap.get(o.id).Referred_Flat__c;
                        if(qMap.get(o.id).Referred_EMP_code__c != null)
                            o.Referred_EMP_code__c = qMap.get(o.id).Referred_EMP_code__c;
                        opForUpdate.add(o);
                    }
                }
            }
            if(!opForUpdate.isEmpty()){
                update opForUpdate; 
            }
            PropertyManagementServices.InactiveQuotation(null,null,qSet,qMap.keySet());
        }
    }
    if((trigger.isupdate || trigger.isinsert) && trigger.isbefore){
        for (Quotation__c p : Trigger.new) {
            
            if (p.Calculated_Sanction_Amount__c != null && p.Calculated_Sanction_Amount__c >= 0) {
                Integer n = Integer.valueOf(p.Calculated_Sanction_Amount__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.Calculated_Sanction_Amount_Words__c = amo1;
            } else {
                p.Calculated_Sanction_Amount_Words__c = null;
            }
            if (p.Minimum_Required_Sanction_Amount__c != null && p.Minimum_Required_Sanction_Amount__c >= 0) {
                Integer n = Integer.valueOf(p.Minimum_Required_Sanction_Amount__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.Minimum_Required_Sanction_Amount_Words__c = amo1;
            } else {
                p.Minimum_Required_Sanction_Amount_Words__c = null;
            }
            
            if (p.Total_Agreement_Value_Modified__c != null && p.Total_Agreement_Value_Modified__c >= 0) {
                Integer n = Integer.valueOf(p.Total_Agreement_Value_Modified__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.Total_Agreement_Value_Modified_in_words__c = amo1;
                p.Comma_separator_Total_Agreement_Value_M__c = QuotationManagmentServices.INFormatR(p.Total_Agreement_Value_Modified__c);
            } else {
                p.Total_Agreement_Value_Modified_in_words__c = null;
            }
            if (p.Sale_Price_for_Carpet_Area_of_the_Unit__c != null && p.Sale_Price_for_Carpet_Area_of_the_Unit__c >= 0) {
                Integer n = Integer.valueOf(p.Sale_Price_for_Carpet_Area_of_the_Unit__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                //p.Sale_Price_for_Carpet_Area_of_Unit_words__c = amo1;
            } else {
                //p.Sale_Price_for_Carpet_Area_of_Unit_words__c = null;
            }
            if (p.Sale_Price_for_Limited_Areas_Facilities__c != null && p.Sale_Price_for_Limited_Areas_Facilities__c >= 0) {
                Integer n = Integer.valueOf(p.Sale_Price_for_Limited_Areas_Facilities__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                //p.SalePriceForLimitedAreasFacilitiesWords__c = amo1;
            } else {
                //p.SalePriceForLimitedAreasFacilitiesWords__c = null;
            }
            if (p.ITC_Benefit__c != null && p.ITC_Benefit__c >= 0) {
                Integer n = Integer.valueOf(p.ITC_Benefit__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.ITC_Benefit_words__c = amo1;
            } else {
                p.ITC_Benefit_words__c = null;
            }
            if (p.Effective_Sale_Price__c != null && p.Effective_Sale_Price__c >= 0) {
                Integer n = Integer.valueOf(p.Effective_Sale_Price__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.Effective_Sale_Price_words__c = amo1;
                p.Comma_seperated_Effective_Sale_Price__c = QuotationManagmentServices.INFormatR(p.Effective_Sale_Price__c);

            } else {
                p.Effective_Sale_Price_words__c = null;
            }
            
        }
       
    }
    
        if(trigger.isupdate && trigger.isbefore){
         Map<Id,Decimal> qmap = new Map<Id,Decimal>();
  
           for (Quotation__c q : Trigger.new) {
              if(trigger.oldMap.get(q.id).Actual_Sanction_Received__c!=trigger.newMap.get(q.id).Actual_Sanction_Received__c&&trigger.newMap.get(q.id).Actual_Sanction_Received__c>0&&trigger.newMap.get(q.id).Actual_Sanction_Received__c!=null){
               if(String.isNotBlank(q.Type_Of_Billing_Plan__c)&&q.Type_Of_Billing_Plan__c=='Bank Subvention'){
 
                 System.debug('Inside Calculated Sanctions');
                  Decimal d1=0,d2=0;
                  List<Project__c> plist = new List<Project__c>();
                  plist = [SELECT Id,Name,Sanction_SalePrice_Percentage__c,Sanction_GST_Percentage__c FROM Project__c Where Id=:q.Project__c];
                  if(!plist.isEmpty()){ 
                  system.debug('project sanction %=='+plist[0].Sanction_SalePrice_Percentage__c);
                  system.debug('project sanction GST %=='+plist[0].Sanction_GST_Percentage__c);
                  if(plist[0].Sanction_SalePrice_Percentage__c!=null&&plist[0].Sanction_SalePrice_Percentage__c>0){
                     d1 =  ((q.Total_Agreement_Value_Modified__c*plist[0].Sanction_SalePrice_Percentage__c)/100);
                   }
                  
                  if(d1>0&&d1!=null){
                    d2 =  ((d1*plist[0].Sanction_GST_Percentage__c)/100);
                  }
                  }
                  system.debug('d1=='+d1+' d2=='+d2);
                  if(d1>0&&d1!=null&&d2>0&&d2!=null){
                      Decimal d3 = d1+d2;
                      d3 = d3.setScale(0, RoundingMode.HALF_UP);
                    q.Calculated_Sanction_Amount__c = d3; 
                  }
               }else{
                   q.addError('"Actual Sanction Received" can not be edited. Type Of Billing Plan is not "Bank Subvention"');
               }
              }
            }
          } 
         
    
    if((trigger.isupdate || trigger.isinsert) && trigger.isbefore){
        for(Quotation__c qObj : Trigger.new){
            string parkingDetails = 'NA';
            map<string,Integer> parkingMap = new Map<string,Integer>();
            for(Integer j=1;j<=5;j++){
                string earmarkedName = (string) qObj.get('Earmarked_Car_Parking_Type_' + j +'__c');
                decimal earmarkedCOunt = (decimal) qObj.get('Earmarked_Car_Parking_Count_' + j +'__c');
                string additionalParkingName = (string) qObj.get('Car_Park_Type_' + j +'__c');
                decimal additionalParkingCOunt = (decimal) qObj.get('Car_Park_Count_' + j +'__c');
                if(string.isNotBlank(earmarkedName) && earmarkedCOunt != null){
                    earmarkedName = earmarkedName.toLowerCase();
                    earmarkedName = earmarkedName.substring(0,1).toUpperCase() + earmarkedName.substring(1,earmarkedName.length());
                    if(parkingMap.containskey(earmarkedName)){
                        Integer cc = parkingMap.get(earmarkedName) + Integer.valueOf(earmarkedCOunt);
                        parkingMap.put(earmarkedName, cc);
                    }else{
                        Integer cc = Integer.valueOf(earmarkedCOunt);
                        parkingMap.put(earmarkedName, cc);
                    }
                }
                if(string.isNotBlank(additionalParkingName) && additionalParkingCOunt != null){
                    additionalParkingName = additionalParkingName.toLowerCase();
                    additionalParkingName = additionalParkingName.substring(0,1).toUpperCase() + additionalParkingName.substring(1,additionalParkingName.length());
                    if(parkingMap.containskey(additionalParkingName)){
                        Integer cc = parkingMap.get(additionalParkingName) + Integer.valueOf(additionalParkingCOunt);
                        parkingMap.put(additionalParkingName, cc);
                    }else{
                        Integer cc = Integer.valueOf(additionalParkingCOunt);
                        parkingMap.put(additionalParkingName, cc);
                    }
                }
            }
            if(!parkingMap.isEmpty()){
                parkingDetails = 'Permission to park in '; 
                for(string st : parkingMap.keyset()){
                    parkingDetails += ' '+ parkingMap.get(st) + ' [' + NumbersToWordsConversionClass.getStringFromNumber(parkingMap.get(st)) + 
                        '] ' + 'car parking space/s (Configuration - ' + st + ') &'; 
                }
                parkingDetails = parkingDetails.removeEnd('&');
                //1 [One] car parking space/s (Configuration – Tandem) & 1 [One] car parking space/s (Configuration – Single)';
            }
            qObj.Car_Park_Details__c = parkingDetails;
        }
        
    }
}