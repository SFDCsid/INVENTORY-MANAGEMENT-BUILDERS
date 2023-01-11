<aura:application access="GLOBAL" extends="ltng:outApp" >
    <aura:dependency resource="c:NRIDeclarationError"/>
        <!-- Load the navigation events in the force namespace. -->
    <aura:dependency resource="markup://force:navigateToSObject" type="EVENT"/>
</aura:application>