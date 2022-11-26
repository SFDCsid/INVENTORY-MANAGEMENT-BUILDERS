import { LightningElement, api, track, wire } from 'lwc';
import getProject from '@salesforce/apex/fetchData.getProject';
import getSector from '@salesforce/apex/fetchData.getSector';
import getTower from '@salesforce/apex/fetchData.getTower';
import getUnits from '@salesforce/apex/fetchData.getUnits';
import getFloor from '@salesforce/apex/fetchData.getFloor';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
export default class Realestate extends LightningElement {






    @api project;
    @api sector;
    @api tower;
    @track data;
    @track keyOptionList = [];
    @track valueOptionList = [];

    unit;
    projectOptionList;
    sectorOptionList;
    towerOptionList;

    @wire(getProject) retrieveProject({ error, data }) {
        let tempArray = [];
        if (data) {

            for (let key in data) {
                tempArray.push({ label: data[key], value: key });


            }
            this.projectOptionList = tempArray;
            console.log('STRING' + JSON.stringify(this.projectOptionList));

        }
        else if (error) {
            this.result = undefined;
        }


    }
    handleChangeProject(event) {
        this.project = event.detail.value;

    }
    @wire(getSector, { Id: '$project' }) retriveSector({ error, data }) {

        let array = [];
        if (data) {
            for (let key in data) {
                array.push({ label: data[key], value: key });
            }
            this.sectorOptionList = array;

        }
        else if (error) {
            this.result = undefined;
        }
    }
    handleSectorChange(event) {
        this.sector = event.detail.value;
    }
    @wire(getTower, { Id: '$sector' }) retriveTower({ error, data }) {
        let tempArray = [];
        if (data) {
            for (let key in data) {
                tempArray.push({ label: data[key], value: key });
            }
            this.towerOptionList = tempArray;
        }
        else if (error) {
            this.result = undefined;
        }
    }
    handleTowerChange(event) {
        this.tower = event.detail.value;
        //console.log(this.tower);
    }

    @wire(getFloor, { Id: '$tower' }) retriveFloor({ error, data }) {
        if (data) {
            this.data = data;
            //alert(data);
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getUnits, { Id: '$tower' }) retriveUnits(result) {
        let keyArray = [];

        if (result.data) {
            for (let key in result.data) {
                alert(key);
                keyArray.push({ key: key });
                this.keyOptionList = keyArray;
                console.log('ghfghfg' + this.keyOptionList);
            }
        }
    }
    @wire(getUnits, { Id: '$tower' }) retriveUnits(result) {
        let valueArray = [];

        if (result.data) {
            for (let key in result.data) {
                //alert(key);
                valueArray.push({ value: result.data[key] });
                //console.log(valueArray);
                this.valueOptionList = valueArray;
                console.log('valuelist'+JSON.stringify(this.valueOptionList));
            }
        }
    }
}
