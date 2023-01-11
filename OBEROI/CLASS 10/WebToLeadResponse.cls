/**@author: IBM
  *@description: Web to Lead custom webservice response wrapper
  */
global class WebToLeadResponse {
   global String status;
   global String message;
   global static WebToLeadResponse parse(String json) {
      return (WebToLeadResponse) System.JSON.deserialize(json, WebToLeadResponse.class);
   }
}