import { LightningElement } from 'lwc';
import { showToastEvent } from 'lightning/platformShowToastEvent';

export default class Firstlwc extends LightningElement {
    myTitle = "Sanyam Jain";
/*
    //function1 
    handleclick(){
        this.showToast();
    }

    //function 2 
    
    showToast(){
        const event = new showToastEvent({
        title : 'Showing toast',
        message : 'testing the toast',
        variant : 'Success',
    }) 
    this.dispatchEvent(event);
 }
 */

    connectedCallback(){
        let result = this.myFunction(10,5);
        window.alert(result);
    }

    myFunction  = (a,b) => {
        return (a/b);
    }
}