public class JSON2ApexZB {

	public String address;
	public String status;
	public String sub_status;
	public Boolean free_email;
	public Object did_you_mean;
	public String account;
	public String domain;
	public String domain_age_days;
	public String smtp_provider;
	public String mx_found;
	public String mx_record;
	public Object firstname;
	public Object lastname;
	public Object gender;
	public Object country;
	public Object region;
	public Object city;
	public Object zipcode;
	public String processed_at;

	
	public static JSON2ApexZB parse(String json) {
		return (JSON2ApexZB) System.JSON.deserialize(json, JSON2ApexZB.class);
	}
}