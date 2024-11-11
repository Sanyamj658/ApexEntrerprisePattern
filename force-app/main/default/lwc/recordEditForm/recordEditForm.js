import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import cricketer_obj from '@salesforce/schema/Cricketer__c';
import Name from '@salesforce/schema/Cricketer__c.Name';
import Coach from '@salesforce/schema/Cricketer__c.Coach__c';
import Picture from '@salesforce/schema/Cricketer__c.Picture__c';


export default class RecordEditForm extends LightningElement {
    objectApiName = cricketer_obj;
    NameField = Name;
    CoachField = Coach;
    PictureField = Picture;

    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Player created',
            variant: 'success'
        });

        this.dispatchEvent(toastEvent);
    }
}