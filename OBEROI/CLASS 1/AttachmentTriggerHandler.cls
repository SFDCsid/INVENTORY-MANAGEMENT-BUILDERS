public class AttachmentTriggerHandler {
public static set<id> IdSet = new set<Id>();
//public static Map <id, Attachment> existAttMap ; 
public static List <Attachment> AttachList ;


public static void afterInsertHandler(Map<id, Attachment> newAttMap){
    Map <id, List<Attachment>> existAttMap = new MAp<id, List<Attachment>>();
    List <Id> AttachList = new List<Id>();
    for(Attachment attc : newAttMap.values()){
        IdSet.add(attc.ParentId);
    } 
    if(IdSet.size() > 0){
        for(Attachment att: [SELECT id, Name, ParentId FROM Attachment WHERE ParentID IN: IdSet AND Id NOT IN: newAttMap.values()] ){
            if(existAttMap.get(att.ParentId) == null){
                existAttMap.put(att.ParentId,new List<Attachment>());
            }
            existAttMap.get(att.ParentId).add(att);
            system.debug(existAttMap+'existAttMap');
        }
    }
    system.debug('IdSet--->'+IdSet);
    if(existAttMap.size() > 0){
        for(Attachment attc : newAttMap.values()){
            if(existAttMap.get(attc.ParentId) !=  null){
                for(Attachment existingAttm : existAttMap.get(attc.ParentId)){
                    if(attc.Name == existingAttm.Name){
                        AttachList.add(existingAttm.Id); 
                        system.debug('AttachList---->'+AttachList+ AttachList.size());
                    }
                }
            }
       }
    }
    
    if(AttachList.size() > 0){
        //deleteAttachmentList(AttachList);
        Database.delete(AttachList) ;
    }
}

    
 public static void deleteAttachmentList(List<Attachment> AttList){
    // Delete AttList;
     
 }

}