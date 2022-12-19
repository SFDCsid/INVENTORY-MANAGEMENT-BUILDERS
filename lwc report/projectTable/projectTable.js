import { LightningElement, wire, track, api } from 'lwc';
import excecutiveMethod from '@salesforce/apex/projectTableClass.excecutiveMethod';
import lisDat from '@salesforce/apex/projectwrapperClass.lisDat';
import wrapData from '@salesforce/apex/projectwrapperClass.wrapData';
import lisprojects from '@salesforce/apex/projectwrapperClass.lisprojects';

export default class ProjectTable extends LightningElement {

    executiveList;
    projectList;
    wrapperList;

    /*
        @wire(excecutiveMethod)
        getProject({ error, data }) {
            let arr = [];
          
            if (data) {
    
                for (let key in data) {
                    arr.push({ label: data[key] });
    
    
                }
                this.executiveList = arr;
             
            }
            else if (error) {
                this.error = undefined;
            }
        }*/

    @wire(lisDat)
    wiredAccounts({ error, data }) {
        if (data) {
            this.wrapperList = data;
            console.log('wrapper' + JSON.stringify(this.wrapperList));
        } else if (error) {
            this.error = error;
        }
    }

    @wire(lisprojects)
    wiredAccounts({ error, data }) {
        if (data) {
            this.projectList = data;
            console.log('project' + this.projectList);
            /*
                        data.forEach(mobile => {
                            for (let key in mobile) {
                             console.log(`${key}: ${mobile[key]}`)
                              this.projectList = mobile[key];
                             console.log('pro' + JSON.stringify(this.projectList));
                            }
                          })
                        console.log('project' + JSON.stringify(this.projectList));
            */

        } else if (error) {
            this.error = error;
        }


    }





}