import { LightningElement, track, api,wire} from 'lwc';
//import getOpportunityProduct from '@salesforce/apex/opportunityProduct.getOpportunityProduct';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';


const columns = [
    { label: "Name", fieldName: 'Name',editable : true },
    { label: "Phone", fieldName: 'Phone__c' },
    { label: "Balance", fieldName: 'Balance__c' },
    { label: "Type", fieldName: 'Type__c'}
];

export default class OpportunityProduct extends LightningElement {
    @track columns = columns;
    @track data = [];
    records;
    @track isShowModal = false;
    @api recordId;

    // connectedCallback(){
    //     getOpportunityProduct()
    //     .then(result =>{
    //         this.data = result;
    //     })
    //     .catch(error =>{
    //         console.log("Error Occured",error);
    //     })
    // }

    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: 'OpportunityProduct__c',
        fields: ['OpportunityProduct__c.Name','OpportunityProduct__c.Id','OpportunityProduct__c.Balance__c','OpportunityProduct__c.Phone__c','OpportunityProduct__c.Type__c'],
    }) listInfo( { error, data } ) {
        if(data)
        {
            this.data = data;
        }
        else if(error){
            this.error = error;
        }
    }
    

    showModalBox() {  
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }

}