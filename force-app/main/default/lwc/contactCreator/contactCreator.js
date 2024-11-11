import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import contact_obj from '@salesforce/schema/Contact';
import FirstName_field from '@salesforce/schema/Contact.FirstName';
import LastName_field from '@salesforce/schema/Contact.LastName';
import Email_field from '@salesforce/schema/Contact.Email';
export default class ContactCreator extends LightningElement {
    objectApiName = contact_obj;
    fields = [FirstName_field, LastName_field, Email_field];
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Contact created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}