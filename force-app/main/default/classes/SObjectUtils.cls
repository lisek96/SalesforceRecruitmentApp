public with sharing class SObjectUtils {

    public LIst<Id> toIds(List<SObject> sObjects){
        List<Id> ids = new List<Id>();
        for(SObject sobj : sObjects){
            if(String.isBlank(sobj.Id)){
                continue;
            }
            ids.add(sobj.Id);
        }
        return ids;
    }
}