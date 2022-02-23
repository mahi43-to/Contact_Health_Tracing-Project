public with sharing class CTPeopleTracingController {
    public static List<People_Tracing__c> getTraces(String recordid) {
        return [SELECT Id, Name, Contact_Date__c, Person_1__c, Person_1__r.Token__c, Person_1__r.Health_Status__c, 
                    Person_2__c, Person_2__r.Token__c , Person_2__r.Health_Status__c 
                    FROM People_Tracing__c 
                    WHERE Person_1__c =:recordid OR Person_2__c =:recordid 
                    ORDER BY Contact_Date__c DESC];
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces) {
        //store uniques Person Ids
        Set<Id> personIds = new Set<Id>();
        
        for (People_Tracing__c trace : newPeopleTraces) {
            personIds.add(trace.Person_1__c);
            personIds.add(trace.Person_2__c);
        }

        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();
        
        // query exiting records
        List<People_Tracing__c> existingRecords = [SELECT Id, Person_1__c, Person_2__c
                                                        FROM People_Tracing__c 
                                                        WHERE Person_1__c IN: personIds
                                                        OR Person_2__c IN: personIds ];

         // list of duplicate records
         List<People_Tracing__c> duplicate = new List<People_Tracing__c>();


        if (existingRecords != null && existingRecords.size() > 0) {
            for (People_Tracing__c trace : existingRecords) {

                // Build map for person 1
                if (! mapOfExistingRecords.containsKey(trace.Person_1__c)) {
                    mapOfExistingRecords.put(trace.Person_1__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);

                // Build map for person 2
                if (! mapOfExistingRecords.containsKey(trace.Person_2__c)) {
                    mapOfExistingRecords.put(trace.Person_2__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
            }

            // loop over existing records to find duplicates
            for (People_Tracing__c trace : newPeopleTraces) {
                // check duplicate in map
                if ( 
                    (mapOfExistingRecords.containsKey(trace.Person_1__c) && mapOfExistingRecords.get(trace.Person_1__c).contains(trace.Person_2__c))
                    ||
                    (mapOfExistingRecords.containsKey(trace.Person_2__c) && mapOfExistingRecords.get(trace.Person_2__c).contains(trace.Person_1__c)) 
                ){
                    duplicate.add(trace);
                }   
            }
        }
       
        return duplicate;
    }
}
