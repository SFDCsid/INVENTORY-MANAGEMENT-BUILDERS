public with sharing class PRACTICECLASS {
    public PRACTICECLASS() {

    }
    /*
    @AuraEnabled (cacheable=true)
    public static List<QUOTATION__c> getQuotation(List<QUOTATION__c> newQuotrecords){
      //  string rcId;
        List<QUOTATION__c> quoLis = new List<QUOTATION__c>();
         for(List<QUOTATION__c> quo:newQuotrecords){
            quoLis.add(quo.Id);
        // rcId = quo.Id;
        // system.debug(rcId);
         }
         return quoLis;
    }*/

    @AuraEnabled (cacheable=true)
    public static QUOTATION__c quotationMethod(){
        list<QUOTATION__c> quotationlist = [SELECT Id  FROM  QUOTATION__c ORDER BY CreatedDate DESC];
      return quotationlist[0];
     
    }



    @AuraEnabled (cacheable=true)
    public static map<Id , string> projectMethod(){
    map<Id , string> projectmap= new map<Id , string>();
    list<project__c> projectlist = [SELECT Id,Name FROM project__c];
    for(project__c pMap : projectlist){
        projectmap.put(pMap.Id , pMap.Name);
    }
    return projectmap;
    }


  

    @AuraEnabled (cacheable=true)
    public static map<Id , string> sectorMethod(string Id){
    map<Id , string> sectorMap= new map<Id , string>();
    list<Sector__c> sectorList = [SELECT Id,Name FROM Sector__c WHERE Project__r.Id =: Id];
    for(Sector__c secMap : sectorList){
        sectorMap.put(secMap.Id , secMap.Name);
    }
    return sectorMap;
    }

    @AuraEnabled (cacheable=true)
    public static map<Id , string> towerMethod(string Id){
    map<Id , string> towerMap= new map<Id , string>();
    list<Tower__c> towerList = [SELECT Id,Name FROM Tower__c WHERE 	Sector__r.Id =: Id];
    for(Tower__c toMap : towerList){
        towerMap.put(toMap.Id , toMap.Name);
    }
    return towerMap;		
    }

    @AuraEnabled (cacheable=true)
    public static map<Id , string> unitMethod(string Id){
    map<Id , string> unitMap= new map<Id , string>();
    list<Unit__c> unitList = [SELECT Id,Name  FROM Unit__c WHERE Tower__r.Id =: Id];
    for(Unit__c toUnit : unitList){
        unitMap.put(toUnit.Id , toUnit.Name);
    }
    return unitMap;		
    }

    @AuraEnabled (cacheable=true)
    public static list<Unit__c> unitDisplay(string Id){
    list<Unit__c> unitList = [SELECT Id,Name ,Floor__c, Carpet_Area__c,	Status__c FROM Unit__c  WHERE Tower__r.Id =: Id ];
    return unitList;
    }

    @AuraEnabled (cacheable=true)
    public static map<Decimal , list<string>> unitHtml(string Id){
    map<Decimal , list<string>> htmlmap = new map<Decimal , list<string>>(); 
    system.debug(htmlmap) ; 
    list<Unit__c> unitList = [SELECT Id,Name ,Floor__c,Carpet_Area__c,	Status__c  FROM Unit__c  WHERE Tower__r.Id =: Id ORDER BY Floor__c DESC ];
    for(Unit__c m:unitList){
        if(!htmlmap.containskey(m.Floor__c)){
        htmlmap.put(m.Floor__c , new list<string>());}
        htmlmap.get(m.Floor__c).add(m.Name);
      //  htmlmap.get(m.Floor__c).add(String.valueOf(m.Carpet_Area__c));
      //  htmlmap.get(m.Floor__c).add(m.Status__c);
    }

   SYSTEM.DEBUG('MAPTL'+htmlmap.values());
   


    system.debug(htmlmap);
       return htmlmap;
       
    
    }



    @AuraEnabled (cacheable=true)
    public static map<Decimal , list<Unit__c>> unitHtml2(string Id){
    map<Decimal , list<Unit__c>> htmlmap2 = new map<Decimal , list<Unit__c>>(); 
    list<Unit__c> unitList = [SELECT Id,Name ,Floor__c,Carpet_Area__c,	Status__c,	configuration__c,	Type__c,	Salable_Area__c  FROM Unit__c  WHERE Tower__r.Id =: Id ORDER BY Name ASC ];
    
    for(Unit__c p:unitList){
        if(!htmlmap2.containskey(p.Floor__c)){
            htmlmap2.put(p.Floor__c , new list<Unit__c>());
            System.debug(htmlmap2);
        }
        htmlmap2.get(p.Floor__c).add(p);
        
    }
       return htmlmap2;
    }
   
    

/*
    @AuraEnabled (cacheable=true)
    public static map<Decimal , list<Unit__c>> unitHtml(string Id){
    map<Decimal , list<string>> htmlmap = new map<Decimal , list<string>>(); 
    system.debug(htmlmap) ; 
    list<Unit__c> unitList = [SELECT Id,Name ,Floor__c,Carpet_Area__c,	Status__c  FROM Unit__c  WHERE Tower__r.Id =: Id ORDER BY Floor__c DESC ];
    for(Unit__c m:unitList){
        if(!htmlmap.containskey(m.Floor__c)){
        htmlmap.put(m.Floor__c , unitList);}
       // htmlmap.get(m.Floor__c).add(m.Name);
      //  htmlmap.get(m.Floor__c).add(String.valueOf(m.Carpet_Area__c));
      //  htmlmap.get(m.Floor__c).add(m.Status__c);
    }
/*
   for(Unit__c h:unitList){
    htmlmap.get(h.Floor__c).add(String.valueOf(h.Carpet_Area__c));
   }
   
    system.debug(htmlmap);
       return htmlmap;
       
    
    }
*/
   
    @AuraEnabled (cacheable=true)
    public static map<string , list<string>> carpetHtml(string Id){
        map<string , list<string>> carpetMap = new map<string , list<string>>(); 
        list<Unit__c> unitList = [SELECT Name,Carpet_Area__c,Status__c  FROM Unit__c  WHERE Tower__r.Id =: Id ORDER BY Floor__c DESC ];
        for(Unit__c c:unitList){
            if(!carpetMap.containskey(c.Name)){
                carpetMap.put(c.Name ,new list<string>());}
                carpetMap.get(c.Name).add(String.valueOf(c.Carpet_Area__c));
                carpetMap.get(c.Name).add(c.Status__c);
            }
        return carpetMap;
        
    }


 


    @AuraEnabled (cacheable=true)
    public static list<Decimal> listSort (string Id){
        set<Decimal> listSt = new set<Decimal>();
        list<Unit__c> ust = [SELECT Id,Name ,Floor__c  FROM Unit__c  WHERE Tower__r.Id =: Id ORDER BY Floor__c DESC ];
        for(Unit__c m:ust){
            listSt.add(m.Floor__c);
        }
        list<Decimal> reverseList = new list<Decimal>(listSt);
        return reverseList;
        
    }


    @AuraEnabled (cacheable=true)
    public static list<Unit__c> testUnit (string Id){
    set<Decimal> noFloors = new set<Decimal>();
    
    list<Unit__c> noflo = [SELECT Id, Name, Floor__c FROM Unit__c];
    for (Unit__c f : noflo){
        noFloors.add(f.Floor__c);
    }
    system.debug('nf'+noFloors);

    integer len= noFloors.size();
    system.debug('size'+len);

    list<Unit__c> uList =  [SELECT Id,Name ,Floor__c  FROM Unit__c  WHERE Tower__r.Id =: Id  and Floor__c IN:noFloors ];
    system.debug('f'+uList);
       return uList;
    }


    @AuraEnabled (cacheable=true)
    public static list<Unit__c> dataTable(string Id){
    list<Unit__c> unist = [SELECT Id,Name ,Floor__c ,Status__c,Carpet_Area__c FROM Unit__c WHERE Tower__r.Id =: Id ];
    return unist;
    }



    @AuraEnabled (cacheable=true)
    public static list<Unit__c> loop(string Id){
    map<Decimal , list<string>> htmlmap = new map<Decimal , list<string>>(); 
    system.debug(htmlmap) ; 
    list<Unit__c> unitList = [SELECT Id,Name ,Floor__c  FROM Unit__c  WHERE Tower__r.Id =: Id ];
    for(Unit__c m:unitList){
        if(!htmlmap.containskey(m.Floor__c)){
        htmlmap.put(m.Floor__c , new list<string>());}
        htmlmap.get(m.Floor__c).add(m.Name);
    }
    system.debug(htmlmap);
       return unitList;
    }


  


    @AuraEnabled(cacheable=true)
    public static List<Unit__c> getFloor(String Id){
        Set<Unit__c> floorSet = new Set<Unit__c>();
        for(Unit__c floor:[select Floor__c from  Unit__c where Tower__r.Id=:Id ORDER BY Floor__c DESC ]){  
            floorSet.add(floor); 
            }
            list<Unit__c> floorList = new list<Unit__c>();
            for (Unit__c f : floorSet){
                floorList.add(f);
            }
            
            return floorList;
           
        }

        @AuraEnabled(cacheable=true)
        public static Map<Decimal,List<Unit__c>> getUnits(String Id){
            Map<Decimal,List<Unit__c>> unitMap = new Map<Decimal,List<Unit__c>>(); //MAP
            List<Unit__c> unitList = [select Floor__c,Name from Unit__c where Tower__r.Id=:Id];
            for(Unit__c unitDetails : unitList){ 
                unitMap.put(unitDetails.Floor__c,unitList);
                
                if(unitMap.containsKey(unitDetails.Floor__c)){
                    List<Unit__c> dataList = [select Name,Status__c from Unit__c where Unit__c.Floor__c=: unitDetails.Floor__c];
                    unitMap.put(unitDetails.Floor__c,dataList);
                    //List<Unit__c> keyList = unitMap.get(unitDetails.Floor__c);
                    //unitMap.put(unitDetails.Floor__c,keyList);
                }else {
                    unitMap.put(unitDetails.Floor__c,unitList);
                }
            } //system.debug(unitMap);
            return unitMap;
        }

        @AuraEnabled(cacheable=true)
        public static list<Unit__c> unt(String Id){
           return [select Floor__c,Name,Status__c, configuration__c,Type__c,Salable_Area__c from Unit__c where Tower__r.Id=:Id];  
        }

        /* List<test> tet = [query];
            if(floor__c=1)
            unt.add(tet);
            ret unt;

         */



           
           
        @AuraEnabled (cacheable=true)
        public static map<Decimal , string> keyvalueMap(string Id){
            map<Decimal , string> keyvalueMap = new map<Decimal , string>(); 
            list<Unit__c> kValue = [SELECT Id,Name ,Floor__c ,Status__c FROM Unit__c  WHERE Tower__r.Id =: Id  ];
            for(Unit__c m:kValue){
                keyvalueMap.put(m.Floor__c , m.Name);
             }
             return   keyvalueMap; 
        }


        @AuraEnabled (cacheable=true)
        public static map<string , Decimal> valuekeyMap(string Id){
            map<string , Decimal> keyvalueMap = new map<string , Decimal>(); 
            list<Unit__c> kValue = [SELECT Id,Name ,Floor__c  FROM Unit__c  WHERE Tower__r.Id =: Id ORDER BY Floor__c DESC ];
            for(Unit__c m:kValue){
                keyvalueMap.put(m.Name , m.Floor__c);
             }
             return   keyvalueMap; 
        }


        @AuraEnabled (cacheable=true) 
        public static list<Unit__c> temList (string Id){
            list<Unit__c> kValue = [SELECT Id,Name ,Floor__c,Carpet_Area__c,Status__c  FROM Unit__c  WHERE Tower__r.Id =: Id ];
            return kValue;
        }

       

    }
    
