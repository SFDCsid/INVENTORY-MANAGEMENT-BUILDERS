@IsTest
public class JSON2ApexZB_Test {
	
	static testMethod void testParse() {
		String json = '{\"address\":\"yashhwanii@stetig.in\",\"status\":\"valid\",\"sub_status\":\"mailbox_not_found\",\"free_email\":false,\"did_you_mean\":null,\"account\":\"yashhwanii\",\"domain\":\"stetig.in\",\"domain_age_days\":\"2628\",\"smtp_provider\":\"g-suite\",\"mx_found\":\"true\",\"mx_record\":\"aspmx.l.google.com\",\"firstname\":null,\"lastname\":null,\"gender\":null,\"country\":null,\"region\":null,\"city\":null,\"zipcode\":null,\"processed_at\":\"2021-08-25 08:59:49.159\"}';
		JSON2ApexZB obj = JSON2ApexZB.parse(json);
		System.assert(obj != null);
	}
}