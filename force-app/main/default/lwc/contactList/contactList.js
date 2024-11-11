import { LightningElement, wire } from 'lwc';
import  FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import { reduceErrors } from 'c/ldsUtils';

export default class AccountList extends LightningElement {
    COLUMNS = [
        { label: 'First Name', fieldName: FIRSTNAME_FIELD.fieldApiName, type: 'text' },
        { label: 'Last Name',  fieldName: LASTNAME_FIELD.fieldApiName,  type: 'text' },
        { label: 'Email',      fieldName: EMAIL_FIELD.fieldApiName,     type: 'email' }
    ];
    columns = this.COLUMNS;
    @wire(getContacts)
    contacts;

    get errors() {
        return (this.contacts.error) ?
            reduceErrors(this.contacts.error) : [];
    }
}