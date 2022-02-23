public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChanges() {
        List<Location__c> LRec = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
        return LRec;
    }
    
    public static List<Location__c> searchLocations(String searchTerm) {
        searchTerm = searchTerm + '%';
        List<Location__c> LRec = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c WHERE Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
        return LRec;
    }

    public static Location__c getLocationById(String locationId) {
        List<Location__c> LRec = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c WHERE Id =: locationId];
        if(LRec != null && LRec.size() > 0) {
            return LRec[0];
        }
        return null;
    }

    public static Map<String, Integer> getStatusCount() {
        // AggregateResult[] result = [SELECT Status__c, COUNT(Id) FROM Location__c GROUP BY Status__c];
        Map<String, Integer> healthCountMap = new Map<String, Integer>();
        for(AggregateResult ar : [SELECT Status__c, COUNT(Id) total FROM Location__c GROUP BY Status__c]) {

            String HealthStatus = (String)ar.get('Status__c');
            Integer Count = (Integer)ar.get('total');
            healthCountMap.put(HealthStatus, Count);
        }
        return healthCountMap;
    }
}
