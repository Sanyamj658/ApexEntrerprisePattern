import { LightningElement, api} from 'lwc';

export default class ChildComponent extends LightningElement {
   @api myTitle = "ChildComponentsSalesforce";

   @api handleValueChange(){
    this.myTitle = "ChildHandleValue";
   }
}