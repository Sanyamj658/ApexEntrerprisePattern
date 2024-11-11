import { LightningElement, track  } from 'lwc';
import getFavTasks from '@salesforce/apex/FavTaskController.getFavTasks';

export default class FavTask extends LightningElement {

    favTasks = [];
    @track column = [
      { label: 'Task Name', fieldName: 'Name' },
      { label: 'Task List Name', fieldName: 'TaskList__r.Name' }
    ]


}