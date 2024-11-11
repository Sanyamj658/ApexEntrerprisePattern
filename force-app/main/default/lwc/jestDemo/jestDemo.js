import { LightningElement, wire} from 'lwc';
import getaccountList from '@salesforce/apex/jestDemo.getaccountList'

export default class JestDemo extends LightningElement {
    @wire(getaccountList)
    accounts;
    tacostuff = 'tacof are excitig';
    showNewParagraph = false;
    tacoList = [{id : 1, Name :'A'},
    {id : 2, Name :'B'},{id : 3, Name :'C'}
]
    renderNewParagraph(){
        this.showNewParagraph = true;
    }

    connectedCallback(){
       // console.log("THIS IS THE ACCOUNT DATA : -->", JSON.stringify(this.accounts))
    }
}