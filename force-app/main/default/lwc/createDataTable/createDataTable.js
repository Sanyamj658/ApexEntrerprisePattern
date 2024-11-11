import { LightningElement, wire } from 'lwc';
import getUsers from '@salesforce/apex/ContactController.getContactList';


export default class CreateDataTable extends LightningElement {
    
    //first array create to store the data
    data = [];

    //create the columns 
    columns = [
        { label: "AccountId", fieldName: "AccountId", type: "text" },
        { label: 'Email', fieldName: 'Email', type: 'email' }
    ];

    //wire method call
    @wire(getUsers)
    wiredUsers({ error, data }) {
        if (data) {
            this.data = data;
        } else if (error) {
            console.error('Error fetching users:', error);
        }
    }
}