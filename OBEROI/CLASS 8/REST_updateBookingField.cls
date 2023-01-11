@RestResource(urlMapping='/SAP_Integration/updateBookingField')
global class REST_updateBookingField {
   /* @HttpPost
    global static REST_result updateBookingField(String BookingId, String SONumber, Integer Amount_paid_excl_GST, Integer TDS_amount ,Integer balance_payable,Integer Part_Payment_towards_sale_price){
        REST_result r = new REST_result();    
        List<Booking__c> book=new List<Booking__c>();
        
        if(!String.isBlank(BookingId)){
            book=[select id, balance_payable__c,Amount_paid_excl_GST__c,TDS_amount__c,Part_Payment_towards_the_Sale_Price__c from booking__c where id=:BookingId limit 1];
        }
        else if(!String.isBlank(SONumber)){
            book=[select id, balance_payable__c,Amount_paid_excl_GST__c,TDS_amount__c,Part_Payment_towards_the_Sale_Price__c from booking__c where Sales_Document_SAP__c=:SONumber limit 1];
        }
        
        if(book.size() == 1){
            if(String.isBlank(String.valueOf(book[0].balance_payable__c))){
                book[0].balance_payable__c=balance_payable;
            }
            if(String.isBlank(String.valueOf(book[0].Amount_paid_excl_GST__c))){
                book[0].Amount_paid_excl_GST__c=Amount_paid_excl_GST;
            }
            if(String.isBlank(String.valueOf(book[0].TDS_amount__c))){
                book[0].TDS_amount__c=TDS_amount;
            }
            if(String.isBlank(String.valueOf(book[0].Part_Payment_towards_the_Sale_Price__c))){
                book[0].Part_Payment_towards_the_Sale_Price__c=Part_Payment_towards_sale_price;
            }
            try{
                update book;
                r.message='Success';
                r.returnCode=0;
            }catch(Exception e){
                r.message='Update Error : ' + e.getMessage();
                r.returnCode=1;
            }
            
        }else{
            r.message='Booking Not Found';
            r.returnCode=1;
        }
         
        return r;
    }  */
    global class REST_result{
        webservice string message;
        webservice Integer returnCode;  
    }  
}