public with sharing class CTPersonController {

public static String getToken(String mobileNo) {
    // passing string mobileno which is converted into bolb type
    Blob value = Blob.valueOf(mobileNo);

    //Crypto.generateDigest(String algorithmName, Blob input);
    Blob hash = Crypto.generateDigest('MD5', value);

    // get the String value of hash blob.
    return EncodingUtil.base64Encode(hash);
}

public static List<Person__c> getRecentHealthChange() {
    List<Person__c> PRec = [SELECT Id, Health_Status__c, Mobile__c, Name, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    return PRec;
}

public static List<Person__c> searchPeople(String searchTerm) {
    searchTerm = searchTerm + '%';
    List<Person__c> PRec = [SELECT Id, Health_Status__c, Mobile__c, Name, Status_Update_Date__c, Token__c FROM Person__c WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
    return PRec;
}

public static Person__c getPersonById(String personId) {
    List<Person__c> PRec = [SELECT Id, Health_Status__c, Mobile__c, Name, Status_Update_Date__c, Token__c FROM Person__c WHERE Id =: personId];
    if (PRec != null && PRec.size() > 0) {
        return PRec[0];
    }
    return null;
}

public static Map<String, Integer> getHealthStatusCount() {
    Map<String, Integer> healthCountMap = new Map<String, Integer>();
    for(AggregateResult res : [SELECT Health_Status__c, COUNT(Id) FROM Person__c GROUP BY Health_Status__c]) {
            //System.debug('Health status '+ res.get('Health_Status__c') + 'count : '+ res.get('expr0'));
            String HealthStaus = String.valueOf(res.get('Health_Status__c'));
            Integer Count = Integer.valueOf(res.get('expr0'));
            healthCountMap.put(HealthStaus, Count);
    }
    return healthCountMap;
}
}
