import { LightningElement } from 'lwc';
import LEVELTEMP from './level0.html'
import BANKTEMP from './bank.html'
import CREDITTEMP from './credit.html'
import DEBITTEMP from './debit.html'
import PURALTEMP from './pural.html'
import EMITEMP from './emi.html'

export default class Bank extends LightningElement {

    render(){
      return  this.button==='Level 0'? LEVELTEMP :
                this.button==='Amazon Plan'? CREDITTEMP:
                this.button==='Flipkart'? DEBITTEMP:
                this.button==='Pural CheckOut'? PURALTEMP:
                this.button==='EMI'? EMITEMP:
      
      BANKTEMP
    }


    button
    handleNext(event){
        console.log('pass')
            
            console.log(this.con)
            this.button=this.con
            
    }
    selected={}
    con
    clickHandler(event){
        this.con=event.target.label
        }


    clickHandlerr(event){
        console.log('button')
        this.button=event.target.label;
    }
    

}