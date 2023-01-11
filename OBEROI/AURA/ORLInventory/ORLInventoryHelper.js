({
	getProfile : function(component, event, helper) {
        //var action = component.get("c.scriptsLoaded");
        angular.module("app", [])
        a.factory("$util", function(){
            return {
                parse_int: function(arr, field){
                    angular.forEach(arr, function(each){
                        if(each[field])
                            each[field] = parseInt(each[field]);
                    })
                }
            }
        })
        .factory("$soql", function(){
            sforce.connection.sessionId = '{!$Api.Session_ID}';
            function handler(process){   
                return {
                    onSuccess: function(result){
                        var is_describe = process.indexOf('describe') === 0;
                        console.log("soql." + process, result.getArray && !is_describe ? result.getArray("records") : result);

                        angular.element(document.body).ready(function(){
                            angular.element(document.getElementById("projects")).scope()
                            .$apply(function(scope){
                                scope.$parent.$root.$broadcast("soql." + process, result.getArray && !is_describe ? result.getArray("records") : result);
                            });
                        })
                    },
                    onFailure: function(err){
                        console.log("ERROR", err);
                        alert("An error occured.\nPlease refresh page and try again.");
                    }
                };
            }

            return {
                projects: function(){
                    sforce.connection.query(
                        " select Id, Name, Image_Path__c, Description__c, Status__c, First_Booking_Date__c, Sub_Category__c, Location__c, Type_Of_Project__c, Country1__c,Country__c, PropStrength__Pie_Chart_URL__c "
                        +" from Project__c "
                        , handler("projects")
                    );
                },
                towers: function(proj){
                    sforce.connection.query(
                        " select Id, Tower_ID__c, Image_Path__c, Name, Total_Floors__c, Description__c, <!--PropStrength__Available_Car_Parking__c, PropStrength__Total_Alloted_Parking__c, PropStrength__Total_Parking__c, PropStrength__Pie_Chart_Tower_URL__c -->, Number_of_Units__c "
                        +" from Tower__c "
                        +" where Project_Name__c = '"+proj.Id+"' "
                        +" and Active__c = true "
                        , handler("towers")
                    );
                },
                floors: function(tower){
                    sforce.connection.query(
                        " select Id, Name, Description__c, <!--Tower__r.PropStrength__Pie_Chart_Tower_URL__c-->, Floor_Number__c"
                        +" from Floor__c "
                        +" where Tower__c = '"+tower.Id+"' "
                        +" and Active__c = true "
                        , handler("floors")
                    );
                },
                properties: function(tower){
                    sforce.connection.query(
                        " select Id, Name, Description__c, Refuge__c, Blocked_by_Management__c, Mortgage__c, Temporary_Block__c, Active__c, Property_Allotted_Through_Offer__c, House_Unit_No__c, RecordType.Name, Total_Sales_Price__c,Tower__r.Name,TSC__c,"
                        +" PropStrength__Rate_per_unit_area__c, Allotted__c, Category__c, Discount__c, Super_Area__c, Area_Unit__c, Property_Status__c, Floor_Number__c, Unit_Type__c, Property_On_Hold__c "
                        +" from Property__c "
                        +" where Floor__r.Tower__c = '"+tower.Id+"' "
                        +" order by House_Unit_No__c asc"
                        , handler("properties")
                    );
                },
                describe: function(obj){
                    return sforce.connection.describeSObject(obj, handler("describe." + obj));
                }
            }
        })
        .controller("selected", function($scope, $rootScope, $soql){
            $scope.$root = $rootScope;
        })
        .controller("project", function($scope, $rootScope, $soql){
            $scope.q = {desc:false};
            $scope.$root = $rootScope;
            $soql.projects();

            $scope.$on("soql.projects", function(broadcast, args){

                angular.forEach(args, function(e){
                    e.$image = e.Image_Path__c || "http://media2.wptv.com//photo/2012/08/24/empire_state_building_20120824093747_320_240.JPG";
                });

                $scope.model = args;
            });

            $scope.$on("soql.describe.Project__c", function(broadcast, args){
                angular.forEach(args.fields, function(field){
                    if(field.name == "Location__c"){
                        $scope.locations = field.picklistValues;
                    }
                    else if(field.name == "Type_Of_Project__c"){
                        $scope.types = field.picklistValues;
                    }
                    else if (field.name == "Status__c"){
                        $scope.statuses = field.picklistValues;
                    }
                    else if(field.name == "Country__c"){
                        $scope.countries = field.picklistValues;   
                    }
                });
            })

            $scope.open = function(proj){
                $scope.$root.proj = proj;
                $soql.towers(proj);
            }

            $scope.close = function(){
                $scope.$root.proj = null;
                $scope.$root.tower = null;
                $scope.$root.floor = null;
            }

            $soql.describe("Project__c");
        })
       .controller("tower", function($scope, $rootScope, $soql, $util){
            $scope.$root = $rootScope;
            $scope.q = {};

            $scope.$on("soql.towers", function(broadcast, args){
                $util.parse_int(args, 'Total_Floors__c');
                $util.parse_int(args, 'Number_of_Units__c');
                $util.parse_int(args, 'PropStrength__Total_Parking__c');

                angular.forEach(args, function(e){
                    e.$image = e.Image_Path__c || "http://e-architect.co.uk/images/jpgs/dubai/al_salam_tecom_tower_a191108_3.jpg";
                })

                $scope.model = args;
            });

            $scope.open = function(tower){
                $scope.$root.tower = tower;
                $soql.properties(tower);
            }

            $scope.close = function(){
                $scope.$root.tower = null;
                $scope.$root.floor = null;
            }
        })
        .controller("floor", function($scope, $rootScope, $soql, $util){
            $scope.$root = $rootScope;
            $scope.q = {desc: true};
            $scope.$status = [
              {label: "Mortgage", theme: "primary", key: "mortgage"}
             ,{label: "Not Available For Sale", theme: "default", key: "nosale"}
             ,{label: "Refuge", theme: "refuge", key: "refuge"}
             ,{label: "Temporary Block", theme: "info", key: "temporary"}
             ,{label: "Blocked By Management", theme: "danger", key: "blocked"}
             ,{label: "Hold", theme: "warning", key: "hold"}
             ,{label: "Booked", theme: "booked", key: "booked"}
             ,{label: "Available", theme: "available", key: "available"}
            ];
            $scope.$prev = {};
            $scope.$on("soql.floors", function(broadcast, args){
                $util.parse_int(args, 'Floor_Number__c');
                $scope.model = args;
            });

            $scope.$on("soql.properties", function(broadcast, args){
                var size = {
                    "2 BR": 2,
                    "3 BR": 3,
                    "4 BR": 4,
                    "Villa": 6
                }
                angular.forEach(args, function(p){
                    p.$size = 1;//size[p.Unit_Type__c] || 2;
                     if(p.Active__c =='true' && (p.Allotted__c == 'true' || p.Property_Allotted_Through_Offer__c == 'true')){
                        p.$theme = 'booked';
                        p.$msg = "Booked";
                       
                        p.$status = "booked";
                    }
                    else if(p.Active__c =='true' && p.Property_On_Hold__c == 'true' ){
                        p.$theme = 'warning';
                        p.$msg = "Hold";
                        p.$status = "hold";
                        
                    }
                    else if(p.Active__c == 'true' && p.Refuge__c =='true'){
                        p.$theme = 'refuge';
                        p.$msg = "Refuge";
                        p.$status = "refuge";
                       
                    }
                    else if( p.Active__c == 'true' && p.Temporary_Block__c =='true'){
                        p.$theme = 'info';
                        p.$msg = "Temporary Block";
                        p.$status = "temporary";
                        
                    }
                     else if(p.Active__c == 'true' &&  p.Mortgage__c =='true'){
                        p.$theme = 'primary';
                        p.$msg = "Mortgage";
                        p.$status = "mortgage";
                       
                    }
                    else if( p.Active__c == 'true' && p.Blocked_by_Management__c  =='true'){
                        p.$theme = 'danger';
                        p.$msg = "Blocked By Management";
                        p.$status = "blocked";
                       
                    }
                    else if(p.Active__c == 'false'){
                        p.$theme = 'default';
                        p.$msg = "Not Available For Sale";
                        p.$status = "nosale";
                       
                    }
                    else if(p.Active__c == 'true' && p.Temporary_Block__c =='false' && p.Refuge__c =='false' && p.Property_On_Hold__c == 'false' && p.Mortgage__c =='false' && p.Blocked_by_Management__c =='false' && p.Property_Allotted_Through_Offer__c == 'false' && p.Allotted__c == 'false' ){
                        p.$theme = 'available';
                        p.$msg = "Available";
                        p.$status = "available";
                    }
              
                });

                $util.parse_int(args, 'Floor_Number__c');

                var prop_by_floor = _.groupBy(args, 'Floor_Number__c');

                $scope.floors = [];
                angular.forEach(prop_by_floor, function(v, k){
                    var f = '000' + k;

                    $scope.floors.push({
                        text: f.substr(f.length - 3), 
                        no:k, 
                        prop: v, 
                        type: _.reduce(v, function(prev, nex){
                            if(prev == null || prev == '')
                                return nex.Unit_Type__c || '';
                            else if(nex.Unit_Type__c == null || prev.indexOf(nex.Unit_Type__c) > -1)
                                return prev;
                            else
                                return prev + "|" + nex.Unit_Type__c;
                        }, '') 
                        ,  status: _.reduce(v, function(prev, nex){
                            if(prev == null || prev == '')
                                return nex.$status || '';
                            else if(nex.$status == null || prev.indexOf(nex.$status) > -1)
                                return prev;
                            else
                                return prev + "|" + nex.$status;
                        }, '') 
                    });
                });

                console.log($scope.floors);

                $scope.properties = args;
            });

            $scope.$on("soql.describe.Property__c", function(broadcast, args){
                angular.forEach(args.fields, function(field){
                    if(field.name == "Unit_Type__c"){
                        $scope.types = field.picklistValues;
                    }
                });
            });

            $scope.open = function(floor){
                $scope.$root.floor = floor;
                $soql.properties(floor);
            }

            $scope.close = function(){
                $scope.$root.floor = null;
                $scope.$root.prop = null;
            }

            $scope.redirect = function(prop){
                if(sforce && sforce.one && sforce.one.navigateToSObject) {
                    // Salesforce1 navigation
                    sforce.one.navigateToSObject(prop.Id);
                }
                else {
                    // Set the window's' URL using a Visualforce expression
                    window.location.href = "../../../"+prop.Id;
                }
            }
            
            $soql.describe("Property__c");
        });
	}
})