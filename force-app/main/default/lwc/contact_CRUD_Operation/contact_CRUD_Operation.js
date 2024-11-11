import { LightningElement, api, track, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { deleteRecord } from "lightning/uiRecordApi";
import getContacts from "@salesforce/apex/ContactsCrudOperation.getContacts";

const actions = [
  { label: "View", name: "view" },
  { label: "Edit", name: "edit" },
  { label: "Delete", name: "delete" }
];
const columns = [
  { label: "Name", fieldName: "Name", hideDefaultActions: true },
  { label: "Phone", fieldName: "Phone", hideDefaultActions: true },
  { label: "Email", fieldName: "Email", hideDefaultActions: true },
  { label: "AccountName", fieldName: "AccountId", hideDefaultActions: true },
  { type: "action", typeAttributes: { rowActions: actions } }
];

export default class OpportunityProduct extends NavigationMixin(
  LightningElement
) {
  @track columns = columns;
  @track data = [];
  @track isShowModal = false;
  @api recordId;
  @track isEditRecord = false;
  @track recordIdToEdit;
  @track openEditForm = false;
  @track showLoadingSpinner = false;

  ContactName;
  ContactPhone;
  ContactEmail;
  ContactAccountName;

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
      { label: 15, value: 15 }
    ];
  }

  @wire(getContacts)
  wiredContacts({ error, data }) {
    this.item = data;
    if (data) {
      this.data = data;
      this.totalRecord = data.length;
      this.totalPage = Math.ceil(this.totalRecord / this.pageSize);
      this.displayRecordPerPage(this.page);
    } else if (error) {
      console.error(error);
    }
  }
  showModalBox() {
    this.isShowModal = true;
  }

  hideModalBox() {
    this.isShowModal = false;
  }

  handleRowAction(event) {
    let myRecordId = event.detail.row.Id;
    const actionName = event.detail.action.name;
    switch (actionName) {
      case "view":
        this[NavigationMixin.Navigate]({
          type: "standard__recordPage",
          attributes: {
            recordId: myRecordId,
            objectApiName: "contact",
            actionName: "view"
          }
        });
        break;
      case "delete":
        this.showLoadingSpinner = true; // Show spinner before deleting
        deleteRecord(myRecordId)
          .then(() => {
            this.showLoadingSpinner = false; // Hide spinner after deletion
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Success",
                message: "Your Contact has been deleted successfully",
                variant: "success"
              })
            );
            return refreshApex(this.wiredContacts);
          })
          .catch((error) => {
            this.showLoadingSpinner = false; // Hide spinner if there's an error
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Error while deleting record",
                message: error.body.message,
                variant: "success"
              })
            );
          });
        break;
      case "edit":
       // this.showLoadingSpinner = true;
        this.myRecordId = event.detail.row.Id;
        this.openEditForm = true;
        break;

      default:
        console.log("select the correct option");
    }
  }

  handleSubmit(event) {
    const fields = event.detail.fields;
    this.isShowModal = false;
    return refreshApex(this.wiredContacts);
  }
  handleEditSubmit(event) {
    console.log("onsubmit event recordEditForm" + event.detail.fields);
  }

  closeEditModal() {
    this.openEditForm = false;
  }

  handleEditSuccess(event) {
    this.openEditForm = false;
    this.showLoadingSpinner = true;
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success",
        message: "Contact updated successfully",
        variant: "success"
      })
    );
    return refreshApex(this.wiredContacts);
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
    this.page = this.totalPage;
    this.displayRecordPerPage(this.page);
  }

  get handlePreviousDisable() {
    return this.page === 1;
  }

  get handleNextDisable() {
    return this.page === this.totalPage || this.page == 0;
  }
  get bDisableLast() {
    return this.page === this.totalPage;
  }
  get bDisableFirst() {
    return this.page === 1;
  }

  displayRecordPerPage(page) {
    this.startingRecord = (page - 1) * this.pageSize;
    this.endRecord = this.startingRecord + this.pageSize;
    this.data = this.item.slice(this.startingRecord, this.endRecord);
  }

  handleChangeCombox(event) {
    this.pageSize = parseInt(event.detail.value);
    this.totalPage = Math.ceil(this.totalRecord / this.pageSize);
    this.displayRecordPerPage(this.page);
  }
}