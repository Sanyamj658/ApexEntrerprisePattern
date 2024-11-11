import { LightningElement, track} from 'lwc';

export default class IfCondtionuse4 extends LightningElement {

    @track onClickButton = 'Show';
    @track carVisible = false;
    myTitle = "salesforce learning";

    handleClick(event){ 
        if(event.target.label === "Show"){   
            this.onClickButton = 'Hide';
            this.carVisible = true;
        }
        else if(event.target.label === 'Hide'){
            this.onClickButton = 'Show';
            this.carVisible = false;
        }
    }
}