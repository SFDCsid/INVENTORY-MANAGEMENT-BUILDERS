public class BillingPlanTriggerHandler {
    
    //Ravi Kumar K
    public static void pricingCalculation(List<Payment_Plan__c> paymentPlanList,map<id,Payment_Plan__c> oldPaymentMap,String methodName){
        Set<Id> setOpportunityId = new Set<id>();
        Set<Id> setPropertyId = new Set<id>();
        Set<Id> SetPropertyIdScheme = new Set<id>();
        map<Id, id> mapBillingPlanToSchemePlan =  new map<Id, id>();
        map<Id, Pricing__c> mapPropTypeIdToPricing = new map<Id,Pricing__c>();
        map<Id,Id> mapPropToPropType = new map<Id,Id>();
        map<Id,Property__c> mapPropIdToProp = new map<Id,property__c>();
        Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId(); 
        Id schemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan w/t Tower').getRecordTypeId();
        Id schemeBPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();  
        Id CustomiseRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId(); 
        //Set<Id> setPPId = new Set<Id>();
        for(Payment_Plan__c paymentObj: paymentPlanList)
       {
           setOpportunityId.add(paymentObj.Opportunity__c);
           setPropertyId.add(paymentObj.property__c);
           //setPPId.add(paymentObj.Id);
           if(paymentObj.recordTypeId ==schemeBPlanRecordTypeId){
               SetPropertyIdScheme.add(paymentObj.property__c);
               mapBillingPlanToSchemePlan.put(paymentObj.Id ,paymentObj.Scheme_Billing_Plan__c);
           }
       }
        //For Pricing Change 
        map<Id,Id> mapPropertyType = new  map<Id,Id>();
        for(Payment_Plan__c pp: [select id,Property__c,Property__r.Property_Type__c from Payment_Plan__c 
        where Property__c IN : setPropertyId]){
           mapPropertyType.put(pp.Property__c,pp.Property__r.Property_Type__c);
        }
        system.debug('1111111111111111111'+mapPropertyType);
        map<Id,Id> mapPropertyPricing = new  map<Id,Id>();
        for(Pricing__c pr : [select Id,Type__c, Property_Type__c from Pricing__c where Property_Type__c IN : mapPropertyType.values()]){
               if(pr.Type__c == 'Non Scheme'){
               mapPropertyPricing.put(pr.Property_Type__c,pr.Id);
               }
        }
        system.debug('1111111111111111111'+mapPropertyPricing);
       map<Id,Opportunity> mapBillingToOpp = new map<Id,Opportunity>([SELECT Id, Name,Project__c 
                                                                       FROM Opportunity
                                                                       WHERE Id=:setOpportunityId]);
       map<Id,property__c> mapBillingToProp = new map<Id,property__c>([SELECT Id, Property_Name__c,Material_No__c
                                                                       FROM Property__c
                                                                       WHERE Id=:setPropertyId]);
      for(property__c propObj: [SELECT id, Property_Type__c, Super_Area__c, Floor_Number__c
                                 FROM property__c
                                 WHERE id=:SetPropertyIdScheme]){
              mapPropToPropType.put(propObj.id, propObj.Property_Type__c);
              mapPropIdToProp.put(propObj.id, propObj);
      }
      
   /*   map<Id,property__c> mapBillingToPropScheme = new map<Id,property__c>([SELECT Id, Property_Name__c,Material_No__c,Property_Type__c
                                                                       FROM Property__c
                                                                       WHERE Id=:setPropertyId]);
   */
        if(mapBillingPlanToSchemePlan.size()>0 && !mapBillingPlanToSchemePlan.isEmpty()){
                 for(Pricing__c priObj: [SELECT Id,Property_Type__c,Base_Cost__c, Floor_Rise_Cost__c, PLC_Cost__c,
                                 ITC_Basic_Cost__c, ITC_Floor_Rise_Cost__c, ITC_PLC_Cost__c
                                 FROM pricing__c
                                 WHERE Billing_Plan__c=:mapBillingPlanToSchemePlan.values()]){
                mapPropTypeIdToPricing.put(priObj.Property_Type__c, priObj);                                                    
           }
        }
           
      system.debug('@@mapBillingToOpp '+mapBillingToOpp );
        For(Payment_Plan__c singlePaymentPlan  : paymentPlanList){
            if(methodName=='Insert'){
                if(singlePaymentPlan.recordTypeId ==schemeBPlanRecordTypeId ){
                        Pricing__c pri = mapPropTypeIdToPricing.get(mapPropToPropType.get(singlePaymentPlan.property__c));
                        property__c prop = mapPropIdToProp.get(singlePaymentPlan.Property__c);
                        //system.debug('1111111111-->'+pri.Base_Cost__c);
                        //system.debug('1111111111-->'+pri.Floor_Rise_Cost__c);
                        //system.debug('1111111111-->'+pri.PLC_Cost__c);
                        if(pri!= null && prop!= null ){
                            singlePaymentPlan.Basic_Sale_Price_Scheme__c = pri.Base_Cost__c * prop.Super_Area__c;
                            singlePaymentPlan.Floor_Rise_Charges_Scheme__c = pri.Floor_Rise_Cost__c * prop.Super_Area__c * prop.Floor_Number__c;
                            singlePaymentPlan.PLC_Charges_Scheme__c = pri.PLC_Cost__c * prop.Super_Area__c;
                            singlePaymentPlan.ITC_Basic_Sale_Price_Scheme__c = pri.ITC_Basic_Cost__c * prop.Super_Area__c;
                            singlePaymentPlan.ITC_Floor_Rise_Charges_Scheme__c = pri.ITC_Floor_Rise_Cost__c * prop.Super_Area__c * prop.Floor_Number__c;
                            singlePaymentPlan.ITC_PLC_Charges_Scheme__c = pri.ITC_PLC_Cost__c * prop.Super_Area__c;
                            singlePaymentPlan.Pricing_Ref__c = pri.Id;
                            //Logic to provide discount Start
                            if(singlePaymentPlan .Basic_Sale_Price_Scheme__c!=null){
                                if(singlePaymentPlan .Discount_On_Basic_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .Basic_Sale_Price_Scheme__c-(singlePaymentPlan .Basic_Sale_Price_Scheme__c*(singlePaymentPlan .Discount_On_Basic_Cost__c*0.01));
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .Basic_Cost_After_Discount_Formula__c = rounded;
                                }else if(singlePaymentPlan .Discount_Amount_On_Basic_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .Basic_Sale_Price_Scheme__c-singlePaymentPlan .Discount_Amount_On_Basic_Cost__c;
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .Basic_Cost_After_Discount_Formula__c = rounded;
                                }
                            }
                            if(singlePaymentPlan .Floor_Rise_Charges_Scheme__c!=null){
                                if(singlePaymentPlan .Discount_On_Floor_Rise_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .Floor_Rise_Charges_Scheme__c-(singlePaymentPlan .Floor_Rise_Charges_Scheme__c*(singlePaymentPlan .Discount_On_Floor_Rise_Cost__c*0.01));
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .Floor_Rise_Cost_After_Discount_Formula__c = rounded;
                                }else if(singlePaymentPlan .Discount_Amount_On_Floor_Rise_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .Floor_Rise_Charges_Scheme__c-singlePaymentPlan .Discount_Amount_On_Floor_Rise_Cost__c;
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .Floor_Rise_Cost_After_Discount_Formula__c = rounded;
                                }
                            }
                            if(singlePaymentPlan .PLC_Charges_Scheme__c!=null){
                                if(singlePaymentPlan .Discount_On_PLC_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .PLC_Charges_Scheme__c-(singlePaymentPlan .PLC_Charges_Scheme__c*(singlePaymentPlan .Discount_On_PLC_Cost__c*0.01));
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .PLC_Cost_After_Discount_Formula__c = rounded;
                                }else if(singlePaymentPlan .Discount_Amount_On_PLC_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .PLC_Charges_Scheme__c-singlePaymentPlan .Discount_Amount_On_PLC_Cost__c;
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .PLC_Cost_After_Discount_Formula__c = rounded;
                                }
                            }
                            if(singlePaymentPlan .ITC_Basic_Sale_Price_Scheme__c!=null){
                                if(singlePaymentPlan .Discount_On_ITC_Basic_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .ITC_Basic_Sale_Price_Scheme__c-(singlePaymentPlan .ITC_Basic_Sale_Price_Scheme__c*(singlePaymentPlan .Discount_On_ITC_Basic_Cost__c*0.01));
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .ITC_Basic_Sales_Price_After_Discount__c = rounded;
                                }else if(singlePaymentPlan .Discount_Amount_On_ITC_Basic_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .ITC_Basic_Sale_Price_Scheme__c-singlePaymentPlan .Discount_Amount_On_ITC_Basic_Cost__c;
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .ITC_Basic_Sales_Price_After_Discount__c = rounded;
                                }
                            }
                            if(singlePaymentPlan .ITC_Floor_Rise_Charges_Scheme__c!=null){
                                if(singlePaymentPlan .Discount_On_ITC_Floor_Rise_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .ITC_Floor_Rise_Charges_Scheme__c-(singlePaymentPlan .ITC_Floor_Rise_Charges_Scheme__c*(singlePaymentPlan .Discount_On_ITC_Floor_Rise_Cost__c*0.01));
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .ITC_Floor_Rise_Cost_After_Discount__c = rounded;
                                }else if(singlePaymentPlan .Discount_Amount_On_ITC_Floor_Rise_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .ITC_Floor_Rise_Charges_Scheme__c-singlePaymentPlan .Discount_Amount_On_ITC_Floor_Rise_Cost__c;
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .ITC_Floor_Rise_Cost_After_Discount__c = rounded;
                                }
                            }
                            if(singlePaymentPlan .ITC_PLC_Charges_Scheme__c!=null){
                                if(singlePaymentPlan .Discount_On_ITC_PLC_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .ITC_PLC_Charges_Scheme__c-(singlePaymentPlan .ITC_PLC_Charges_Scheme__c*(singlePaymentPlan .Discount_On_ITC_PLC_Cost__c*0.01));
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .ITC_PLC_Cost_After_Discount__c = rounded;
                                }else if(singlePaymentPlan .Discount_Amount_On_ITC_PLC_Cost__c!=null){
                                    Decimal tAmount = 0;
                                    tAmount = singlePaymentPlan .ITC_PLC_Charges_Scheme__c-singlePaymentPlan .Discount_Amount_On_ITC_PLC_Cost__c;
                                    Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                                    singlePaymentPlan .ITC_PLC_Cost_After_Discount__c = rounded;
                                }
                            }
                            //Logic to provide discount End
                        }
                }
                else{
                    //Populate Price
                    system.debug('1111111111111111111'+mapPropertyPricing.get(mapPropertyType.get(singlePaymentPlan.Property__c)));
                    system.debug('1111111111111111111'+mapPropertyType.get(singlePaymentPlan.Property__c));
                    singlePaymentPlan.Pricing_Ref__c=mapPropertyPricing.get(mapPropertyType.get(singlePaymentPlan.Property__c));
                    //Populate Price
                if(singlePaymentPlan .Basic_Cost_Formula__c!=null){
                    if(singlePaymentPlan .Discount_On_Basic_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .Basic_Cost_Formula__c-(singlePaymentPlan .Basic_Cost_Formula__c*(singlePaymentPlan .Discount_On_Basic_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .Basic_Cost_After_Discount_Formula__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_Basic_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .Basic_Cost_Formula__c-singlePaymentPlan .Discount_Amount_On_Basic_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .Basic_Cost_After_Discount_Formula__c = rounded;
                    }
                }if(singlePaymentPlan .Floor_Rise_Cost_Formula__c!=null){
                    if(singlePaymentPlan .Discount_On_Floor_Rise_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .Floor_Rise_Cost_Formula__c-(singlePaymentPlan .Floor_Rise_Cost_Formula__c*(singlePaymentPlan .Discount_On_Floor_Rise_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .Floor_Rise_Cost_After_Discount_Formula__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_Floor_Rise_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .Floor_Rise_Cost_Formula__c-singlePaymentPlan .Discount_Amount_On_Floor_Rise_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .Floor_Rise_Cost_After_Discount_Formula__c = rounded;
                    }
                }if(singlePaymentPlan .PLC_Cost_Formula__c!=null){
                    if(singlePaymentPlan .Discount_On_PLC_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .PLC_Cost_Formula__c-(singlePaymentPlan .PLC_Cost_Formula__c*(singlePaymentPlan .Discount_On_PLC_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .PLC_Cost_After_Discount_Formula__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_PLC_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .PLC_Cost_Formula__c-singlePaymentPlan .Discount_Amount_On_PLC_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .PLC_Cost_After_Discount_Formula__c = rounded;
                    }
                }
                //Logic to set Discount for ITC Pricing Cost Start
                if(singlePaymentPlan .ITC_Basic_Sale_Price__c!=null){
                    if(singlePaymentPlan .Discount_On_ITC_Basic_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_Basic_Sale_Price__c-(singlePaymentPlan .ITC_Basic_Sale_Price__c*(singlePaymentPlan .Discount_On_ITC_Basic_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .ITC_Basic_Sales_Price_After_Discount__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_ITC_Basic_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_Basic_Sale_Price__c-singlePaymentPlan .Discount_Amount_On_ITC_Basic_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .ITC_Basic_Sales_Price_After_Discount__c = rounded;
                    }
                }
                if(singlePaymentPlan .ITC_Floor_Rise_Charges__c!=null){
                    if(singlePaymentPlan .Discount_On_ITC_Floor_Rise_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_Floor_Rise_Charges__c-(singlePaymentPlan .ITC_Floor_Rise_Charges__c*(singlePaymentPlan .Discount_On_ITC_Floor_Rise_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .ITC_Floor_Rise_Cost_After_Discount__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_ITC_Floor_Rise_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_Floor_Rise_Charges__c-singlePaymentPlan .Discount_Amount_On_ITC_Floor_Rise_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .ITC_Floor_Rise_Cost_After_Discount__c = rounded;
                    }
                }
                if(singlePaymentPlan .ITC_PLC_Charges__c!=null){
                    if(singlePaymentPlan .Discount_On_ITC_PLC_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_PLC_Charges__c-(singlePaymentPlan .ITC_PLC_Charges__c*(singlePaymentPlan .Discount_On_ITC_PLC_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .ITC_PLC_Cost_After_Discount__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_ITC_PLC_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_PLC_Charges__c-singlePaymentPlan .Discount_Amount_On_ITC_PLC_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP); 
                        singlePaymentPlan .ITC_PLC_Cost_After_Discount__c = rounded;
                    }
                }
                //Logic to set Discount for ITC Pricing Cost End
                // To update Billing Plan Name on insertion
                //if( singlePaymentPlan.recordTypeId !=defaultRecordTypeId  && singlePaymentPlan.recordTypeId !=schemeRecordTypeId && (mapBillingToOpp.get(singlePaymentPlan.Opportunity__c).Name!='' && mapBillingToOpp.get(singlePaymentPlan.Opportunity__c).Name!=null && mapBillingToOpp.get(singlePaymentPlan.Opportunity__c)!=null) && (mapBillingToProp.get(singlePaymentPlan.Property__c).Material_No__c!='' && mapBillingToProp.get(singlePaymentPlan.Property__c).Material_No__c!= null && mapBillingToProp.get(singlePaymentPlan.Property__c)!=null)){
                if( singlePaymentPlan.recordTypeId !=defaultRecordTypeId  && singlePaymentPlan.recordTypeId !=schemeRecordTypeId && (mapBillingToOpp.get(singlePaymentPlan.Opportunity__c)!=null && mapBillingToOpp.get(singlePaymentPlan.Opportunity__c).Name!='' && mapBillingToOpp.get(singlePaymentPlan.Opportunity__c).Name!=null) && ( mapBillingToProp.get(singlePaymentPlan.Property__c)!=null && mapBillingToProp.get(singlePaymentPlan.Property__c).Material_No__c!='' && mapBillingToProp.get(singlePaymentPlan.Property__c).Material_No__c!= null)){   
                   singlePaymentPlan.Billing_Plan_Name__c = mapBillingToOpp.get(singlePaymentPlan.Opportunity__c).Name + '-' + mapBillingToProp.get(singlePaymentPlan .Property__c).Material_No__c.substring(0,3); 
                  
                }
                if( singlePaymentPlan.recordTypeId == CustomiseRecordTypeId && mapBillingToOpp.size()>0 && !mapBillingToOpp.isEmpty() && singlePaymentPlan.Opportunity__c!=null){
                 system.debug('@@'+mapBillingToOpp.get(singlePaymentPlan.Opportunity__c).project__c);
                   //singlePaymentPlan.Project__c= mapBillingToOpp.get(singlePaymentPlan.Opportunity__c).project__c;
                   
                   }
                   }
            }
            if(methodName=='Update'){
                        system.debug('111111111111111111');
                if(singlePaymentPlan.recordTypeId ==schemeBPlanRecordTypeId ){
                        Pricing__c pri = mapPropTypeIdToPricing.get(mapPropToPropType.get(singlePaymentPlan.property__c));
                        property__c prop = mapPropIdToProp.get(singlePaymentPlan.Property__c);
                    if(pri != null && prop!=null){
                            singlePaymentPlan.Basic_Sale_Price_Scheme__c = pri.Base_Cost__c * prop.Super_Area__c;
                            singlePaymentPlan.Floor_Rise_Charges_Scheme__c = pri.Floor_Rise_Cost__c * prop.Super_Area__c * prop.Floor_Number__c;
                            singlePaymentPlan.PLC_Charges_Scheme__c= pri.PLC_Cost__c * prop.Super_Area__c;
                            singlePaymentPlan.ITC_Basic_Sale_Price_Scheme__c = pri.ITC_Basic_Cost__c * prop.Super_Area__c;
                            singlePaymentPlan.ITC_Floor_Rise_Charges_Scheme__c = pri.ITC_Floor_Rise_Cost__c * prop.Super_Area__c * prop.Floor_Number__c;
                            singlePaymentPlan.ITC_PLC_Charges_Scheme__c = pri.ITC_PLC_Cost__c * prop.Super_Area__c;
                            //system.debug('111111111111111111'+singlePaymentPlan.Basic_Cost_After_Discount_Formula__c);
                            //system.debug('111111111111111111'+singlePaymentPlan.Floor_Rise_Cost_After_Discount_Formula__c);
                            //system.debug('111111111111111111'+singlePaymentPlan.PLC_Cost_After_Discount_Formula__c);
                            //
                        if(singlePaymentPlan.Basic_Sale_Price_Scheme__c!=null  && singlePaymentPlan.Discount_On_Basic_Cost__c!=oldPaymentMap.get(singlePaymentPlan.Id).Discount_On_Basic_Cost__c){
                            if(singlePaymentPlan.Discount_On_Basic_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.Basic_Sale_Price_Scheme__c-(singlePaymentPlan.Basic_Sale_Price_Scheme__c*(singlePaymentPlan.Discount_On_Basic_Cost__c*0.01));
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.Basic_Cost_After_Discount_Formula__c = rounded;
                            }else if(singlePaymentPlan.Discount_On_Basic_Cost__c==null){
                                singlePaymentPlan .Basic_Cost_After_Discount_Formula__c = null;
                            }
                        }
                        if(singlePaymentPlan.Basic_Sale_Price_Scheme__c!=null  && singlePaymentPlan.Discount_Amount_On_Basic_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_Basic_Cost__c){
                            if(singlePaymentPlan.Discount_Amount_On_Basic_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.Basic_Sale_Price_Scheme__c-singlePaymentPlan.Discount_Amount_On_Basic_Cost__c;
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.Basic_Cost_After_Discount_Formula__c = rounded;
                            }else if(singlePaymentPlan.Discount_Amount_On_Basic_Cost__c==null){
                                singlePaymentPlan.Basic_Cost_After_Discount_Formula__c = null;
                            }
                        }
                
                        if(singlePaymentPlan.Floor_Rise_Charges_Scheme__c!=null  && singlePaymentPlan .Discount_On_Floor_Rise_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_Floor_Rise_Cost__c){
                            if(singlePaymentPlan.Discount_On_Floor_Rise_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.Floor_Rise_Charges_Scheme__c-(singlePaymentPlan.Floor_Rise_Charges_Scheme__c*(singlePaymentPlan.Discount_On_Floor_Rise_Cost__c*0.01));
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.Floor_Rise_Cost_After_Discount_Formula__c = rounded;
                            }else if(singlePaymentPlan.Discount_On_Floor_Rise_Cost__c==null){
                                singlePaymentPlan.Floor_Rise_Cost_After_Discount_Formula__c = null;
                            }
                        }
                        if(singlePaymentPlan.Floor_Rise_Charges_Scheme__c!=null  && singlePaymentPlan.Discount_Amount_On_Floor_Rise_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_Floor_Rise_Cost__c){
                            if(singlePaymentPlan.Discount_Amount_On_Floor_Rise_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.Floor_Rise_Charges_Scheme__c-singlePaymentPlan.Discount_Amount_On_Floor_Rise_Cost__c;
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.Floor_Rise_Cost_After_Discount_Formula__c = rounded;
                            }else if(singlePaymentPlan.Discount_Amount_On_Floor_Rise_Cost__c==null){
                                singlePaymentPlan.Floor_Rise_Cost_After_Discount_Formula__c = null;
                            }
                        }
                        if(singlePaymentPlan.PLC_Charges_Scheme__c!=null  && singlePaymentPlan.Discount_On_PLC_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_PLC_Cost__c){
                            if(singlePaymentPlan.Discount_On_PLC_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.PLC_Charges_Scheme__c-(singlePaymentPlan.PLC_Charges_Scheme__c*(singlePaymentPlan.Discount_On_PLC_Cost__c*0.01));
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.PLC_Cost_After_Discount_Formula__c = rounded;
                            }else if(singlePaymentPlan .Discount_On_PLC_Cost__c==null){
                                singlePaymentPlan .PLC_Cost_After_Discount_Formula__c = null;
                            }
                        }
                        if(singlePaymentPlan .PLC_Charges_Scheme__c!=null  && singlePaymentPlan.Discount_Amount_On_PLC_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_PLC_Cost__c){
                            if(singlePaymentPlan.Discount_Amount_On_PLC_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.PLC_Charges_Scheme__c-singlePaymentPlan.Discount_Amount_On_PLC_Cost__c;
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.PLC_Cost_After_Discount_Formula__c = rounded;
                            }else if(singlePaymentPlan.Discount_Amount_On_PLC_Cost__c==null){
                                singlePaymentPlan.PLC_Cost_After_Discount_Formula__c = null;
                            }
                        }
                        //Logic to have ITC Discount for Scheme Start
                        if(singlePaymentPlan.ITC_Basic_Sale_Price_Scheme__c!=null  && singlePaymentPlan.Discount_On_ITC_Basic_Cost__c!=oldPaymentMap.get(singlePaymentPlan.Id).Discount_On_ITC_Basic_Cost__c){
                            if(singlePaymentPlan.Discount_On_ITC_Basic_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.ITC_Basic_Sale_Price_Scheme__c-(singlePaymentPlan.ITC_Basic_Sale_Price_Scheme__c*(singlePaymentPlan.Discount_On_ITC_Basic_Cost__c*0.01));
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.ITC_Basic_Sales_Price_After_Discount__c = rounded;
                            }else if(singlePaymentPlan.Discount_On_ITC_Basic_Cost__c==null){
                                singlePaymentPlan .ITC_Basic_Sales_Price_After_Discount__c = null;
                            }
                        }
                        if(singlePaymentPlan.ITC_Basic_Sale_Price_Scheme__c!=null  && singlePaymentPlan.Discount_Amount_On_ITC_Basic_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_ITC_Basic_Cost__c){
                            if(singlePaymentPlan.Discount_Amount_On_ITC_Basic_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.ITC_Basic_Sale_Price_Scheme__c-singlePaymentPlan.Discount_Amount_On_ITC_Basic_Cost__c;
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.ITC_Basic_Sales_Price_After_Discount__c = rounded;
                            }else if(singlePaymentPlan.Discount_Amount_On_ITC_Basic_Cost__c==null){
                                singlePaymentPlan.ITC_Basic_Sales_Price_After_Discount__c = null;
                            }
                        }
                
                        if(singlePaymentPlan.ITC_Floor_Rise_Charges_Scheme__c!=null  && singlePaymentPlan .Discount_On_ITC_Floor_Rise_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_ITC_Floor_Rise_Cost__c){
                            if(singlePaymentPlan.Discount_On_ITC_Floor_Rise_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.ITC_Floor_Rise_Charges_Scheme__c-(singlePaymentPlan.ITC_Floor_Rise_Charges_Scheme__c*(singlePaymentPlan.Discount_On_ITC_Floor_Rise_Cost__c*0.01));
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.ITC_Floor_Rise_Cost_After_Discount__c = rounded;
                            }else if(singlePaymentPlan.Discount_On_ITC_Floor_Rise_Cost__c==null){
                                singlePaymentPlan.ITC_Floor_Rise_Cost_After_Discount__c = null;
                            }
                        }
                        if(singlePaymentPlan.ITC_Floor_Rise_Charges_Scheme__c!=null  && singlePaymentPlan.Discount_Amount_On_ITC_Floor_Rise_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_ITC_Floor_Rise_Cost__c){
                            if(singlePaymentPlan.Discount_Amount_On_ITC_Floor_Rise_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.ITC_Floor_Rise_Charges_Scheme__c-singlePaymentPlan.Discount_Amount_On_ITC_Floor_Rise_Cost__c;
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.ITC_Floor_Rise_Cost_After_Discount__c = rounded;
                            }else if(singlePaymentPlan.Discount_Amount_On_ITC_Floor_Rise_Cost__c==null){
                                singlePaymentPlan.ITC_Floor_Rise_Cost_After_Discount__c = null;
                            }
                        }
                        if(singlePaymentPlan.ITC_PLC_Charges_Scheme__c!=null  && singlePaymentPlan.Discount_On_ITC_PLC_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_ITC_PLC_Cost__c){
                            if(singlePaymentPlan.Discount_On_ITC_PLC_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.ITC_PLC_Charges_Scheme__c-(singlePaymentPlan.ITC_PLC_Charges_Scheme__c*(singlePaymentPlan.Discount_On_ITC_PLC_Cost__c*0.01));
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.ITC_PLC_Cost_After_Discount__c = rounded;
                            }else if(singlePaymentPlan .Discount_On_ITC_PLC_Cost__c==null){
                                singlePaymentPlan .ITC_PLC_Cost_After_Discount__c = null;
                            }
                        }
                        if(singlePaymentPlan .ITC_PLC_Charges_Scheme__c!=null  && singlePaymentPlan.Discount_Amount_On_ITC_PLC_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_ITC_PLC_Cost__c){
                            if(singlePaymentPlan.Discount_Amount_On_ITC_PLC_Cost__c!=null){
                                Decimal tAmount = 0;
                                tAmount = singlePaymentPlan.ITC_PLC_Charges_Scheme__c-singlePaymentPlan.Discount_Amount_On_ITC_PLC_Cost__c;
                                Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                                singlePaymentPlan.ITC_PLC_Cost_After_Discount__c = rounded;
                            }else if(singlePaymentPlan.Discount_Amount_On_ITC_PLC_Cost__c==null){
                                singlePaymentPlan.ITC_PLC_Cost_After_Discount__c = null;
                            }
                        }
                        //Logic to Have ITC Discount for SCheme End
                    }
                }
                else{
                if(singlePaymentPlan .Basic_Cost_Formula__c!=null  && singlePaymentPlan .Discount_On_Basic_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_Basic_Cost__c){
                    if(singlePaymentPlan .Discount_On_Basic_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .Basic_Cost_Formula__c-(singlePaymentPlan .Basic_Cost_Formula__c*(singlePaymentPlan .Discount_On_Basic_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);        
                        singlePaymentPlan .Basic_Cost_After_Discount_Formula__c = rounded;
                    }else if(singlePaymentPlan .Discount_On_Basic_Cost__c==null){
                        singlePaymentPlan .Basic_Cost_After_Discount_Formula__c = null;
                    }
                }if(singlePaymentPlan .Basic_Cost_Formula__c!=null  && singlePaymentPlan .Discount_Amount_On_Basic_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_Basic_Cost__c){
                    if(singlePaymentPlan .Discount_Amount_On_Basic_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .Basic_Cost_Formula__c-singlePaymentPlan .Discount_Amount_On_Basic_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .Basic_Cost_After_Discount_Formula__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_Basic_Cost__c==null){
                        singlePaymentPlan .Basic_Cost_After_Discount_Formula__c = null;
                    }
                }
                
                if(singlePaymentPlan .Floor_Rise_Cost_Formula__c!=null  && singlePaymentPlan .Discount_On_Floor_Rise_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_Floor_Rise_Cost__c){
                    if(singlePaymentPlan .Discount_On_Floor_Rise_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .Floor_Rise_Cost_Formula__c-(singlePaymentPlan .Floor_Rise_Cost_Formula__c*(singlePaymentPlan .Discount_On_Floor_Rise_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .Floor_Rise_Cost_After_Discount_Formula__c = rounded;
                    }else if(singlePaymentPlan .Discount_On_Floor_Rise_Cost__c==null){
                        singlePaymentPlan .Floor_Rise_Cost_After_Discount_Formula__c = null;
                    }
                }if(singlePaymentPlan .Floor_Rise_Cost_Formula__c!=null  && singlePaymentPlan .Discount_Amount_On_Floor_Rise_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_Floor_Rise_Cost__c){
                    if(singlePaymentPlan .Discount_Amount_On_Floor_Rise_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .Floor_Rise_Cost_Formula__c-singlePaymentPlan .Discount_Amount_On_Floor_Rise_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .Floor_Rise_Cost_After_Discount_Formula__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_Floor_Rise_Cost__c==null){
                        singlePaymentPlan .Floor_Rise_Cost_After_Discount_Formula__c = null;
                    }
                }
                if(singlePaymentPlan .PLC_Cost_Formula__c!=null  && singlePaymentPlan .Discount_On_PLC_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_PLC_Cost__c){
                    if(singlePaymentPlan .Discount_On_PLC_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .PLC_Cost_Formula__c-(singlePaymentPlan .PLC_Cost_Formula__c*(singlePaymentPlan .Discount_On_PLC_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .PLC_Cost_After_Discount_Formula__c = rounded;
                    }else if(singlePaymentPlan .Discount_On_PLC_Cost__c==null){
                        singlePaymentPlan .PLC_Cost_After_Discount_Formula__c = null;
                    }
                }if(singlePaymentPlan .PLC_Cost_Formula__c!=null  && singlePaymentPlan .Discount_Amount_On_PLC_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_PLC_Cost__c){
                    if(singlePaymentPlan .Discount_Amount_On_PLC_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .PLC_Cost_Formula__c-singlePaymentPlan .Discount_Amount_On_PLC_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .PLC_Cost_After_Discount_Formula__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_PLC_Cost__c==null){
                        singlePaymentPlan .PLC_Cost_After_Discount_Formula__c = null;
                    }
                }
                //Logic for Billing Plan ITC Discount Start
                
                if(singlePaymentPlan .ITC_Basic_Sale_Price__c!=null  && singlePaymentPlan .Discount_On_ITC_Basic_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_ITC_Basic_Cost__c){
                    if(singlePaymentPlan .Discount_On_ITC_Basic_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_Basic_Sale_Price__c-(singlePaymentPlan .ITC_Basic_Sale_Price__c*(singlePaymentPlan .Discount_On_ITC_Basic_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);        
                        singlePaymentPlan .ITC_Basic_Sales_Price_After_Discount__c = rounded;
                    }else if(singlePaymentPlan .Discount_On_ITC_Basic_Cost__c==null){
                        singlePaymentPlan .ITC_Basic_Sales_Price_After_Discount__c = null;
                    }
                }if(singlePaymentPlan .ITC_Basic_Sale_Price__c!=null  && singlePaymentPlan .Discount_Amount_On_ITC_Basic_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_ITC_Basic_Cost__c){
                    if(singlePaymentPlan .Discount_Amount_On_ITC_Basic_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_Basic_Sale_Price__c-singlePaymentPlan .Discount_Amount_On_ITC_Basic_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .ITC_Basic_Sales_Price_After_Discount__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_ITC_Basic_Cost__c==null){
                        singlePaymentPlan .ITC_Basic_Sales_Price_After_Discount__c = null;
                    }
                }
                
                if(singlePaymentPlan .ITC_Floor_Rise_Charges__c!=null  && singlePaymentPlan .Discount_On_ITC_Floor_Rise_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_ITC_Floor_Rise_Cost__c){
                    if(singlePaymentPlan .Discount_On_ITC_Floor_Rise_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_Floor_Rise_Charges__c-(singlePaymentPlan .ITC_Floor_Rise_Charges__c*(singlePaymentPlan .Discount_On_ITC_Floor_Rise_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .ITC_Floor_Rise_Cost_After_Discount__c = rounded;
                    }else if(singlePaymentPlan .Discount_On_ITC_Floor_Rise_Cost__c==null){
                        singlePaymentPlan .ITC_Floor_Rise_Cost_After_Discount__c = null;
                    }
                }if(singlePaymentPlan .ITC_Floor_Rise_Charges__c!=null  && singlePaymentPlan .Discount_Amount_On_ITC_Floor_Rise_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_ITC_Floor_Rise_Cost__c){
                    if(singlePaymentPlan .Discount_Amount_On_ITC_Floor_Rise_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_Floor_Rise_Charges__c-singlePaymentPlan .Discount_Amount_On_ITC_Floor_Rise_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .ITC_Floor_Rise_Cost_After_Discount__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_ITC_Floor_Rise_Cost__c==null){
                        singlePaymentPlan .ITC_Floor_Rise_Cost_After_Discount__c = null;
                    }
                }
                if(singlePaymentPlan .ITC_PLC_Charges__c!=null  && singlePaymentPlan .Discount_On_ITC_PLC_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_On_ITC_PLC_Cost__c){
                    if(singlePaymentPlan .Discount_On_ITC_PLC_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_PLC_Charges__c-(singlePaymentPlan .ITC_PLC_Charges__c*(singlePaymentPlan .Discount_On_ITC_PLC_Cost__c*0.01));
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .ITC_PLC_Cost_After_Discount__c = rounded;
                    }else if(singlePaymentPlan .Discount_On_ITC_PLC_Cost__c==null){
                        singlePaymentPlan .ITC_PLC_Cost_After_Discount__c = null;
                    }
                }if(singlePaymentPlan .ITC_PLC_Charges__c!=null  && singlePaymentPlan .Discount_Amount_On_ITC_PLC_Cost__c!=oldPaymentMap.get(singlePaymentPlan .Id).Discount_Amount_On_ITC_PLC_Cost__c){
                    if(singlePaymentPlan .Discount_Amount_On_ITC_PLC_Cost__c!=null){
                        Decimal tAmount = 0;
                        tAmount = singlePaymentPlan .ITC_PLC_Charges__c-singlePaymentPlan .Discount_Amount_On_ITC_PLC_Cost__c;
                        Decimal rounded = tAmount.setScale(0, RoundingMode.HALF_UP);
                        singlePaymentPlan .ITC_PLC_Cost_After_Discount__c = rounded;
                    }else if(singlePaymentPlan .Discount_Amount_On_ITC_PLC_Cost__c==null){
                        singlePaymentPlan .ITC_PLC_Cost_After_Discount__c = null;
                    }
                }
                //Logic for Billing Plan ITC Discount End
            }
            }
        }
    }
    

    public static void onAfterInsert(List<Payment_Plan__c> paymentPlanList){  
        List<Payment_Plan__c> listBillingPlanWithJodi = new List<Payment_Plan__c>();
        List<Payment_Plan__c> listInsertBillingPlanWithJodi = new List<Payment_Plan__c>();
          Set<Id> setBillingPlanObjDefault = new Set<id>();
        Map<Id,Id> mapBillingObjToTower = new map<Id,Id>();
         Set<Id> setBillingPlanObjScheme = new Set<id>();
        Map<Id,Id> mapBillingObjToTowerScheme = new map<Id,Id>();
        Map<id,String> mapBillingToProperty = new map<id,String>(); 
        List<Id> ListInsertId = new List<Id>();
        Set<Id> setBpObjId = new set<Id>();
        map<Id,Payment_Plan__c > mapIdtoBpJodi = new map<Id,Payment_Plan__c > ();
        Map<String, List<Billing_Plan_Line_Item__c>> mapTowerBPToBillingPlanLineItem = new map<String, List<Billing_Plan_Line_Item__c>>();
        Map<String, List<Billing_Plan_Line_Item__c>> mapTowerBPToBillingPlanLineItemScheme = new map<String, List<Billing_Plan_Line_Item__c>>();
         Map<Id,List<Billing_Plan_Line_Item__c>> mapTowerToBillingPlanLineItem = new Map<Id,List<Billing_Plan_Line_Item__c>>();
          Map<Id,List<Billing_Plan_Line_Item__c>> mapSchemeBPlanToBillingPlanLineItem= new Map<Id,List<Billing_Plan_Line_Item__c>>();
        List<Payment_Plan__c> listRelatedJodiMaster = new List<Payment_Plan__c>();
        
         Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId(); 
         Id customizeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
          Id NonSchemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
         Id schemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();
          Id schemeTowerRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan w/t Tower').getRecordTypeId();  

        for(Payment_Plan__c bpObjId: paymentPlanList){
            setBpObjId.add(bpObjId.Id);
            if(bpObjId.recordTypeId == defaultRecordTypeId ){ //NonSchemeRecordTypeId
               setBillingPlanObjDefault.add(bpObjId.Id);
               mapBillingObjToTower.put(bpObjId.Id,bpObjId.Tower__c);
            }
            if(bpObjId.recordTypeId == schemeRecordTypeId){
               setBillingPlanObjScheme.add(bpObjId.Id);
               mapBillingObjToTowerScheme.put(bpObjId.Id,bpObjId.Tower__c);
            }
        }
           //method to create Related Jodi Billing Plan   
        for(Payment_Plan__c bpObj: [SELECT Id,Scheme_Billing_Plan__c,recordTypeId,property__c,property__r.Is_Jodi_Flat__c,property__r.Related_Jodi_Property__c, 
                                    Active__c,Tower__c,Site__c,Project__c,Opportunity__c
                                    FROM Payment_Plan__c WHERE Id=:setBpObjId]){
           if(bpObj.property__r.Related_Jodi_Property__c !=null){
            listBillingPlanWithJodi.add(bpObj);
        }
        }  
        system.debug('@@listBillingPlanWithJodi'+listBillingPlanWithJodi);
        //system.debug('@@listBillingPlanWithJodi'+listBillingPlanWithJodi[0].recordTypeId);        
        if(listBillingPlanWithJodi.size()>0 && !listBillingPlanWithJodi.isEmpty()){
            for(Payment_Plan__c ppObj:listBillingPlanWithJodi){
                Payment_Plan__c ppObjJodi = new Payment_Plan__c(
                                                Active__c = ppObj.Active__c,
                                                Site__c = ppObj.Site__c,
                                                Project__c = ppObj.Project__c,
                                                Tower__c = ppObj.Tower__c,
                                                Opportunity__c = ppObj.Opportunity__c,
                                                Property__c = ppObj.property__r.Related_Jodi_Property__c
                                                //RecordTypeId= customizeRecordTypeId
                                                );
                        system.debug('@@listBillingPlanWithJodi'+ppObj.recordTypeId);   
                        system.debug('@@listBillingPlanWithJodi'+NonSchemeRecordTypeId);    
                        if(ppObj.RecordTypeId == NonSchemeRecordTypeId){
                            ppObjJodi.RecordTypeId = NonSchemeRecordTypeId; 
                        }
                        else if (ppObj.RecordTypeId == customizeRecordTypeId){
                            ppObjJodi.RecordTypeId = customizeRecordTypeId;
                        } 
                        else if (ppObj.RecordTypeId == schemeRecordTypeId){
                            ppObjJodi.RecordTypeId = schemeRecordTypeId;
                            system.debug('AAAAAAAAA'+ppObj.Scheme_Billing_Plan__c);
                            ppObjJodi.Scheme_Billing_Plan__c = ppObj.Scheme_Billing_Plan__c;
                        }                           
                    listInsertBillingPlanWithJodi.add(ppObjJodi);
                    mapBillingToProperty.put(ppObj.id,ppObj.property__c+'-'+ppObj.property__r.Related_Jodi_Property__c);
            }   
        }   
         system.debug('@@mapBillingToProperty'+mapBillingToProperty); 
         List<Database.SaveResult> srList = new List<Database.SaveResult> ();
        if(listInsertBillingPlanWithJodi.size()>0 && !listInsertBillingPlanWithJodi.isEmpty()){
           if(checkRecursive.runOnce())
    {
           //   insert listInsertBillingPlanWithJodi;
             srList = Database.insert(listInsertBillingPlanWithJodi, false);
               system.debug('@@srLis--'+srList );
              for (Database.SaveResult s : srList ) {
              system.debug('@@s.isSuccess()--'+s.isSuccess());
    if (s.isSuccess()) {
      system.debug(s.getId()); 
        ListInsertId.add(s.getId()); 
     } 
} 
   system.debug('@@ListInsertId--'+ListInsertId);
            }
        }
        
        for(Payment_Plan__c bplineItem:[SELECT Id,Property__c FROM Payment_Plan__c WHERE Id=:ListInsertId]){
        mapIdtoBpJodi.put(bplineItem.Id,bplineItem);
        
        }
     system.debug('@@listInsertBillingPlanWithJodiafter --'+listInsertBillingPlanWithJodi); 
     system.debug('@@ListInsertId outside--'+ListInsertId);
      system.debug('@@mapBillingToProperty'+mapBillingToProperty); 
      
      for(Payment_Plan__c ppobjMaster : listBillingPlanWithJodi){
             Id masterProp = mapBillingToProperty.get(ppobjMaster.Id).SubStringBefore('-');
          for(Payment_Plan__c ppObjJodi : mapIdtoBpJodi.values()){
               Id jodiProp = mapBillingToProperty.get(ppobjMaster.Id).SubStringAfter('-');
               if(jodiProp == mapIdtoBpJodi.get(ppObjJodi .Id).property__c){
               ppobjMaster.Related_Jodi_Billing_Plan__c=ppObjJodi.Id;
               listRelatedJodiMaster.add(ppobjMaster);
               }
          }
      }
       if(listRelatedJodiMaster.size()>0 && !listRelatedJodiMaster.isEmpty()){
       update listRelatedJodiMaster;
       }
       
     // To insert Billing Plan Line Item for Default Billing Plan Created by user
            if(setBillingPlanObjDefault.size()>0 && !setBillingPlanObjDefault.isEmpty()){
           for(Billing_Plan_Line_item__c bpli:[SELECT Id,Payment_Plan__r.Tower__c,Sequence_number__c,
                                                  Payment_Plan_Line_Item_Name__c, Amount__c, Due_After_Days__c,
                                                  Percentage_Of_Value_To_Be_Invoiced__c, Order__c, Milestone_Number__c,
                                                  Terms_of_Payment_Key__c
                                               FROM Billing_Plan_Line_Item__c
                                               WHERE Payment_Plan__r.recordTypeId =:defaultRecordTypeId 
                                               AND Payment_Plan__r.Active__c =true]){
              if(mapTowerToBillingPlanLineItem.containsKey(bpli.Payment_Plan__r.Tower__c)){
                        mapTowerToBillingPlanLineItem.get(bpli.Payment_Plan__r.Tower__c).add(bpli);
                    } else{
                        mapTowerToBillingPlanLineItem.put(bpli.Payment_Plan__r.Tower__c, new List<Billing_Plan_Line_Item__c>{bpli});
                    }                        
           }
           system.debug('*****mapTowerBPToBillingPlanLineItem-->'+mapTowerBPToBillingPlanLineItem);
           for(Payment_Plan__c paymentObj: [SELECT Id, Tower__c 
                                            FROM Payment_Plan__c 
                                            WHERE Id=:setBillingPlanObjDefault]){
               list<Billing_Plan_Line_Item__c> newListbpli = mapTowerToBillingPlanLineItem.get(mapBillingObjToTower.get(paymentObj.Id));
               mapTowerBPToBillingPlanLineItem.put(paymentObj.Tower__c,newListbpli);
           }
       }
       system.debug('@@mapBillingObjToTower-->'+mapBillingObjToTower);
       system.debug('@@mapTowerBPToBillingPlanLineItem-->'+mapTowerBPToBillingPlanLineItem);
        if(mapBillingObjToTower.size()>0 && mapTowerBPToBillingPlanLineItem.size()>0 && !mapBillingObjToTower.isEmpty() && !mapTowerBPToBillingPlanLineItem.isEmpty()){
              insertLineItem(mapBillingObjToTower, mapTowerBPToBillingPlanLineItem);
        } 
        
             // To insert Billing Plan Line Item for Scheme Billing Plan Created by user
            if(setBillingPlanObjScheme.size()>0 && !setBillingPlanObjScheme.isEmpty()){
           for(Billing_Plan_Line_item__c bpli:[SELECT Id,Payment_Plan__r.Tower__c,Sequence_number__c,
                                                  Payment_Plan_Line_Item_Name__c, Amount__c, Due_After_Days__c,
                                                  Percentage_Of_Value_To_Be_Invoiced__c, Order__c, Milestone_Number__c,
                                                  Terms_of_Payment_Key__c,Payment_Plan__c
                                               FROM Billing_Plan_Line_Item__c
                                               WHERE Payment_Plan__r.recordTypeId =:schemeTowerRecordTypeId 
                                               AND Payment_Plan__r.Active__c =true]){
                    system.debug('@@Payment_Plan__r.Scheme_Billing_Plan__c-->'+bpli.Payment_Plan__c);                              
              if(mapSchemeBPlanToBillingPlanLineItem.containsKey(bpli.Payment_Plan__c)){
                        mapSchemeBPlanToBillingPlanLineItem.get(bpli.Payment_Plan__c).add(bpli);
                    } else{
                        mapSchemeBPlanToBillingPlanLineItem.put(bpli.Payment_Plan__c, new List<Billing_Plan_Line_Item__c>{bpli});
                    }                        
           }
           
           for(Payment_Plan__c paymentObj: [SELECT Id, Tower__c, Scheme_Billing_Plan__c 
                                            FROM Payment_Plan__c 
                                            WHERE Id=:setBillingPlanObjScheme]){
               list<Billing_Plan_Line_Item__c> newListbpli = mapSchemeBPlanToBillingPlanLineItem.get(paymentObj.Scheme_Billing_Plan__c );
               mapTowerBPToBillingPlanLineItemScheme.put(paymentObj.Tower__c,newListbpli);
           }
       }
          system.debug('@@mapSchemeBPlanToBillingPlanLineItem-->'+mapSchemeBPlanToBillingPlanLineItem);   
            system.debug('@@mapBillingObjToTowerScheme-->'+mapBillingObjToTowerScheme);
       system.debug('@@mapTowerBPToBillingPlanLineItemScheme-->'+mapTowerBPToBillingPlanLineItemScheme);
        if(mapBillingObjToTowerScheme.size()>0 && mapTowerBPToBillingPlanLineItemScheme.size()>0 && !mapBillingObjToTowerScheme.isEmpty() && !mapTowerBPToBillingPlanLineItemScheme.isEmpty()){
              insertLineItem(mapBillingObjToTowerScheme, mapTowerBPToBillingPlanLineItemScheme);
        } 
     }
    
   // method to insert line item to default billing plan and scheme billling plan 
    public static void insertLineItem(Map<Id,Id> mapBillingObjToTower, Map<String, List<Billing_Plan_Line_Item__c>> mapTowerBPToBillingPlanLineItem){
         List<Billing_plan_Line_Item__c> InsertListbpli = new List<Billing_Plan_Line_Item__c>();
      
       for(id bpObj: mapBillingObjToTower.keyset()){
       if(mapTowerBPToBillingPlanLineItem.get(mapBillingObjToTower.get(bpObj))!=null){
               for(Billing_Plan_Line_Item__c bpli: mapTowerBPToBillingPlanLineItem.get(mapBillingObjToTower.get(bpObj))){
                   Billing_Plan_Line_Item__c bplinew = new Billing_Plan_Line_Item__c();
                   bplinew.Payment_Plan__c= bpObj;
                     bplinew.Payment_Plan_Line_Item_Name__c=bpli.Payment_Plan_Line_Item_Name__c;
                     bplinew.Description__c=bpli.Payment_Plan_Line_Item_Name__c;
                     bplinew.Amount__c=bpli.Amount__c;
                     bplinew.Due_After_Days__c=bpli.Due_After_Days__c;
                     bplinew.Percentage_Of_Value_To_Be_Invoiced__c=bpli.Percentage_Of_Value_To_Be_Invoiced__c;
                     bplinew.Order__c=bpli.Order__c;
                     bplinew.Milestone_Number__c=bpli.Milestone_Number__c;
                     bplinew.Terms_of_Payment_Key__c=bpli.Terms_of_Payment_Key__c;
                     bplinew.Sequence_number__c= bpli.Sequence_number__c;
                     if(bpli.Percentage_Of_Value_To_Be_Invoiced__c!= null){
                         bplinew.Percentage__c=Decimal.valueOf(bpli.Percentage_Of_Value_To_Be_Invoiced__c);
                     }
                   InsertListbpli.add(bplinew );
               }
               }
           }
       if(InsertListbpli.size()>0 && !InsertListbpli.isEmpty()){
           insert InsertListbpli;
           system.debug('InsertListbpliInsertListbpli'+InsertListbpli);
           //to add sublineitem
           /*List<id> liid = new list<id>();
           
           for (Billing_Plan_Line_Item__c BPL:InsertListbpli){
               //if(BPL.payment_plan__r.recordtypeid == Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId()){
               liid.add(BPL.id);
               //}
           }
           InsertBillingPlanSubLineItem.InsertBillingPlanSubLineItemMethod(liid);*/
       }
    }
    //For populating property details on billing plan
    public static void insertRMDetails(list<Payment_Plan__c> lstBillingPlan){
        set<id> propid = new set<id>(); 
        Id schemeRTId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();    
        set<id> stoppyId = new set<id>();
        map<Id,Id> mapProp = new map<Id,Id>();
        map<Id,String> mapOppy = new map<Id,String>();
        for(Payment_Plan__c bp : lstBillingPlan){
            if(!String.isBlank(bp.Property__c)){
            propid.add(bp.Property__c);
            stoppyId.add(bp.Opportunity__c);
            //mapProp.put(bp.Property__c,bp.Opportunity);}
            }
        }   
        for(Opportunity opp : [select id,Name from Opportunity where Id IN : stoppyId]){
            mapOppy.put(opp.Id,opp.Name);
        }
        map<id, Property__c> propMap = new map<id, Property__c>(); 
        if(propid != null && propid.size()>0){
            for(Property__c prty : [Select id,Material_No__c,Project_Name__r.Site_Head__c,Project_Name__r.Sales_Head__c,Project_Name__r.CFO__c,
                Project_Name__r.MD__c from Property__c where id in: propid]){
                propMap.put(prty.Id,prty);
            }
            for(Payment_Plan__c bp : lstBillingPlan){
                if(propMap.containskey(bp.Property__c)){
                    bp.Site_Head__c = propMap.get(bp.Property__c).Project_Name__r.Site_Head__c;
                    bp.Sales_Head__c = propMap.get(bp.Property__c).Project_Name__r.Sales_Head__c;
                    bp.CFO_Director__c= propMap.get(bp.Property__c).Project_Name__r.CFO__c;
                    bp.MD__c = propMap.get(bp.Property__c).Project_Name__r.MD__c; 
                   // To update Billing Plan Name on insertion
                    if(bp.recordTypeId ==schemeRTId 
                    && mapOppy.size() > 0 && mapOppy != null && mapOppy.get(bp.Opportunity__c) != null
                    && propMap.size() > 0 && propMap != null && propMap.get(bp.Property__c).Material_No__c != null){
                       bp.Billing_Plan_Name__c = mapOppy.get(bp.Opportunity__c) + '-' + propMap.get(bp.Property__c).Material_No__c;
                      //System.debug('SCHEUMEBILLINGPLAN'+bp.Billing_Plan_Name__c);
                    }                   
                }    
            }    
        }          
    }
    public static void onAfterUpdate(List<Payment_Plan__c> paymentPlanList,map<id,Payment_Plan__c> oldPaymentMap){  
        Set<Id> stJodiId = new Set<Id>();
        Map<Id,string> mapJodiId = new Map<Id,string>();
        Map<Id,string> mapParentId = new Map<Id,string>();
        Set<Id> stJodiDiscount = new Set<Id>();
        Map<Id,Id> mapJodiDiscount = new Map<Id,Id>();
        Map<Id,Payment_Plan__c> mapParentDiscount = new Map<Id,Payment_Plan__c>();
        List<Payment_Plan__c> lstJodiId = new List<Payment_Plan__c>();
        List<Payment_Plan__c> lstJodiPricing = new List<Payment_Plan__c>();
        Map<Id,Payment_Plan__c> mapSOLineItem = new Map<Id,Payment_Plan__c>();
        for(Payment_Plan__c pp : paymentPlanList){
            system.debug('11111111111'+pp.Related_Jodi_Billing_Plan__c);
            //Added by Aditya Bhasin for Sales order Line Item Start
            if(pp.Active__c != oldPaymentMap.get(pp.Id).Active__c && !String.isBlank(pp.Status__c) && 
            pp.Status__c != oldPaymentMap.get(pp.Id).Status__c && pp.Status__c == 'Approved'){
                salesOrderLineItem(pp.Id);
            }
            //Added by Aditya Bhasin for Sales order Line Item Stop
            if(!String.isBlank(pp.Related_Jodi_Billing_Plan__c) && pp.Active__c != oldPaymentMap.get(pp.Id).Active__c &&
            !String.isBlank(pp.Status__c) && pp.Status__c != oldPaymentMap.get(pp.Id).Status__c)
            //&& pp.Status__c == 'Approved')
            {
                //stJodiId.add(pp.Related_Jodi_Billing_Plan__c);
                mapJodiId.put(pp.Related_Jodi_Billing_Plan__c,pp.Id);
                mapParentId.put(pp.Id,pp.Status__c);
            }
            
            if(!String.isBlank(pp.Related_Jodi_Billing_Plan__c) && (pp.Discount_On_Basic_Cost__c != null || pp.Discount_Amount_On_Basic_Cost__c != null
            || pp.Discount_On_Floor_Rise_Cost__c != null || pp.Discount_Amount_On_Floor_Rise_Cost__c != null
            || pp.Discount_On_PLC_Cost__c != null || pp.Discount_Amount_On_PLC_Cost__c != null)){
                //stJodiDiscount.add(pp.Related_Jodi_Billing_Plan__c);
                mapJodiDiscount.put(pp.Related_Jodi_Billing_Plan__c,pp.Id);
                mapParentDiscount.put(pp.Id,pp);
            }
        }
        //system.debug('mapJodiDiscountmapJodiDiscount'+mapJodiDiscount.values());
        //system.debug('mapParentIdmapParentId'+mapParentId.values());
        //system.debug('mapJodiIdmapJodiId'+mapJodiId.values());
        for(Payment_Plan__c pp : [select id,Status__c,Active__c,Related_Jodi_Billing_Plan__c from Payment_Plan__c
            where ID IN : mapJodiId.keyset()]){
            if(mapJodiId != null && mapJodiId.size() > 0 
            && mapParentId != null && mapParentId.size() > 0){
                String myId = mapJodiId.get(pp.Id);
                if(mapParentId.get(myId) == 'Approved'){
                    pp.Status__c = 'Approved';
                    pp.Active__c = true;
                }else if (mapParentId.get(myId) == 'Rejected'){
                    pp.Status__c = 'Rejected';
                    pp.Active__c = false;
                }
                lstJodiId.add(pp);
            }
            //system.debug('lstJodiIdlstJodiId'+lstJodiId);
        }
        if(!lstJodiId.isEmpty() && lstJodiId.size() > 0){
            update lstJodiId;
        }
        for(Payment_Plan__c pp : [select id,Discount_On_Basic_Cost__c, Discount_Amount_On_Basic_Cost__c,
            Discount_On_Floor_Rise_Cost__c, Discount_Amount_On_Floor_Rise_Cost__c,Discount_On_ITC_Basic_Cost__c,
            Discount_On_ITC_Floor_Rise_Cost__c,Discount_On_ITC_PLC_Cost__c,Discount_Amount_On_ITC_Basic_Cost__c,
            Discount_Amount_On_ITC_Floor_Rise_Cost__c,Discount_Amount_On_ITC_PLC_Cost__c,
            Discount_On_PLC_Cost__c, Discount_Amount_On_PLC_Cost__c,Pricing_Ref__c from Payment_Plan__c
            where ID IN : mapJodiDiscount.keyset()]){           
            if(mapJodiDiscount != null && mapJodiDiscount.size() > 0 
            && mapParentDiscount != null && mapParentDiscount.size() > 0){
                String myId = mapJodiDiscount.get(pp.Id);
                pp.Discount_On_Basic_Cost__c = mapParentDiscount.get(myId).Discount_On_Basic_Cost__c;
                pp.Discount_Amount_On_Basic_Cost__c = mapParentDiscount.get(myId).Discount_Amount_On_Basic_Cost__c;
                pp.Discount_On_Floor_Rise_Cost__c = mapParentDiscount.get(myId).Discount_On_Floor_Rise_Cost__c;
                pp.Discount_Amount_On_Floor_Rise_Cost__c = mapParentDiscount.get(myId).Discount_Amount_On_Floor_Rise_Cost__c;
                pp.Discount_On_PLC_Cost__c = mapParentDiscount.get(myId).Discount_On_PLC_Cost__c;
                pp.Discount_Amount_On_PLC_Cost__c = mapParentDiscount.get(myId).Discount_Amount_On_PLC_Cost__c;
                pp.Discount_On_ITC_Basic_Cost__c = mapParentDiscount.get(myId).Discount_On_ITC_Basic_Cost__c;
                pp.Discount_On_ITC_Floor_Rise_Cost__c = mapParentDiscount.get(myId).Discount_On_ITC_Floor_Rise_Cost__c;
                pp.Discount_On_ITC_PLC_Cost__c = mapParentDiscount.get(myId).Discount_On_ITC_PLC_Cost__c;
                pp.Discount_Amount_On_ITC_Basic_Cost__c = mapParentDiscount.get(myId).Discount_Amount_On_ITC_Basic_Cost__c;
                pp.Discount_Amount_On_ITC_Floor_Rise_Cost__c = mapParentDiscount.get(myId).Discount_Amount_On_ITC_Floor_Rise_Cost__c;
                pp.Discount_Amount_On_ITC_PLC_Cost__c = mapParentDiscount.get(myId).Discount_Amount_On_ITC_PLC_Cost__c;
                pp.Pricing_Ref__c = mapParentDiscount.get(myId).Pricing_Ref__c;
                lstJodiPricing.add(pp);
            }
        }
        if(!lstJodiPricing.isEmpty() && lstJodiPricing.size() > 0){
            update lstJodiPricing;
        }
    }
    public static void salesOrderLineItem(Id billingPlanId){
        Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
        List<Sales_Order_Line_Item__c> lstSOLineItem = new List<Sales_Order_Line_Item__c>();
        Payment_Plan__c PaymentPlanObj = [SELECT Property__c,Tower__c,Related_Jodi_Billing_Plan__c,Total_Sales_Amount_Time_of_Booking__c,Total_Sales_Amount__c
                                          FROM Payment_Plan__c WHERE Id=:billingPlanId];
        Payment_Plan__c DefaultBillingPlan = [SELECT Id FROM Payment_Plan__c
                                              WHERE Tower__c=:PaymentPlanObj.Tower__c
                                              AND RecordTypeId=:defaultRecordTypeId
                                              AND Active__c=true];
        List<Payment_Plan_Line_Item__c> listPaymentPlanLineItem = [SELECT Id,Billing_Block_For_Payment_Plan__c,Date_Category__c,Date_Description__c,
                                                                           Percentage_Of_Value_To_Be_Invoiced__c,Value_to_be_Billed__c,Usage__c,
                                                                           Milestone_Number__c,Terms_of_Payment_Key__c,Payment_Group__c,
                                                                           Item_of_Payment_Plan__c,Description__c,Payment_Date__c,
                                                                           Rule_In_Payment_Plan__c,ID_For_Adopting_Billing__c
                                                                            FROM Payment_Plan_Line_Item__c
                                                                           WHERE Payment_Plan__c=:DefaultBillingPlan.Id];
        system.debug('listPaymentPlanLineItem '+listPaymentPlanLineItem);
        for(Payment_Plan_Line_Item__c planLineItem : listPaymentPlanLineItem){
            Sales_Order_Line_Item__c newItem = new Sales_Order_Line_Item__c();
                    newItem.Billing_Block__c = planLineItem.Billing_Block_For_Payment_Plan__c;
                    newItem.Date_Category__c = planLineItem.Date_Category__c;
                    newItem.Date_Description__c = planLineItem.Date_Description__c;
                    newItem.Milestone_Number__c = planLineItem.Milestone_Number__c;
                    newItem.Value_to_be_Billed__c = planLineItem.Value_to_be_Billed__c;
                    newItem.Usage__c = planLineItem.Usage__c;
                    newItem.Billing_Plan__c = billingPlanId;
                    newItem.Percentage_Of_Value_To_Be_Invoiced__c = planLineItem.Percentage_Of_Value_To_Be_Invoiced__c;
                    newItem.Item_of_Payment_Plan__c = planLineItem.Item_of_Payment_Plan__c;
                    newItem.Description__c = planLineItem.Description__c;
                    newItem.Payment_Date__c = planLineItem.Payment_Date__c;
                    newItem.Rule_In_Payment_Plan__c = planLineItem.Rule_In_Payment_Plan__c;
                    newItem.Terms_of_Payment_Key__c = planLineItem.Terms_of_Payment_Key__c;
                    newItem.ID_For_Adopting_Billing__c = planLineItem.ID_For_Adopting_Billing__c;
                    lstSOLineItem.add(newItem);
        }
        if(lstSOLineItem != null && lstSOLineItem.size()>0){
            insert lstSOLineItem;
        }
    }
}