import { LightningElement } from 'lwc';

export default class ParentLwc extends LightningElement {
    
    countValue = 0;

    handleSubtract(){
        this.countValue--;
    }

    handleAddition(){
        this.countValue++;
    }

    handleMultiply(event){
        const multiplyValue = event.detail;
        this.countValue*=multiplyValue;
    }
}