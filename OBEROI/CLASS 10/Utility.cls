/**
 * utility class for miscellaneous reusable methods
 */
public with sharing class Utility {
   
    /**
     * get query string parameter for a Visualforce page
     */
    
     public static string getPageParam(string param) {
        return ApexPages.currentPage().getParameters().get(param);
    }
      
    public static String changeToWords(String numb, boolean isCurrency){
        //String val = "", wholeNo = numb, points = "", andStr = "", pointStr="";
        String val ='';
        String wholeNo = numb;
        String points ='';
        String andStr ='';
        String pointStr ='';
        String endStr = (isCurrency) ? ('Only') : ('');
        integer decimalPlace = numb.IndexOf('.');
        log('>>>'+decimalPlace);
        if (decimalPlace > 0){
            wholeNo = numb.Substring(0, decimalPlace);
            points = numb.Substring(decimalPlace+1);
            log('>>>'+points);
       system.debug('=====point==='+points);
            if(points != '' && Integer.valueof(points) > 0){
                andStr = (isCurrency)?('and'):('point');// just to separate whole numbers from points/cents
                endStr = (isCurrency) ? ('Paise '+endStr) : ('');
                pointStr = translateCents(points);
            }
        }
        val = translateWholeNumber(wholeNo).Trim() + ' ' + andStr + pointStr + ' ' + endStr;
        log('>>> val: '+val);
       
        return val;
    }
    
    public static  String translateWholeNumber(String num){
        string word = '';
        boolean beginsZero = false;//tests for 0XX
        boolean isDone = false;//test if already translated
        log('>>> num: '+num);
        if((num != '' || num != null) && num.Substring(0, 1) == '-')
         num = num.Substring(1,num.Length());
        log('>>> num Now: '+num);
        double dblAmt = (num == '' || num == null) ? 0.0 : Double.valueof(num);
        if (dblAmt == 0)  return '';
        integer pos = 0;//store digit grouping
        String place = '';//digit grouping name:hundres,thousand,etc...
        //if ((dblAmt > 0) && number.StartsWith("0"))
        if (dblAmt < 0) dblAmt = -1*dblAmt;
        if (dblAmt > 0){//test for zero or digit zero in a nuemric
           
            log('>>> dblAmt: '+dblAmt);
           
            
            beginsZero = num.StartsWith('0');
            
            while(num.StartsWith('0')){
                if(num.Length() != 0)
                    num = num.subString(1,num.Length());
            }
            integer numDigits = num.Length();
            log('>>> numDigits: '+numDigits);
            //integer pos = 0;//store digit grouping
            //String place = '';//digit grouping name:hundres,thousand,etc...
            if(numDigits==1){
                word = ones(num);
                isDone = true;
            }
            if(numDigits==2){
                word = tens(num);
                isDone = true;
            }
            if(numDigits==3){//hundreds' range
                //pos = (numDigits % 3) + 1;
                pos=math.mod(numDigits, 3) +1;
                place = ' Hundred ';
            }
            if(numDigits==4 || numDigits==5){
                pos=math.mod(numDigits, 4) +1;
                place = ' Thousand ';
            }
            if (numDigits == 6 || numDigits == 7) {
                pos=math.mod(numDigits, 6) +1;
                place = ' Lakh ';
            }
                //case 7://millions' range
                //case 8:
            if(numDigits==8 ||numDigits==9){
                pos=math.mod(numDigits, 8) +1;
                place = ' Crore ';
            }
            if(numDigits==10){//Billions's range
                pos=math.mod(numDigits, 10) +1;
                place = ' Billion ';
            }
            log('>>>place: '+place);
       
            //add extra case options for anything above Billion...
            if(place == '' ){
                isDone = true;
            }
        }
        if (!isDone){//if transalation is not done, continue...(Recursion comes in now!!)
            word = translateWholeNumber(num.Substring(0, pos)) +
                place + translateWholeNumber(num.Substring(pos));
            log('>>> word: '+word.trim());
            //check for trailing zeros
            if (beginsZero) word = ' and ' + word.Trim();
        }
        //ignore digit grouping names
        if (word == null || word.Trim().Equals(place.Trim())) word = '';
       
        return word.Trim();
    }
    
    public static  String tens(String digit){
        integer digt = integer.valueof(digit);
       
        log('>>>digt: ' + digt);
       
        String name = null;
        if(digt==10){
            name = 'Ten';
        }
        if(digt==11){
            name = 'Eleven';
        }
        if(digt==12){
            name = 'Twelve';
        }
        if(digt==13){
            name = 'Thirteen';
        }
        if(digt==14){
            name = 'Fourteen';
        }
        if(digt==15){
            name = 'Fifteen';
        }
        if(digt==16){
            name = 'Sixteen';
        }
        if(digt==17){
            name = 'Seventeen';
        }
        if(digt==18){
            name = 'Eighteen';
        }
        if(digt==19){
            name = 'Nineteen';
        }
        if(digt==20){
            name = 'Twenty';
        }
        if(digt==30){
            name = 'Thirty';
        }
        if(digt==40){
            name = 'Fourty';
        }
        if(digt==50){
            name = 'Fifty';
        }
        if(digt==60){
            name = 'Sixty';
        }
        if(digt==70){
            name = 'Seventy';
        }
        if(digt==80){
            name = 'Eighty';
        }
        if(digt==90){
            name = 'Ninety';
        }
       
        if (name <> null && name <> '' && digt > 0) {
            if(digt > 10 && digt < 20 )
                name = name;
            else
            name = name + ones(digit.Substring(1));
        }
        else {
            if (digt > 0){
                name = tens(digit.Substring(0, 1) + '0') + ' ' + ones(digit.Substring(1));
            }
        }
        return name;
    }
    public static  String ones(String digit){
        log('>>>digt in ones: ' + digit);
        if (digit == '') return '';
        integer digt = integer.valueof(digit);
       
        String name = '';
        if(digt==1){
            name = 'One';
        }
        if(digt==2){
            name = 'Two';
        }
        if(digt==3){
            name = 'Three';
        }
        if(digt==4){
            name = 'Four';
        }
        if(digt==5){
            name = 'Five';
        }
        if(digt==6){
            name = 'Six';
        }
        if(digt==7){
            name = 'Seven';
        }
        if(digt==8){
            name = 'Eight';
        }
        if(digt==9){
            name = 'Nine';
        }
        return name;
    }
    public static  String translateCents(String cents){
        String cts = '', digit = '', engOne = '';
        /*
        for (integer i = 0; i < cents.Length(); i++){
            digit = cents.substring(i,i+1);//cents[i].ToString();
            if (digit.Equals('0')){
                engOne = 'Zero';
            }
            else {
                engOne = ones(digit);
            }
            cts += ' ' + engOne;
        }*/
        cts = ' ' + tens(cents);
        return cts;
    }
   
    public static void log(String msg) {
        //System.debug(msg);
    }
    
    public static FieldSetWrapper queryFieldsFromFieldSet(Set<string> alreadyQueryFields, String fieldSetName, String ObjectName ){
        FieldSetWrapper fswrap = new FieldSetWrapper();
        if(!fieldSetName.contains('PropStrength__'))
            fieldSetName = 'PropStrength__'+fieldSetName;
            
        if(alreadyQueryFields == null)
            alreadyQueryFields = new set<string>();
        List<Schema.FieldSetMember> fieldSetMembers = readFieldSet(fieldSetName,ObjectName);
        if(fieldSetMembers!=null){
        for(Schema.FieldSetMember fsm : fieldSetMembers ){
            String s = fsm.getFieldPath().toLowerCase();
       //     system.debug('====='+s);
            //if(s.contains('propstrength__'))
             //  s = s.Replace('propstrength__','');
               fswrap.queryfieldSet.add(s);
       //      system.debug('===s=='+s);
            if(!alreadyQueryFields.contains(s)){
                alreadyQueryFields.add(s);
                fswrap.queryfieldstring += ', '+ s;
            }    
        }
   //      system.debug('====fswrap ='+fswrap );
   		}
        return fswrap ;
    }
    
    public static FieldSetWrapper queryFieldsFromFieldSetwithRefObjectField(Set<String> alreadyQueryFields, String fieldSetName, string ObjectName, 
                        String refObjApiName , String refObjrefName, String refobjFieldSetName){
        FieldSetWrapper fswrap = queryFieldsFromFieldSet(alreadyQueryFields, fieldSetName, ObjectName);
        
        if(fieldSetName != null && !fieldSetName.contains('PropStrength__'))
            fieldSetName = 'PropStrength__'+fieldSetName;
        if(fieldSetName != null && !refobjFieldSetName.contains('PropStrength__'))
            refobjFieldSetName = 'PropStrength__'+ refobjFieldSetName;
            
        if(refObjApiName != null && refObjApiName != '' && refObjrefName != null && refObjrefName != '' && refobjFieldSetName != null && refobjFieldSetName != ''){
            for(Schema.FieldSetMember fsm : readFieldSet(refobjFieldSetName,refObjApiName)){
                String field = refObjrefName + '.'+fsm.getFieldPath();
                String s =field.toLowerCase();
                
               // if(s.contains('propstrength__'))
                //   s = s.Replace('propstrength__','');
                
                fswrap.queryfieldSet.add(s);
                if(!alreadyQueryFields.contains(s)){
                    alreadyQueryFields.add(s);  
                    fswrap.queryfieldstring += ', '+ s;
                }
            }
        }
        return fswrap;
    }
    
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName){
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
    
        //system.debug('====>' + DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName));
    
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
    
        //List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
        //system.debug('fieldSetMemberList ====>' + fieldSetMemberList);
        if(fieldSetObj!=null)
        {
        	return fieldSetObj.getFields(); 
        }
            return null;
	}  
    
    public static Datetime getLocalDateTime(Datetime z) {      
        Datetime l = z.Date();
        l = l.addHours(z.hour());
        l = l.addMinutes(z.minute());
        l = l.addSeconds(z.second());        
        return l;
    }
    
    public static Set<Id> getId(List<sObject> sobj, String field){
        Set<Id> result = new Set<Id>();
        for(sObject each : sobj){
            if(each.get(field) != null)
                result.add((Id)each.get(field));
        }
        return result;
    }

    public static Map<String, List<sObject>> groupBy(List<sObject> sobj, String field){

        Map<String, List<sObject>> result = new Map<String, List<sObject>>();

        for(sObject o : sobj){
            String k = o.get(field) + '';

            if(!result.containsKey(k))
                result.put(k, new List<sObject>());
            
            result.get(k).add(o);
        }

        return result;
    }
}