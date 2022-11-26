import { LightningElement, track, wire, api } from 'lwc';
import getLeadList from '@salesforce/apex/GetLeadRecords.getLeadList';
export default class LeadList extends LightningElement {

    @wire(getLeadList) leadlist;
}