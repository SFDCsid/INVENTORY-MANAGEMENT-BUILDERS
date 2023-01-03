//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 04-10-2022
//-------------------------------------------//
public class Ex_InventoryPageController {
  	public String selectPro {get;set;}
    public String selectTower {get;set;}
    public String selectFloorBand {get;set;}
    public String selectSector {get;set;}
    public List<Decimal> floorUpwardList {get;set;}
    public Map<Decimal, List<Unit__c>> unitFloorMap {get;set;}
    public Id oppId {get;set;}
    public List<Opportunity__c> oppList {get;set;}
    public String ProjectId {get;set;}
    public String errorMsg {get;set;}
    public boolean error {get;set;}
    public Integer Booked {get;set;}
    public Integer Vacant {get;set;}
    public Integer Blocked {get;set;}
    public Integer NotSale {get;set;}
    public String unitId {get;set;}
    public String actionType {get;set;}
    
    public Ex_InventoryPageController() {
        actionType = '';
        oppId = Null;
        oppList = new List<Opportunity__c>();
        
        actionType = ApexPages.currentPage().getParameters().get('action');
        system.debug('actionType: '+actionType);
        oppId = ApexPages.currentPage().getParameters().get('opId');
        system.debug('oppId: '+oppId);
        if(oppId != Null) {
            oppList = [Select Id, Name, StageName__c, Project__c, IsActive__c from Opportunity__c where Id =: oppId];
            if(!oppList.isEmpty()) {
                selectPro = oppList[0].Project__c;
                if(!oppList[0].IsActive__c) {
                    errorMsg = 'This opportunity is not active. Please create new opportunity to proceed.';
                    error = true;
                }
            }
        }
    }
    
    public List<SelectOption> getProjectList {
        get {
            List<Project__c> projectList = [Select Id, Name from Project__c ORDER BY Name ASC];
            system.debug('projectList: '+projectList);
            
            List<SelectOption> proList = new List<SelectOption>();
            proList.add(new selectOption('','-- Select Project --'));
            for(Project__c p : projectList) {
                proList.add(new selectOption(p.Id, p.Name));
            }
            return proList;
        }
        set;
    }
    
      
    public List<SelectOption> getSectorList {
        get {
            List<Sector__c> sectorList = [Select Id, Name from  Sector__c where Project__c =: selectPro ORDER BY Name ASC];
            system.debug('sectorList: '+sectorList);
            
            List<SelectOption> sList = new List<SelectOption>();
            sList .add(new selectOption('','-- Select Sector --'));
            for(Sector__c s : sectorList) {
                sList.add(new selectOption(s.Id, s.Name));
            }
            return sList;
        }
        set;
    }

     public List<SelectOption> getTowerList {
        get {
            List<Tower__c> towerList = [Select Id, Name from Tower__c where Sector__c =: selectSector ORDER BY Name ASC];
            system.debug('towerList: '+towerList);
            
            List<SelectOption> tList = new List<SelectOption>();
            tList.add(new selectOption('','-- Select Tower --'));
            for(Tower__c t : towerList) {
                tList.add(new selectOption(t.Id, t.Name));
            }
            return tList;
        }
        set;
    }
    
    public List<Decimal> getUnit {
        get {
            floorUpwardList = new List<Decimal>();
            unitFloorMap = new Map<Decimal, List<Unit__c>>();
            List<Unit__c> unitList = new List<Unit__c>();
            
            Booked =0;
            Vacant =0;
            Blocked =0;
            NotSale =0;
            
            system.debug('Project : '+ selectPro + ' Tower: '+ selectTower);
            
            if(selectPro != Null && selectTower != Null ) {
                unitList = [Select Id, Name, Floor__c, Unit_Status__c, Configuration__c, RERA_Carpet_Area_Sq_Ft__c,Total_Carpet_Area_Sq_Ft__c,
                            Custodian_Type__c from Unit__c 
                            where Project__c =: selectPro AND Tower__c =: selectTower ORDER BY Floor__c DESC, Name ASC];
                system.debug('unitList: '+unitList);
                
                
                for(Unit__c un : unitList) {
                    if(un.Unit_Status__c == 'Booked') {
                        Booked++;
        			}
                    if(un.Unit_Status__c == 'Vacant') {
                        Vacant++;
        			}
                    if(un.Unit_Status__c == 'Blocked by Sales') {
                        Blocked++;
        			}
                    if(un.Unit_Status__c == 'Not for Sale') {
                        NotSale++;
        			}
                    if(!unitFloorMap.containsKey(un.Floor__c)) {
                        List<Unit__c> newList = new List<Unit__c>();
                        newList.add(un);
                        unitFloorMap.put(un.Floor__c, newList);
                    } else {
                        unitFloorMap.get(un.Floor__c).add(un);
                    }
                }
                floorUpwardList.addAll(unitFloorMap.keySet());
            }
            return floorUpwardList;
        }
        set;
    }
    
    /*public PageReference redirectToSuccessPage()
    {
        PageReference pg = new PageReference('/apex/successPage');
        	pg.setRedirect(true);
        pg.getParameters().put('uId',UnitId);
        system.debug('redirect true: '+ pg);
        return pg;
    }*/
}