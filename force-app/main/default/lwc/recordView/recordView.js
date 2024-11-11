import { api,LightningElement } from 'lwc';
import cricketer_obj from '@salesforce/schema/Cricketer__c';
import Name from '@salesforce/schema/Cricketer__c.Name';
import Coach from '@salesforce/schema/Cricketer__c.Coach__c';
import Picture from '@salesforce/schema/Cricketer__c.Picture__c';


export default class RecordView extends LightningElement {
    objectApiName = cricketer_obj;
    NameField = Name;
    CoachField = Coach;
    PictureField = Picture;

    @api recordId = 'a06GA00001Hj45eYAB';
}