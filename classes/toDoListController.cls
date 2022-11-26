public with sharing class toDoListController {

    @AuraEnabled(cacheable=true)
    public static List<Task> getTask() {
          return[SELECT subject FROM task WHERE OwnerId=:UserInfo.getUserId()];
    }


@AuraEnabled
public static Task insertTask(string subject ){
    try {
        Task task = new Task(subject=subject,OwnerId = UserInfo.getUserId(),Status='Not Started', Priority = 'Normal');
        insert task;
        return task;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
        
    }
    
}

@AuraEnabled
public static Boolean deleteTask(Id recordId){
    try {
        Database.delete(recordId);
        return true;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
       
    }
    
}


}



