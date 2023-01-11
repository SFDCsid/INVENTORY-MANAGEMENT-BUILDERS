/****************************************************************************************************
Class covered :
1. ORL_Util - 7/6/2019 - 100%

****************************************************************************************************/
@isTest(seeAlldata=false)
public class ORL_UtilTest {

    static testMethod void buildQueryTest(){
        ORL_Util.buildQuery('Account');
        ORL_Util.buildQueryWithReference('Account', 'Name');
        String recId = ORL_Util.gtRecordtypeId('Account', 'Aditya Bhasin');
    }
    static testMethod void buildQueryTest2(){
        ORL_Util.buildQuery('ABC');
        ORL_Util.buildQueryWithReference('ABC', 'Name');
        String recId = ORL_Util.gtRecordtypeId('ABC', 'Aditya Bhasin');
    }
}