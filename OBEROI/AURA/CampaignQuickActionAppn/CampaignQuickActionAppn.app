<aura:application access="GLOBAL" extends="ltng:outApp">
	<c:CampaignQuickAction /> <!-- extends="ltng:outApp" -->
   <!-- <aura:dependency resource="c:CampaignQuickAction"/>
    var toastEvent = $A.get("e.force:createRecord");-->
    <aura:dependency resource="markup://force:*" type="EVENT"/>
    <aura:dependency resource="markup://force:navigateToURL" type="EVENT"/>
</aura:application>