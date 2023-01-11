trigger Duplicatecarparkslotno on Car_Park_Slot_No__c (before insert) {
    duplicatecarparkslotnohandler.mymethod1(trigger.new);
}