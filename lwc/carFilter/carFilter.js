import { LightningElement, wire , track} from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi'
import CAR_OBJECT from '@salesforce/schema/CAR__c'
import CATEGORY_FIELD from '@salesforce/schema/CAR__c.Category__c'
import MAKE_FIELD from '@salesforce/schema/CAR__c.Make__c'
const CATEGORY_ERROR = 'Error loading Categories'
const MAKE_ERROR = 'Error loading Make'

export default class CarFilter extends LightningElement {


    categoryerror = CATEGORY_ERROR;
    makeError = MAKE_ERROR;


    @track filters = {
        searchkey: '',
        maxPrice: 999999
    }

    @wire(getObjectInfo, { objectApiName: CAR_OBJECT })
    carObjectInfo

    @wire(getPicklistValues, { recordTypeId: '$carObjectInfo.data.defaultRecordTypeId', fieldApiName: CATEGORY_FIELD }) categories


    @wire(getPicklistValues, { recordTypeId: '$carObjectInfo.data.defaultRecordTypeId', fieldApiName: MAKE_FIELD }) makeType





    handleMaxPriceChange(event) {
        console.log(event.target.value)
        this.filters.maxPrice = event.target.value

    }


    handleSearchKeyChange(event) {
        console.log(event.target.value)
this.filters.searchkey = event.target.value

    }


    handleCheckbox(event){
        const{name , value}= event.target.dataset
        console.log('name' +name)
        console.log('value' +value)
    }
}