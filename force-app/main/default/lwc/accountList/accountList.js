import { LightningElement, track, wire } from 'lwc';
import getAccount from '@salesforce/apex/AccountLists.getAccount';

const columns = [
    { label: "Name", fieldName: 'Name' },
    { label: "Phone", fieldName: 'Phone' },
    { label: "Industry", fieldName: 'Industry' },
];

export default class accountList extends LightningElement {
    @track columns = columns;
    @track searchedData = '';
    @track data = [];
    @track error;
    item = [];
    startingRecord;
    page = 1;
    endRecord;
    totalRecord; 
    totalPage;
    pageSize = 5;
    value = 1;
    get options() {
        return [
            { label: 5, value: 5 },
            { label: 10, value: 10 },
            { label: 15, value: 15 },
        ];
    }


    connectedCallback() {
        this.handleSearch();
    }
    //offset = 0;
    handleInputChange(event) {
        this.searchedData = event.target.value;
    }

    @wire(getAccount,{actName : '$searchedData'}) account({error,data})
    {
        if(data)
        {
            this.data = data;
           // console.log(data);
            this.displayRecordPerPage(this.page);
           // console.log(this.data);
        }
        else if(error){
            this.error = error;
        }
    }

    handleSearch() {
        getAccount({ actName: this.searchedData})
            .then(result => {
                this.item = result;
                this.totalRecord = result.length; // Corrected variable name
                this.totalPage = Math.ceil(this.totalRecord / this.pageSize);
                this.displayRecordPerPage(this.page); // Display records for the current page
            })
            .catch(error => {
                console.error("Error Occurred", error);
            });
    }

    handleNext() {
        if (this.page < this.totalPage) {
            this.page++;
            this.displayRecordPerPage(this.page);
        }
    }

    handlePrevious() {
        if (this.page > 1) {
            this.page--;
            this.displayRecordPerPage(this.page);
        }
    }

    firstPage() {
        this.page = 1;
        this.displayRecordPerPage(this.page);
    }
    lastPage() {
        this.page = this.totalPages;
        this.displayRecordPerPage(this.page);
    }

   get handlePreviousDisable(){
        return this.page == 1;
    }

   get  handleNextDisable(){
        return this.page == this.totalPage || this.page ==0  ;
    }

    displayRecordPerPage(page) {
        this.startingRecord = (page - 1) * this.pageSize;
        this.endRecord =  this.startingRecord + this.pageSize;
       // this.endRecord = (this.endRecord > this.totalRecord) ? this.totalRecord : this.endRecord;
        this.data = this.item.slice(this.startingRecord, this.endRecord);
    }

    handleChangeCombox(event) {
        this.pageSize = parseInt(event.detail.value);
        this.displayRecordPerPage(this.page);
    }
}