import { LightningElement,track } from 'lwc';
import getCountryName from '@salesforce/apex/ImperativeDemo.getCountryName';

const columns = [
    {label : "COUNTRY Id", fieldName:'Id'},
    {label : "Country Name", fieldName:'Name'},
    {label : "Coach Name", fieldName:'Coach__c'},
]

export default class ImperativeMethodDemo extends LightningElement {
    @track columns = columns;
    @track data = [];

    connectedCallback(){
        getCountryName()
        .then(result =>{
            this.data = result;
        })
        .catch(error =>{
            console.log("Error Occured",error);
        })
    }

    
}