public class ContentTriggerHandler {
    public static void createPublicLinkForFile(Set<id> conid){        //getCreateDocList
        List<ContentVersion> contentVersions = [SELECT Id,title, versiondata, ContentDocumentId, FileType  FROM ContentVersion WHERE Id IN : conid];
        ContentDistribution[] distributionsToInsert = new List<ContentDistribution>();
        System.debug('Contentconversion :: '+contentVersions);
        
        for(ContentVersion objContentVersion : contentVersions){
            //if image uploaded then only create public link
            if(objContentVersion.FileType.toLowerCase()=='pdf'){
               
                system.debug('objContentVersion.FileExtension.toLowerCase():' + objContentVersion.FileType);
                List<ContentDistribution> CDList = [Select id,ContentVersionId,Name,PreferencesNotifyOnVisit from ContentDistribution where ContentVersionId =: objContentVersion.id];
                if(CDList.size() == 0){
                    
                    distributionsToInsert.add(createContentDistribution(objContentVersion.Id));
                }
            }
        }
        if(!distributionsToInsert.isEmpty())
        {
            system.debug('distributionsToInsert :::::'+distributionsToInsert);
        insert distributionsToInsert;
            system.debug('Inserted CD');
        }
        
       //return distributionsToInsert;
    }
   
    public static ContentDistribution createContentDistribution(Id contentVersionId){
        ContentDistribution newDist = new ContentDistribution();
        newDist.ContentVersionId = contentVersionId;
        newDist.Name = 'External Link '+contentVersionId;
        newDist.PreferencesNotifyOnVisit = false;
        newDist.PreferencesAllowViewInBrowser = true;
        newDist.PreferencesAllowOriginalDownload=false;
        system.debug('createContentDistribution creted');
        return newDist;
        
    }
}