/*
    @AuraEnabled (cacheable=true)
    public static list<Unit__c> perUnit (string Id){
        list<Unit__c> utList = [SELECT Name ,Floor__c  FROM Unit__c  WHERE Tower__r.Id =: Id AND Floor__c=: i ];
        
        for(var i = 1 ; i<len ; i++){
            for
        }
        return utList;
    }


    

    @AuraEnabled (cacheable=true)
    public static List<Unit__c> unitDisplay(string Id){
    List<string> unitlt = new List<string> ();
    map<Id , string> unitMap= new map<Id , string>();
    list<Unit__c> unitList = [SELECT Id,Name FROM Unit__c WHERE Tower__r.Id =: Id ORDER BY Floor__c ASC];
    for(Unit__c toUnit : unitList){
        unitMap.put(toUnit.Id , toUnit.Name);
        
    }
    return unitList;		
    } 


*/

/*
        @AuraEnabled (cacheable=true)
        public static map<string , Decimal> unitMap(string Id){
        map<string , Decimal> finalmap = new map<string , Decimal>(); 
        system.debug(finalmap) ; 
        list<Unit__c> unitList = [SELECT Id,Name ,Floor__c  FROM Unit__c  WHERE Tower__r.Id =: Id ORDER BY Floor__c DESC ];
        for(Unit__c m:unitList){
           finalmap.put(m.Name , m.Floor__c);
        }
             return   finalmap; 
        }  */