import { LightningElement, track } from 'lwc';

export default class EmployeeDatatable extends LightningElement {

    tableVisible = false;
    thirdVisible = true;
    fourthVisible = true;
    firstVisible = true;
    fithVisible = true;
    sixthVisible = false;
    seventhVisible = false;
    eightVisible = false;
    ninthVisible = false;
    tenthnewVisible = false;
    buttonVisible = false;
    disableNext = false;
    mistakeVisible = true;
    amountVisible = true;


    arr = [];



    /*buttonHandler(){
        
        if( productname ='Flipkart'){
            this.tableVisible = false;
        } else{this.tableVisible = true; }
    }*/


    @track employeeColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];

    //  clickhandler(event) { 

    //        console.log('handlecli')
    //     var selectedRecords =
    //         this.template.querySelector("lightning-datatable");
    //     const arr = selectedRecords.getSelectedRows()

    /* var len = arr.length;
     console.log('length' +len);
     if(len>1){
       this.firstVisible= false;
     }*/




    //  const myJSON = JSON.stringify(arr, ["productname"]);
    //{"producname":"Amazon"}
    //console.log(myJSON)


    //  var obj = JSON.parse(myJSON)
    //var flip = console.log(obj[0].productname)




    //  }   










    handleClick() {
        this.tableVisible = true;
        this.buttonVisible = true;

    }


    /* buttonHandler() {

        var selectedRecords =
            this.template.querySelector("lightning-datatable");
        console.log('selectedrecords' + selectedRecords);


        const arr = selectedRecords.getSelectedRows()
        console.log('fdgdfg' + JSON.stringify(arr));
        console.log('arr array' + arr)

        var len = arr.length;
        console.log('length' + len);




        const myJSON = JSON.stringify(arr, ["productname"]);
        //{"producname":"Amazon"}


        console.log('myjson' + myJSON);
        var obj = JSON.parse(myJSON)
        var flip = console.log(obj[0].productname)
        console.log('button');
        console.log('new button');


        if (this.arr.length > 1) {
            this.disableNext = true;


        }
    }*/





    buttonHandler() {







        var selectedRecords =
            this.template.querySelector("lightning-datatable");
        console.log('selecte' + selectedRecords);


        const arr = selectedRecords.getSelectedRows()
        console.log('fdgdfg' + JSON.stringify(arr));
        console.log('arr array' + arr)

        var len = arr.length;
        console.log('length' + len);
        /*if(len<4){
          this.disableNext = true;
        } else{
          window.alert('error');
         }*/



        const myJSON = JSON.stringify(arr, ["productname"]);
        //{"producname":"Amazon"}


        console.log('myjson' + myJSON);
        var obj = JSON.parse(myJSON)
        var flip = obj[0].productname
        this.arr.push(this.flip);
        console.log('button');





        if (obj[0].productname == 'Plural Gateway') {

            console.log('sid');
            this.firstVisible = false;
            this.tableVisible = false;
        } else if (obj[0].productname == 'Credit Card') {
            this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
        } else if (obj[0].productname == 'Debit Card') {
            this.mistakeVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
        } else if (obj[0].productname == 'Credit Card EMI') {
            this.fourthVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
        } else if (obj[0].productname == 'Debit Card EMI') {
            this.fifthVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;




        } else if (obj[0].productname == 'Cardless EMI') {
            this.sixthVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;

        } else if (obj[0].productname == 'Wallet') {
            this.seventhVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;

        } else if (obj[0].productname == 'Net Banking') {
            this.eightVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;

        } else if (obj[0].productname == 'Pay by Points') {
            this.ninthVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            // } else if (len>1) {
            //   this.disableNext = true;

            //------------------------------------------------------------------------------

        } else if (obj[0].productname == 'ALL') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.mistakeVisible = true;
            this.fourthVisible = true;

        } else if (obj[0].productname == 'Rupay Credit Card') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
        } else if (obj[0].productname == 'Amex Credit Card') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
        } else if (obj[0].productname == 'Visa Credit Card') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
        } else if (obj[0].productname == 'MasterCard Credit Card') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fourthVisible = true;
        } else if (obj[0].productname == 'Rupay Credit Card EMI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fourthVisible = true;
        } else if (obj[0].productname == 'Amex Credit Card EMI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fourthVisible = true;
        } else if (obj[0].productname == 'Visa Credit Card EMI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fourthVisible = true;
        } else if (obj[0].productname == 'MasterCard Credit Card EMI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fourthVisible = true;

            // ----------------------------------------------------------------------------             
        } else if (obj[0].productname == 'Kotak Debit Card EMI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fifthVisible = false;
        } else if (obj[0].productname == 'Federal EMI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fifthVisible = false;
        } else if (obj[0].productname == 'HDFC EMI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fifthVisible = false;
        } else if (obj[0].productname == 'ICICI EMI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fifthVisible = false;
        } else if (obj[0].productname == 'Axis') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fifthVisible = false;
            this.ninthVisible = false;
        } else if (obj[0].productname == 'SBI EMI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.fifthVisible = false;

            //----------------------------------------------------------------------------------------

        } else if (obj[0].productname == 'Paytm') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.seventhVisible = false;
        } else if (obj[0].productname == 'Payzapp') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.seventhVisible = false;

            //-----------------------------------------------------------------

        } else if (obj[0].productname == 'Issuers') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.eightVisible = false;

            //-----------------------------------------------------              
        } else if (obj[0].productname == 'Axis') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.ninthVisible = false;


        } else if (obj[0].productname == 'Kotak Credit Card') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.ninthVisible = false;


        } else if (obj[0].productname == 'HDFC') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.ninthVisible = false;
            //------------------------------------------------        
            /* } else if (obj[0].productname == 'ALL') {
                 this.tenthnewVisible = true;
                 //this.thirdVisible = false;
                 this.tableVisible = false;
                 this.firstVisible = true;
                 this.thirdVisible = true;
                 this.mistakeVisible = true; */

        } else if (obj[0].productname == 'Rupay Debit Card') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.mistakeVisible = true;

        } else if (obj[0].productname == 'Amex Debit Card') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.mistakeVisible = true;

        } else if (obj[0].productname == 'Visa Debit Card') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.mistakeVisible = true;

        } else if (obj[0].productname == 'MasterCard Debit Card') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.mistakeVisible = true;

        } else if (obj[0].productname == 'UPI') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            //  this.thirdVisible = true;
            //  this.mistakeVisible = true;








            //---------------------------------------last comment
        } else if (obj[0].productname == 'Amount') {
            this.tenthnewVisible = true;
            //this.thirdVisible = false;
            this.tableVisible = false;
            this.firstVisible = true;
            this.thirdVisible = true;
            this.mistakeVisible = true;
            this.amountVisible = false;
            this.tenthnewVisible = false;












        }

        else { this.tableVisible = false };






    }



    cancelHandler() {
        this.tableVisible = true;
        this.thirdVisible = true;
        this.fourthVisible = true;
        this.firstVisible = true;
        //this.fithVisible = true;
        this.ninthVisible = false;
        this.eightVisible = false;
        this.fifthVisible = false;
        this.sixthVisible = false;
        this.seventhVisible = false;
        this.tenthnewVisible = false;
        this.mistakeVisible = true;
        this.amountVisible = true;

    }



    /*if (obj[0].productname == 'Amazon') {
   
               console.log('sid');
               this.thirdVisible = false;
           } else {
               console.log('new');
               this.tableVisible = true;
           }*/






    @track employeeData = [
        {
            productname: 'Plural Gateway',
            productcode: '',
            description: '',
            value: 'flip'

        }
        /*{
            productname: 'Amazon',
            productcode: '',
            description: '',
            value: 'amaz'
 
        },
        {
            productname: 'Snapdeal',
            productcode: '',
            description: '',
            value: 'amaz'
 
        }*/
    ];


    //second table

    @track secondColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];

    @track secondData = [
        {
            productname: 'Credit Card',
            productcode: '',
            description: ''

        },
        {
            productname: 'Debit Card',
            productcode: '',
            description: ''
        },
        {
            productname: 'Credit Card EMI',
            productcode: '',
            description: ''
        },
        {
            productname: 'Debit Card EMI',
            productcode: '',
            description: ''
        },
        /* {
             productname: 'Cardless EMI',
             productcode: '',
             description: ''
         },*/
        {
            productname: 'UPI',
            productcode: '',
            description: ''
        },
        {
            productname: 'Wallet',
            productcode: '',
            description: ''
        },
        {
            productname: 'Net Banking',
            productcode: '',
            description: ''
        },
        {
            productname: 'Pay by Points',
            productcode: '',
            description: ''
        }


    ]
    //third table

    @track thirdColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];


    @track thirdData = [
        {
            productname: 'ALL',
            productcode: '',
            description: ''

        },
        {
            productname: 'Rupay Credit Card',
            productcode: '',
            description: ''
        },
        {
            productname: 'Amex Credit Card',
            productcode: '',
            description: ''
        },
        {
            productname: 'Visa Credit Card',
            productcode: '',
            description: ''
        },
        {
            productname: 'MasterCard Credit Card',
            productcode: '',
            description: ''
        }
    ];


    //debit mistake

    @track mistakeColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];


    @track mistakeData = [
        {
            productname: 'ALL',
            productcode: '',
            description: ''

        },
        {
            productname: 'Rupay Debit Card',
            productcode: '',
            description: ''
        },
        {
            productname: 'Amex Debit Card',
            productcode: '',
            description: ''
        },
        {
            productname: 'Visa Debit Card',
            productcode: '',
            description: ''
        },
        {
            productname: 'MasterCard Debit Card',
            productcode: '',
            description: ''
        }
    ];

    //fourth table

    @track fourthColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];


    @track fourthData = [
        {
            productname: 'ALL',
            productcode: '',
            description: ''

        },
        {
            productname: 'Rupay Credit Card EMI',
            productcode: '',
            description: ''
        },
        {
            productname: 'Amex Credit Card EMI',
            productcode: '',
            description: ''
        },
        {
            productname: 'Visa Credit Card EMI',
            productcode: '',
            description: ''
        },
        {
            productname: 'MasterCard Credit Card EMI',
            productcode: '',
            description: ''
        },

    ];



    //fith debit card emi

    @track fifthColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];


    @track fifthhData = [
        {
            productname: 'Kotak Debit Card EMI',
            productcode: '',
            description: ''

        },
        {
            productname: 'Federal EMI',
            productcode: '',
            description: ''
        },
        {
            productname: 'HDFC EMI',
            productcode: '',
            description: ''
        },
        {
            productname: 'ICICI EMI',
            productcode: '',
            description: ''
        },
        {
            productname: 'Axis',
            productcode: '',
            description: ''
        },
        {
            productname: 'SBI EMI',
            productcode: '',
            description: ''
        }

    ];



    //cardless emi sixthcolumn

    @track sixthColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];


    @track sixthData = [
        {
            productname: 'Bajaj finance',
            productcode: '',
            description: ''

        },
        {
            productname: 'Zest',
            productcode: '',
            description: ''
        }

    ];

    //seventh wallwt column

    @track seventhColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];


    @track seventhData = [
        {
            productname: 'Paytm',
            productcode: '',
            description: ''

        },
        {
            productname: 'Payzapp',
            productcode: '',
            description: ''
        }


    ];

    //eigth net banking column

    @track eightColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];


    @track eightData = [
        {
            productname: 'Issuers',
            productcode: '',
            description: ''

        }


    ];




    //ninth pay by points column

    @track ninthColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];


    @track ninthData = [
        {
            productname: 'Axis',
            productcode: '',
            description: ''

        },
        {
            productname: 'Kotak Credit Card',
            productcode: '',
            description: ''
        },
        {
            productname: 'HDFC',
            productcode: '',
            description: ''
        }


    ];

    //10th data last level

    @track tenthColumns = [
        { label: 'Product Name', fieldName: 'productname' },
        { label: 'Product Code', fieldName: 'productcode' },
        { label: 'Description', fieldName: 'description' }

    ];


    @track tenthtData = [
        {
            productname: 'Amount',
            productcode: '',
            description: ''

        }


    ];

    //--------------------------------------------------------final amount template//


    bTon = true;
    bbTon = true;
    bdTon = true;
    inField = true;
    outField = true;
    nextTon = true;
    neTon = true;
    capAmo = true;
    textField = true;
    teField = true;
    tField = true;
    addAmo = true;
    tddField = true;
    addAmo = true;
    hybirdCheck = false;
    chCheck;
    pCheck;

    /* buttonHandler() {
    
        var selectedCheck =  this.template.querySelector("text-input-id-46");
    
        console.log('sel'+selectedCheck);
    
        const arr = selectedCheck.getSelectedRows()
        console.log('arr'+arr);
    
        var len = arr.length;
        console.log('length' + len);
    
    }*/

    ePrice(event) {

        if (event.target.checked == false) {
            this.bTon = true;
            //this.bbTon = true;
            this.bdTon = true;
            this.chCheck = false;
        }
        if (event.target.checked == true) {
            this.bTon = false;
            //this.bbTon = false;
            this.bdTon = false;
            this.chCheck = true;
        }

        console.log(event.target.checked);

        let checkbox = document.getElementById('checkbox-unique-id-84');
        console.log(checkbox.checked);

    }


    /*newMeth(event){
       // let checkbox = document.getElementById('checkbox-unique-id-84');
     //console.log(checkbox.checked);
     if(event.target.checked==true){
        this.hybirdCheck=true;
        this.bTon = false;
        this.bdTon = false;
    
        console.log('hybirdworking')
    
     }
     if(event.target.checked==false){
        this.hybirdCheck=false;
        this.bTon = true;
        this.bdTon = true;
    
        console.log('notworkinghybirdworking')
    
     }
    
    }*/

    newMeth(event) {
        this.hybirdCheck = true;
        if (event.target.checked == true) {
            console.log('true hy');
            this.inField = false;
            this.outField = false;
            //this.bdTon = false;
            //this.bTon = false;
            this.hybirdCheck = true;
            this.bTon = false;
            this.bdTon = false;
            
        }
        if (event.target.checked == false) {
            console.log('false hy');
            this.inField = true;
            this.outField = true;
            //this.bdTon = true;
            //this.bTon = true;
            this.hybirdCheck = false;
            this.bTon = true;
            this.bdTon = true;
           
        }
    }


    inOut(event) {
        //this.inField = false;
        if (event.target.checked == true) {
            console.log('checkpercent'),
                this.bTon = true;
            //this.outField = true;
            this.inField = false;
            this.hybirdCheck = false;
            this.pCheck = true;
            
        }

        if (event.target.checked == false) {
            console.log('checkpercent'),
                this.bTon = false;
            this.inField = true;
            this.hybirdCheck = false;
            this.pCheck = false;
            
        }

    }


    seCond(event) {
        

        if (event.target.checked == true) {
            console.log('checkpercent'),
                this.bdTon = true;
                this.outField = false;
                this.fCheck = true;
            this.hybirdCheck = false;
        }

        if (event.target.checked == false) {
            console.log('checkpercent'),
                this.bdTon = false;
            this.outField = true;
            this.fCheck = false;
            this.hybirdCheck = false;
        }
    }

    newPrice(event) {
        if (event.target.checked == false) {
            console.log('newprice'),
                this.nextTon = true;
            this.neTon = true;
            this.capAmo = true;
            this.addAmo = true;
            this.textField = true;
            this.teField = true;
            this.tField = true;
            this.tddField = true;
        }

        if (event.target.checked == true) {
            console.log('truenewprice'),
                this.nextTon = false;
            this.neTon = false;
            this.capAmo = false;
            this.addAmo = false;
        }
    }

    nextOut() {

       
        this.textField = false;
        

       
    }

    sCond() {
        this.teField = false;
    }

    tCon() {
        this.tField = false;

    }

    tddCon() {

        this.tddField = false;

    }



}

