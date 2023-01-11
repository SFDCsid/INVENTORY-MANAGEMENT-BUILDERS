public class TestDataFactory1 {

    Public static Map<String,Id> createData(){
        Map<String,Id> dataMap = new Map<String,Id>();
        
        Tower__c t = new Tower__c();
        //site Details
        Site__c site = new Site__c();
        site.Name = 'Goregaon';
        site.Active__c = true;
        site.OwnerId = UserInfo.getUserId();
        insert site;
        dataMap.put('SITE',site.id);
        
        //Create Project
        Project__c p = new Project__c();
        p.Name = 'Elysian Tower A';
        p.Project_Code__c = 'OEY - A';
        p.Type_Of_Project__c = 'Residential';
        p.Active__c = true;
        p.Sub_Category__c = 'Plots';
        p.Status__c = 'Under Construction';
        p.License_Number__c = '123456';
        p.Launch_Date__c =  System.today();
        p.Measurement__c = 'Sq. Yards';
        p.Completion_Certification_Received__c = false;
        p.Expected_Start_Date__c = System.today();
        p.Elite_Club_series__c = 12345;
        p.Expected_End_Date__c = System.today().adddays(120);
        p.Company_PAN__c = 'AABCK0235H';
        p.Actual_Construction_Start_Date__c = System.today();
        p.Actual_Construction_End_Date__c = System.today().adddays(365);
        p.STC_No__c = '76543';
        p.CIN_No__c = '123';
        p.Service_Tax_Notification_No__c = '01234';
        p.C_T_S_No__c = 'ha123';
        p.TDS_Start_Date__c = System.today();
        p.GST_No__c = 23415;
        p.MahaRERA_Registration_No__c = 'RERA123';
        p.Bearing_No__c = 'ABC123';
        p.MVAT_Account__c = 'MVAT_Acc';
        p.Site__c = site.Id;
        p.Ready_Rck_Rate__c = 100.89;
        p.Image_Path__c = 'imagepath';
        p.Project_Logo__c = 'Logo';
        p.Google_Map_Link__c = 'map.googlemap.com';
        p.SAP_Project_Code__c = '12345';
        p.RERA_Description__c = 'MahaRERA registration';
        p.Min_Budget_for_2_BHK__c = 2000000;
        p.Min_Budget_for_2_5_BHK__c = 2500000;
        p.Min_Budget_for_3_BHK__c = 3000000;
        p.Min_Budget_for_4_BHK__c = 4000000;
        p.Min_Budget_for_5_BHK__c = 5000000;
        p.Min_Budget_for_Duplex__c = 20000000;
        p.Min_Budget_for_Penthouse__c = 50000000;
        p.EOI_Link__c = 'https://www.EOI.com';
        p.Launch_date_SMS_Text__c = 'launchdateSMS';
        p.Quotation_Validity__c = 8;
        p.NPV__c = 0;
        p.Last_Possession_date__c = System.today().adddays(15);
        p.Early_Possession_date__c = System.today();
        p.Terms_And_Conditions__c = 'Project Clause:';
        p.Revised_Quotation_Validity__c = 8;
        p.Approver1__c = UserInfo.getUserId();
        p.Approver2__c = UserInfo.getUserId();
        p.Allotment_case_generation__c = 10;
        p.Broker_Percentage__c = 2;
        p.Effective_Sale_Price_Applicable__c = true;
        p.Promoter_s_Email_Address__c = 'customer.service@oberoirealty.com';
        p.Promoter_s_PAN__c = 'AADCI5238A';
        p.Car_Park_Type_1__c = 'SINGLE';        //Car Park Charge Details
        p.Car_Park_Type_2__c = 'TANDEM';
        p.Car_Park_Charge_1__c = 700000;
        p.Car_Park_Charge_2__c = 1200000;
        p.Sales_Organization__c = '1131';         //SAP Fields
        p.Sales_Document_Type__c = 'salesDoc';
        p.Plant__c = '11AM';
        p.Company_name__c = '1100';
        p.Customer_Account_Group__c = 'cAccGroup';
        p.Sales_group_email_id__c = 'salesgroup@gmail.com';  //Team Information
        p.Company_Email__c = 'company@gmail.in';
        p.PMT_Team__c = 'PMTTeam@gmail.com';
        p.Marcom_Head__c = UserInfo.getUserId();
        p.Marcom_Manager__c = UserInfo.getUserId();
        p.MD__c = UserInfo.getUserId();
        p.CFO__c = UserInfo.getUserId();
        p.RM_User__c = UserInfo.getUserId();
        p.Subsidiary_Company_Name__c = 'Oberoi Realty Ltd';    //Company Information
        p.Other_Company_Phone__c = '22 6677 3333';
        p.Other_Company_Fax__c = '22 6677 3333';
        p.Other_Company_Website__c = 'http://www.oberoirealty.com';
        p.Subsidiary_Company_Address__c = 'Oberoi Realty Ltd';
        p.Other_Company_Postal_Code__c = '411002';
        p.Site_Head__c = UserInfo.getUserId();                         //Site Related Details
        p.Project_Site_Office_Address__c = 'Project Site Address';
        p.Material_No_Single_Parking__c = 'OEY-CP-SINGLE';        //Car Parking Material No
        p.Material_No_Tandem_Parking__c = 'OEY-CP-TANDEM';
        p.Material_No_Triple_Parking__c = 'OEY-CP-TRIPLE';
        p.X_of_Single_Parking__c = 1;                  //Car Parking Inventory Details
        p.X_of_Tandem_Parking__c = 2;
        p.X_of_Triple_Parking__c = 3;
        p.X_of_Single_Parking_Remaining__c = 1;
        p.X_of_Tandem_Parking_Remaining__c = 2;
        p.X_of_Triple_Parking_Remaining__c = 3;
        p.Total_Properties__c = 100;              //Property Details
        p.Total_Allotted_Properties__c = 50;
        p.Total_Sold_Properties__c = 50;
        p.Total_OnHold_Property__c = 40;
        p.Available_Properties__c = 30;
        p.Budget__c = 'Exclusive';             //other Details
        p.Transfer_Applicable__c = 10;
        p.Forfeiture__c = 2;
        p.Grace_Days__c = 50;
        p.First_Booking_Date__c = System.today();
        p.Rate_For_Holding_Charges__c = 10000;
        p.Rate_For_Maintenance_Charges_Possession__c =20000;
        p.Is_First_Transfer_Free__c = true;
        p.VAT_Applicable__c = true;
        p.VAT__c = 10;
        p.VAT_Chargeable_Type__c = 'Demand';
        p.Project_Area_Sq_ft__c = 800;
        p.Available_for_Datasheet__c = true;   //Datasheet Details
        p.Possession_Timeline__c = '2 Year';
        p.Required_percentage_for_Allotment__c = 10;   //Allotment Letter Fields
        p.Force_Majeure_Circumstances_Charges__c = 10;
        p.Force_Majeure_Circumstances_Charges_P_M__c = 100;
        p.Force_Majeure_Circumstances_Amount__c = 100000;
        p.Current_Bank_NOC_No__c = 'NOC123';
        p.Bank_NOC_Series_From__c = 'NOCFrom';
        p.Bank_NOC_Series_To__c = 'NOCTo';
        p.Mortgage_NOC_RL_Series_From__c = 'MortagageNOCFrom';
        p.Current_Mortgage_NOC_RL_No__c = 'Mortagage123';
        p.Mortgage_NOC_RL_Series_To__c = 'MortagageNOCTo';
        p.Carpet_Area_variation__c = 200;
        p.Carpet_Area_Upto__c = 800;
        p.Termination_Period__c = 2;
        p.Current_AL_No__c = 'AL12';
        p.AL_Series_From__c = 'ALFrom';
        p.AL_Series_To__c = 'ALTo';
        p.Registration__c = 10;                                   //Registration Information
        p.Registration_Vendor_Contact_Details__c = 'vendorcontact';
        p.Developers_Power_of_Attorney_for_Registr__c  = 'devPower';
        p.Registration_Office_Venue__c = 'officevenue';
        p.Agent_and_other_Charges__c = 200;
        p.Club_House_Completion_Date__c = System.today().adddays(50);
        p.Stampy_Duty__c = 10;
        p.Occupation_Certificate_Application_Date__c = System.today().adddays(150);
        p.Occupation_Certificate_Issued_Date__c = System.today().adddays(100);
        p.Registration_Fees__c = 2345;
        p.Registration_A_c_Branch_Address__c = 'ACAddress';
        p.Registration_A_C_Name__c = 'ACName';
        p.Registration_Bank_IFSC_Code__c = 'IFSC1234';
        p.Registration_Bank_Name__c = 'BankName';
        p.Street__c = 'street';                                      //Address
        p.City__c = 'city';
        p.Location__c = 'Mumbai';
        p.State_Province__c = 'state';
        p.Country__c = 'india';
        p.Zip_Postal_Code__c = '411123';
        p.Description__c = 'discription';                //Description
        p.AR_Finance__c = UserInfo.getUserId();                  //ORL Users
        p.Site_Support__c = UserInfo.getUserId();
        p.Central_Support__c = UserInfo.getUserId();
        p.Sales_Head__c = UserInfo.getUserId();
        p.Front_Desk_User__c = UserInfo.getUserId();
        p.ITC_BENEFIT__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.UPFRONT_PAYMENT__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.Bare_shell_1__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.Bare_shell_with_Reduction_in_Sale_Price__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.Bare_shell_NC_in_SalePrice_and_no__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.Exq_D_P_BS_no_change_in_SP_and_no_MHO__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.Bank_Subvention_Scheme__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.Flexi_Payment_Scheme__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.Construction_Linked_Payment_Scheme__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.STUDIO_APARTMENT__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';
        p.Limited_BS_no_change_in_SPrice_no_MHO__c = 'The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.';        
        insert p;
        dataMap.put('PROJECT',p.id);
        
        //Car Parking Details
        Car_Parking__c cp = new Car_Parking__c();
        cp.Name = 'OEY-CP-TANDEM';
        cp.Active__c = true;
        cp.Project__c = p.Id;
        cp.Remarks__c = 'ELYSIAN TOWER A CARPARK - TANDEM - 1 NO.';
        cp.Status__c = 'Available';
        cp.Additional_Earmarked__c = 'Additional';
        insert cp;
        dataMap.put('CAR_PARK',cp.id);
        
        Car_Parking__c cp2 = new Car_Parking__c();
        cp2.Name = 'OEY-CP-TANDEM';
        cp2.Active__c = true;
        cp2.Project__c = p.Id;
        cp2.Remarks__c = 'ELYSIAN TOWER A CARPARK - TANDEM - 1 NO.';
        cp2.Status__c = 'Available';
        cp2.Additional_Earmarked__c = 'Earmarked';
        insert cp2;
        
        Car_Parking__c cp3 = new Car_Parking__c();
        cp3.Name = 'OEY-CP-SINGLE';
        cp3.Active__c = true;
        cp3.Project__c = p.Id;
        cp3.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        cp3.Status__c = 'Available';
        cp3.Additional_Earmarked__c = 'Earmarked';
        insert cp3;
        
        //Discount
        Discount__c dis = new Discount__c();
        //dis.Name = 'Discount-00020';
        dis.Project__c = p.Id;
        dis.Editable__c = false;
        dis.Start_Date__c = system.today();
        dis.End_Date__c = system.today().adddays(15);
        dis.Type__c = 'Lumpsum';
        dis.Reason__c = 'Other Discount';
        dis.Lumpsum_Amount__c = 1000.00;
        //dis.Basic_Amount__c = 10000;
        //dis.Floor_Rise_Amount__c = 2000;
        //dis.PLC_Amount__c = 5000;
        dis.Total__c = 1000;
        insert dis;
        dataMap.put('DISCOUNT',dis.id);
        
        //Tower Details 
        t.Tower_Name__c = 'A';
        t.Project_Name__c = p.Id;
        //t.Billing_Plan__c = bp.Id;
        t.Tower_Code__c = 'tcode123';
        t.Total_Floors__c = 100;
        t.Actual_Construction_End_Date__c = system.today().adddays(365);
        t.Bank_account_of_the_Promoter__c = 'Bank';
        t.Search_Term__c = 'steam';
        t.Customer_A_C_Group__c = 3350;
        t.Completion_Certificate_Received__c = false;
        t.Completion_Certificate_Date__c = system.today().adddays(365);
        t.Type__c = 'typeA';
        t.Tower_Area_Sq_ft__c = 800;
        t.Tower_Area_Sq_mt__c = 1000;
        t.Active__c = true;
        t.Image_Path__c = 'imagepath';
        t.SAP_Code__c = '1234';
        t.Available_Properties__c = 500;
        t.Allotted_Properties__c = 500;
        t.Sold_Properties__c = 300;
        t.OnHold_Properties__c = 200;
        t.No_of_Units__c = 800;
        t.Description__c = 'towerDiscription';
        insert t;
        dataMap.put('TOWER',t.id);
        
        //Team Details
        Team__c team = new Team__c();
        team.Name = 'Quotation Approvers Team';
        team.Project__c = p.Id;
        team.Tower__c = t.Id;
        team.Team_Type__c = 'Quotation Approvers Team';
        team.OwnerId = UserInfo.getUserId();
        insert team;
        dataMap.put('TEAM',team.id);
        
        //Team Members Details
        Team_Members__c tmem = new Team_Members__c();
        tmem.Team__c = team.Id;
        tmem.Approver_Type__c = 'First Level';
        tmem.Counter__c = 1;
        tmem.User__c = UserInfo.getUserId();
        tmem.User_Active__c = true;
        insert tmem;
        dataMap.put('TEAM_MEMBER',tmem.id);
        
        //Billing Plan Details
        Payment_Plan__c bp = new Payment_Plan__c();
        bp.Billing_Plan_Name__c = 'ELYSIAN Tower A CLP';
        bp.Payment_Plan_Number__c = '0000025976';
        bp.Payment_Plan_Type__c = 'Non Scheme';
        bp.RecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
        bp.Status__c = 'Submitted';
        bp.Is_Editable__c = true;
        bp.Subvention_Base_Rate__c = 12000.00;
        bp.Is_Subvention_Plan__c = false;
        bp.Approval_Required__c = false;
        //bp.Scheme_Specific_Clauses__c = 'Scheme_Specific';
        bp.Active__c = true;
        bp.Site__c = site.Id;
        bp.Project__c = p.Id;
        bp.Tower__c = t.Id;
        bp.Active__c=true;
        insert bp;
        dataMap.put('BILLING_PLAN',bp.id);
                
        //Payment Term
        Payment_Term__c PTerm = new Payment_Term__c();
        PTerm.Name = 'AG01';
        PTerm.Detailed_Description__c = 'To be paid on or before «Date»';
        PTerm.Due_Days__c = 30;
        PTerm.Order__c = 2;
        PTerm.Min_Occurrence__c = 1;
        PTerm.Max_Occurrence__c = 5;
        PTerm.Type__c = 'Time Linked';
        PTerm.Tower__c = t.Id;
        PTerm.Milestone_Indicator__c = 0;
        PTerm.Billing_Plan__c = bp.Id;
        insert PTerm;
        
        Payment_Term__c PTerm2 = new Payment_Term__c();
        PTerm2.Name = 'BD01';
        PTerm2.Detailed_Description__c = 'At the time of Booking i.e. on Executing the Acceptance Form (being part of the Earnest Money)';
        PTerm2.Due_Days__c = 0;
        PTerm2.Order__c = 1;
        PTerm2.Min_Occurrence__c = 1;
        PTerm2.Max_Occurrence__c = 2;
        PTerm2.Type__c = 'Time Linked';
        PTerm2.Tower__c = t.Id;
        PTerm2.Milestone_Indicator__c = 0;
        PTerm2.Billing_Plan__c = bp.Id;
        insert PTerm2;
        
        Payment_Term__c PTerm3 = new Payment_Term__c();
        PTerm3.Name = 'IN00';
        PTerm3.Detailed_Description__c = 'To be paid on or before «Date»';
        PTerm3.Due_Days__c = 120;
        PTerm3.Order__c = 3;
        PTerm3.Min_Occurrence__c = 1;
        PTerm3.Max_Occurrence__c = 10;
        PTerm3.Type__c = 'Time Linked';
        PTerm3.Tower__c = t.Id;
        PTerm3.Milestone_Indicator__c = 0;
        PTerm3.Billing_Plan__c = bp.Id;
        insert PTerm3;
        
        Payment_Term__c PTerm4 = new Payment_Term__c();
        PTerm4.Name = 'IN01';
        PTerm4.Detailed_Description__c = 'To be paid on or before «Date»';
        PTerm4.Due_Days__c = 0;
        PTerm4.Order__c = 4;
        PTerm4.Min_Occurrence__c = 1;
        PTerm4.Max_Occurrence__c = 1;
        PTerm4.Type__c = 'Construction Linked';
        PTerm4.Tower__c = t.Id;
        PTerm4.Milestone_Indicator__c = 1;
        PTerm4.Billing_Plan__c = bp.Id;
        insert PTerm4;
        
        Payment_Term__c PTerm5 = new Payment_Term__c();
        PTerm5.Name = 'ST01';
        PTerm5.Detailed_Description__c = 'Completion of the staircases, lift wells, lobbies up to the floor level of the said Premises.';
        PTerm5.Due_Days__c = 0;
        PTerm5.Order__c = 5;
        PTerm5.Min_Occurrence__c = 1;
        PTerm5.Max_Occurrence__c = 1;
        PTerm5.Type__c = 'Construction Linked';
        PTerm5.Tower__c = t.Id;
        PTerm5.Milestone_Indicator__c = 1;
        PTerm5.Billing_Plan__c = bp.Id;
        insert PTerm5;
        
        Payment_Term__c PTerm6 = new Payment_Term__c();
        PTerm6.Name = 'PS01';
        PTerm6.Detailed_Description__c = 'At the time of handing over of the possession of the said Premises to the Allottee/s on/after receipt of the Occupation Certificate with respect to the said Premises and after completion/installation of the door to the said Premises and installation of sanitary fittings in the said Premises';
        PTerm6.Due_Days__c = 0;
        PTerm6.Order__c = 6;
        PTerm6.Min_Occurrence__c = 1;
        PTerm6.Max_Occurrence__c = 1;
        PTerm6.Type__c = 'Construction Linked';
        PTerm6.Tower__c = t.Id;
        PTerm6.Milestone_Indicator__c = 1;
        PTerm6.Billing_Plan__c = bp.Id;
        insert PTerm6;
      
        
        //Payment Plan Line Item Details
        Payment_Plan_Line_Item__c ppli = new Payment_Plan_Line_Item__c();
        ppli.Payment_Plan__c = bp.Id;
        ppli.Order__c = 78;
        ppli.Date_Category__c = 'YA';
        ppli.Description__c = 'Agreement Execution';
        ppli.Billing_Block_For_Payment_Plan__c = '02';
        ppli.Milestone_Number__c = '000000000000';
        //ppli.ID_For_Adopting_Billing__c = '1';
        //ppli.Item_of_Payment_Plan__c = 'Item';
        ppli.Payment_Date__c = system.today().addDays(30);
        //ppli.Usage__c = 'EL01';
        ppli.Date_Description__c = 'AG01';
        ppli.Percentage_Of_Value_To_Be_Invoiced__c = '10.00';
        ppli.Value_to_be_Billed__c = 0.0;
        ppli.Rule_In_Payment_Plan__c = '1';
        ppli.Terms_of_Payment_Key__c = 'AG01';
        insert ppli;
        dataMap.put('AG01',ppli.id);
        
        Payment_Plan_Line_Item__c ppli2 = new Payment_Plan_Line_Item__c();
        ppli2.Payment_Plan__c = bp.Id;
        ppli2.Order__c = 77;
        ppli2.Percentage__c = 10;
        ppli2.Date_Category__c = 'YA';
        ppli2.Description__c = 'Booking Day';
        ppli2.Billing_Block_For_Payment_Plan__c = '02';
        ppli2.Milestone_Number__c = '000000000000';
        //ppli.ID_For_Adopting_Billing__c = '1';
        //ppli.Item_of_Payment_Plan__c = 'Item';
        ppli2.Payment_Date__c = system.today();
        //ppli.Usage__c = 'EL01';
        ppli2.Date_Description__c = 'BD01';
        ppli2.Percentage_Of_Value_To_Be_Invoiced__c = '10.00';
        ppli2.Value_to_be_Billed__c = 0.0;
        ppli2.Rule_In_Payment_Plan__c = '1';
        ppli2.Terms_of_Payment_Key__c = 'BD01';
        insert ppli2;
        
        Payment_Plan_Line_Item__c ppli3 = new Payment_Plan_Line_Item__c();
        ppli3.Payment_Plan__c = bp.Id;
        ppli3.Order__c = 2;
        ppli3.Percentage__c = 0;
        ppli3.Date_Category__c = 'YA';
        ppli3.Description__c = '1st Slab';
        ppli3.Billing_Block_For_Payment_Plan__c = '02';
        ppli3.Milestone_Number__c = '000000000000';
        ppli.ID_For_Adopting_Billing__c = '1';
        //ppli.Item_of_Payment_Plan__c = 'Item';
        ppli3.Payment_Date__c = system.today();
        //ppli.Usage__c = 'EL01';
        ppli3.Date_Description__c = 'SL01';
        ppli3.Percentage_Of_Value_To_Be_Invoiced__c = '10.00';
        ppli3.Value_to_be_Billed__c = 0.0;
        ppli3.Rule_In_Payment_Plan__c = '1';
        ppli3.Terms_of_Payment_Key__c = 'IN01';
        insert ppli3;
        
        Payment_Plan_Line_Item__c ppli4 = new Payment_Plan_Line_Item__c();
        ppli4.Payment_Plan__c = bp.Id;
        ppli4.Order__c = 7;
        ppli4.Date_Category__c = 'YA';
        ppli4.Description__c = '6th Slab';
        ppli4.Billing_Block_For_Payment_Plan__c = '02';
        ppli4.Milestone_Number__c = '000000012651';
        //ppli.ID_For_Adopting_Billing__c = '1';
        //ppli.Item_of_Payment_Plan__c = 'Item';
        ppli4.Payment_Date__c = system.today().addDays(30);
        ppli4.Usage__c = 'SL06';
        //ppli4.Date_Description__c = 'AG01';
        ppli4.Percentage_Of_Value_To_Be_Invoiced__c = '20.00';
        ppli4.Value_to_be_Billed__c = 0.0;
        ppli4.Rule_In_Payment_Plan__c = '1';
        ppli4.Terms_of_Payment_Key__c = 'IN02';
        insert ppli4;
        
        Payment_Plan_Line_Item__c ppli5 = new Payment_Plan_Line_Item__c();
        ppli5.Payment_Plan__c = bp.Id;
        ppli5.Order__c = 8;
        ppli5.Date_Category__c = 'YA';
        ppli5.Description__c = '7th Slab';
        ppli5.Billing_Block_For_Payment_Plan__c = '02';
        ppli5.Milestone_Number__c = '000000012652';
        //ppli.ID_For_Adopting_Billing__c = '1';
        //ppli.Item_of_Payment_Plan__c = 'Item';
        ppli5.Payment_Date__c = system.today().addDays(30);
        ppli5.Usage__c = 'SL07';
        //ppli5.Date_Description__c = 'AG01';
        ppli5.Percentage_Of_Value_To_Be_Invoiced__c = '20.00';
        ppli5.Value_to_be_Billed__c = 0.0;
        ppli5.Rule_In_Payment_Plan__c = '1';
        ppli5.Terms_of_Payment_Key__c = 'IN03';
        insert ppli5;
        
        Payment_Plan_Line_Item__c ppli6 = new Payment_Plan_Line_Item__c();
        ppli6.Payment_Plan__c = bp.Id;
        ppli6.Order__c = 73;
        ppli6.Percentage__c = 20;
        ppli6.Date_Category__c = 'YA';
        ppli6.Description__c = 'Staircase & Lobbies';
        ppli6.Billing_Block_For_Payment_Plan__c = '02';
        ppli6.Milestone_Number__c = '000000012717';
        //ppli.ID_For_Adopting_Billing__c = '1';
        //ppli.Item_of_Payment_Plan__c = 'Item';
        ppli6.Payment_Date__c = system.today().addDays(30);
        ppli6.Usage__c = 'ST01';
        //ppli6.Date_Description__c = 'AG01';
        ppli6.Percentage_Of_Value_To_Be_Invoiced__c = '20.00';
        ppli6.Value_to_be_Billed__c = 0.0;
        ppli6.Rule_In_Payment_Plan__c = '1';
        ppli6.Terms_of_Payment_Key__c = 'ST01';
        insert ppli6;
        
        Payment_Plan_Line_Item__c ppli7 = new Payment_Plan_Line_Item__c();
        ppli7.Payment_Plan__c = bp.Id;
        ppli7.Order__c = 76;
        ppli7.Percentage__c = 10;
        ppli7.Date_Category__c = 'YA';
        ppli7.Description__c = 'Possession';
        ppli7.Billing_Block_For_Payment_Plan__c = '02';
        ppli7.Milestone_Number__c = '000000012720';
        //ppli.ID_For_Adopting_Billing__c = '1';
        //ppli.Item_of_Payment_Plan__c = 'Item';
        ppli7.Payment_Date__c = system.today().addDays(30);
        ppli7.Usage__c = 'PS01';
        //ppli6.Date_Description__c = 'AG01';
        ppli7.Percentage_Of_Value_To_Be_Invoiced__c = '10.00';
        ppli7.Value_to_be_Billed__c = 0.0;
        ppli7.Rule_In_Payment_Plan__c = '1';
        ppli7.Terms_of_Payment_Key__c = 'PS01';
        insert ppli7;
        
        //Property type details
        Property_Type__c ptype = new Property_Type__c();
        ptype.Name__c = 'OEY _ 3 BHK Majestic A';
        ptype.Property_Type_Code__c = 'OEY _ 3 BHK Majestic A';
        ptype.Description__c = 'OEY _ 3 BHK Majestic A';
        ptype.Project1__c = p.Id;
        ptype.Type__c = 'Apartment';
        ptype.Category__c = 'Residential';
        ptype.Active__c = true;
        ptype.Material_No__c = 'FL-OEY-MAJ-TYPE-A';
        ptype.Control_Code__c = '9625';
        insert ptype;
        dataMap.put('PROPERTY_TYPE',ptype.id);
        
        //Additional Charges Details
        Other_Charges__c addcharges = new Other_Charges__c();
        addcharges.Name = 'Club House Charges';
        addcharges.Description__c = 'Club House Charges';
        addcharges.Order__c = 1;
        addcharges.Schedule_Description__c = 'One-time non-refundable membership fee';
        addcharges.Available_At__c = 'Third Schedule';
       // addcharges.At_Actual__c = 'At Actual';
        addcharges.Active__c = true;
        addcharges.Discount_Amount__c = 400000.00;
        addcharges.Property_Type__c = ptype.Id;
        insert addcharges;
        
        Other_Charges__c addcharges2 = new Other_Charges__c();
        addcharges2.Name = 'Legal Charges';
        addcharges2.Description__c = 'Legal Charges';
        addcharges2.Order__c = 2;
        addcharges2.Schedule_Description__c = 'Legal Charges';
        addcharges2.Available_At__c = 'Fourth Schedule';
        addcharges2.At_Actual__c = 'At Actual';
        addcharges2.Active__c = true;
        addcharges2.Discount_Amount__c = 200000.00;
        addcharges2.Property_Type__c = ptype.Id;
        insert addcharges2;
        
        Other_Charges__c addcharges3 = new Other_Charges__c();
        addcharges3.Name = 'Plumbing till plumbing shafts outside the toilets of the said Premises.';
       // addcharges.Description__c = 'Club House Charges';
        addcharges3.Order__c = 3;
        addcharges3.Schedule_Description__c = 'Plumbing till plumbing shafts outside the toilets of the said Premises.';
        addcharges3.Available_At__c = 'For BareShell';
        //addcharges.At_Actual__c = 'At Actual';
        addcharges3.Active__c = true;
        addcharges3.Discount_Amount__c = 400000.00;
        addcharges3.Property_Type__c = ptype.Id;
        insert addcharges3;
        
        //Property Details
        Property__c prop = new Property__c();
        prop.Project_Name__c = p.Id;
        prop.Property_Type__c = ptype.Id;
        prop.Tower__c = t.Id;
        prop.SPECIAL_CONDITIONS__c = 'ITC BENEFIT; UPFRONT PAYMENT; BARE SHELL PREMISES; Bare shell with material handed over and no reduction in Sale Price; Bare shell with Reduction in Sale Price; Bare shell no change in Sale Price and no material handed over; Limited bare shell no change in Sale Price and no material handed over; Exquisite – Duplex/Penthouse - Bare shell no change in Sale Price and no material handed over; SCHEME RELATED; Bank Subvention Scheme; Flexi Payment Scheme; Construction Linked Payment Scheme; STUDIO APARTMENT; Other Special Conditions';
        prop.Related_Jodi_Property__c = prop.Id;
        prop.Is_Jodi_Flat__c = false;
        prop.Market_Value__c = 250000;
        prop.Floor_No__c = 6.00;
        prop.Sales_Organization__c = '1131';
        prop.Status__c = 'Availalbe';
        prop.ITC_Benefit_Applicable__c = true;
        //prop.RecordTypeId = 'Residential';
        prop.House_Unit_No__c = '0601';
        prop.Carpet_Area_UOM__c = 'Square Feet (Carpet Area)';
        prop.Property_Name__c = 'PR# 04-2021-01822';
        prop.Saleable_Area__c = 800;
        prop.Material_No__c = 'OEY-A-0601';
        prop.Control_Code__c = 'Controlcode';
        prop.BW__c = false;                     //Unit Linked Milestones
        prop.ST__c = true;
        prop.PT__c = false;
        prop.EL__c = true;
        prop.Duplex_Penthouse_Upper_Level_Floor__c = '59';        //Acceptance Form Fields
        prop.Duplex_Penthouse_Lower_Level_Floor__c = '48';
        prop.Duplex_Penthouse_Lower_Area_Sq_Ft__c = 100;
        prop.Duplex_Penthouse_Lower_Area_Sq_Mtr__c = 800;
        prop.Duplex_Penthouse_Upper_Area_Sq_Ft__c = 100;
        prop.Duplex_Penthouse_Upper_Area_Sq_Mtr__c = 800;
        prop.Carpet_Area_Sq_Mtr__c = 100;
        prop.Carpet_Area__c = 2538.00;
        prop.Carpet_Area_of_the_Unit__c = 2538.00;
        prop.Carpet_Area_of_Limited_Areas_Facilities__c = 1000;
        prop.Bank_Account_of_the_Promoter__c = 'BankAccount';
        prop.OC_Received_Date__c = System.today().adddays(365);
        prop.Limited_Areas_and_Facilities__c = 'Limited_Areas_and_Facilities';
        prop.of_Effective_Sale_Price__c = 234189;                                   //Percentage
        prop.of_ITC_Benefit__c = 1000;
        prop.Admin_Base_Sale_Price__c = 100;                                        //Pricing Details
        prop.Admin_Floor_Rise_Charges__c = 1000;
        prop.Admin_PLC_Charges__c = 10000;
        prop.Category__c = 'Villas';                                                //Information
        prop.Comments_by_sales__c = 'Comments';
        prop.Completion_Certificate_Date__c = System.today().adddays(365);
        prop.Active__c = true;
        prop.Property_Status__c = 'Completed';
        prop.isUpdatedfromUI__c = true;
        prop.Property_on_hold_for_Reallocation__c = false;
        prop.Property_Alloted_Through_Offer__c = false;
        prop.Blocked_by_Management__c = false;
        prop.Refuge__c = false;
        prop.Mortgage__c = false;
        prop.Temporary_Block__c = false;
        prop.Blocked_By__c = UserInfo.getUserId();
        prop.Super_Area__c = 500;                           //Area Information
        prop.Built_Up_Area__c = 500;
        prop.Built_Up_Area_In_Sq_Mtr1__c = 500;
        prop.Balcony_Area__c = 500;
        prop.Area_Unit__c = 'Sq. Ft.';
        prop.DCR_Carpet_Area_in_Sq_Mtr__c = 800;            //RERA Section
        prop.DCR_Carpet_Area_in_Sq_Ft__c = 500;
        prop.RERA_Carpet_Area_In_Sq_Mtr__c = 800;
        prop.RERA_Carpet_Area_In_Sq_ft__c = 500;
        prop.Balcony_Terrace_Area_in_Sq_Mtr__c = 1000;
        prop.Balcony_Terrace_Area_in_Sq_ft__c = 500;
        prop.Property_Address__c = 'Property Address';      //Description
        prop.Description__c = 'ELYSIAN-SIGNATURE-4BHK';
        prop.CRM_Lead__c = UserInfo.getUserId();                //User Details
        prop.Original_RM_Name__c = UserInfo.getUserId();
        prop.Finance_Subvention_interest_user__c = UserInfo.getUserId();
        prop.AR_Subvention_interest_user__c = UserInfo.getUserId(); 
        prop.RM_Name__c = 'RM Name';
        prop.RM_Email__c = 'RMEmail@gmail.com';
        prop.RM_Phone__c = '8765432456';
        prop.Site_Support_Name__c = 'Site Support';
        prop.Support_Head__c = UserInfo.getUserId();
        prop.Sales_Head__c = UserInfo.getUserId();
        prop.AR_Support__c = UserInfo.getUserId();
        prop.CFO__c = UserInfo.getUserId();
        prop.MD__c = UserInfo.getUserId();
        prop.AR_Finance__c = UserInfo.getUserId();
        prop.Central_Support__c = UserInfo.getUserId();
        prop.Site_Support__c = UserInfo.getUserId();
        prop.Car_Park_Type_1__c = 'SINGLE';              //Car Park Charge Details
        prop.Car_Park_Type_2__c = 'TANDEM';
        prop.Car_Park_Count_1__c = 1;
        prop.Car_Park_Count_2__c = 1;
        insert prop;
        dataMap.put('PROPERTY',prop.id);
        
        //SAP Pricing
        SAP_Pricing__c sap = new SAP_Pricing__c();
        sap.Sequence_Number__c = 1;
        sap.Property__c = prop.Id;
        sap.Charge_Based_On__c = 'Rate';
       // sap.Charge_on_Area_Type__c = 'Carpet Area';
        //sap.CGST__c = 10;
        //sap.SGST__c = 10;
        sap.Condition_Description__c = 'Base Rate';
        sap.Condition_Type__c = 'ZPR0';
        sap.Rate__c = 24250.00;
        sap.Value__c = 61546500.00;
        insert sap;
        
        SAP_Pricing__c sap2 = new SAP_Pricing__c();
        sap2.Sequence_Number__c = 2;
        sap2.Property__c = prop.Id;
        sap2.Charge_Based_On__c = 'Rate';
       // sap2.Charge_on_Area_Type__c = 'Carpet Area';
        //sap2.CGST__c = 10;
        //sap2.SGST__c = 10;
        sap2.Condition_Description__c = 'Floor rise';
        sap2.Condition_Type__c = 'VA00';
        sap2.Rate__c = 12000;
        sap2.Value__c = 30456000;
        insert sap2;
        
        SAP_Pricing__c sap3 = new SAP_Pricing__c();
        sap3.Sequence_Number__c = 3;
        sap3.Property__c = prop.Id;
        sap3.Charge_Based_On__c = 'Lumpsum';
        //sap3.Charge_on_Area_Type__c = 'Carpet Area';
        //sap3.CGST__c = 10;
        //sap3.SGST__c = 10;
        sap3.Condition_Description__c = 'Net Value';
        sap3.Condition_Type__c = 'ZNET';
        sap3.Rate__c = 92002500;
        sap3.Value__c = 92002500;
        insert sap3;
        
        SAP_Pricing__c sap4 = new SAP_Pricing__c();
        sap4.Sequence_Number__c = 4;
        sap4.Property__c = prop.Id;
        sap4.Charge_Based_On__c = 'Percentage';
        //sap4.Charge_on_Area_Type__c = 'Carpet Area';
        //sap4.CGST__c = 10;
        //sap4.SGST__c = 10;
        sap4.Condition_Description__c = 'ABT for GST';
        sap4.Condition_Type__c = 'ZAB1';
        sap4.Rate__c = -33;
        sap4.Value__c = -30667193.33;
        insert sap4;
        
        SAP_Pricing__c sap5 = new SAP_Pricing__c();
        sap5.Sequence_Number__c = 5;
        sap5.Property__c = prop.Id;
        sap5.Charge_Based_On__c = 'Lumpsum';
        //sap5.Charge_on_Area_Type__c = 'Carpet Area';
       // sap5.CGST__c = 10;
        //sap5.SGST__c = 10;
        sap5.Condition_Description__c = 'Base value for GST';
        sap5.Condition_Type__c = 'ZTBS';
        sap5.Rate__c = 61335306.68;
        sap5.Value__c = 61335306.68;
        insert sap5;
        
        SAP_Pricing__c sap6 = new SAP_Pricing__c();
        sap6.Sequence_Number__c = 6;
        sap6.Property__c = prop.Id;
        sap6.Charge_Based_On__c = 'Percentage';
        //sap6.Charge_on_Area_Type__c = 'Carpet Area';
        //sap6.CGST__c = 10;
        //sap6.SGST__c = 10;
        sap6.Condition_Description__c = 'CGST';
        sap6.Condition_Type__c = 'JOCG';
        sap6.Rate__c = 3.75;
        sap6.Value__c = 2300074.00;
        insert sap6;
        
        SAP_Pricing__c sap7 = new SAP_Pricing__c();
        sap7.Sequence_Number__c = 7;
        sap7.Property__c = prop.Id;
        sap7.Charge_Based_On__c = 'Percentage';
        //sap6.Charge_on_Area_Type__c = 'Carpet Area';
        //sap6.CGST__c = 10;
        //sap6.SGST__c = 10;
        sap7.Condition_Description__c = 'SGST';
        sap7.Condition_Type__c = 'JOSG';
        sap7.Rate__c = 3.75;
        sap7.Value__c = 2300074.00;
        insert sap7;
        
        SAP_Pricing__c sap8 = new SAP_Pricing__c();
        sap8.Sequence_Number__c = 8;
        sap8.Property__c = prop.Id;
        sap8.Charge_Based_On__c = 'Lumpsum';
        //sap6.Charge_on_Area_Type__c = 'Carpet Area';
        //sap6.CGST__c = 10;
        //sap6.SGST__c = 10;
        sap8.Condition_Description__c = 'Tax Value';
        sap8.Condition_Type__c = 'ZTAX';
        sap8.Rate__c = 4600148.00;
        sap8.Value__c = 4600148.00;
        insert sap8;
        
        SAP_Pricing__c sap9 = new SAP_Pricing__c();
        sap9.Sequence_Number__c = 9;
        sap9.Property__c = prop.Id;
        sap9.Charge_Based_On__c = 'Lumpsum';
        //sap6.Charge_on_Area_Type__c = 'Carpet Area';
        //sap6.CGST__c = 10;
        //sap6.SGST__c = 10;
        sap9.Condition_Description__c = 'Sale Value';
        sap9.Condition_Type__c = 'ZSLV';
        sap9.Rate__c = 96602648.00;
        sap9.Value__c = 96602648.00;
        insert sap9;
        
        return dataMap;
    }
}