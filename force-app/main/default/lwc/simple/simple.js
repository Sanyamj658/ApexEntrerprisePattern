import { LightningElement, track } from "lwc";
import { refreshApex } from "@salesforce/apex";
import transcationRecord from "@salesforce/apex/transcation.transcationRecord";

import monthlyInstallment from "@salesforce/apex/transcation.monthlyInstallment";

const columns = [
  { label: "Installment Name", fieldName: "installmentName" },
  { label: "Transaction Name", fieldName: "transactionName" },
  { label: "Billing Date", fieldName: "billingDate" },
  { label: "Amount", fieldName: "amount" }
];

export default class Simple extends LightningElement {
  @track Name;
  @track date;
  @track month;
  @track amount;
  @track paymentDate;
  @track columns = columns;
  @track showDataTable;
  @track installments = [];
  instalmentAmount = 0;
  @track transactionName = ""; // Define and initialize transactionName

  get monthoptions() {
    return [
      { label: "3", value: "3" },
      { label: "6", value: "6" },
      { label: "9", value: "9" },
      { label: "12", value: "12" }
    ];
  }

  get paymentDateOption() {
    return [
      { label: "1", value: "1" },
      { label: "5", value: "5" },
      { label: "9", value: "9" },
      { label: "12", value: "12" }
    ];
  }

  handleInputChange(event) {
    this.transactionName = event.target.value;
  }

  handleDateChange(event) {
    this.date = event.target.value;
  }

  handleMonthChange(event) {
    this.month = event.target.value;
  }

  handleAmountChange(event) {
    this.amount = event.target.value;
  }

  handlePaymentDateChange(event) {
    this.paymentDate = event.target.value;
    console.log("payment date -->", this.paymentDate);
  }

  calculateInstallment() {
    this.instalmentAmount = this.amount / this.month;
    // this.installments = []; // Clear installments array
    const firstPayment = new Date(this.date);

    for (let i = 1; i <= this.month; i++) {
      const dueDate = new Date(firstPayment);
      dueDate.setMonth(dueDate.getMonth() + i);

      this.installments.push({
        installmentName:
          this.getMonthName(dueDate.getMonth()) + " " + dueDate.getFullYear(),
        transactionName: this.transactionName, // Assign transactionName
        billingDate: this.formatDate(dueDate),
        amount: this.instalmentAmount
      });
    }
  }

  handleClick() {
    this.showDataTable = true;
    this.calculateInstallment();
  }

  getMonthName(monthIndex) {
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthNames[monthIndex];
  }

  formatDate(date) {
    const day = this.paymentDate;
    const month = date.getMonth() + 1;
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
  }

  handleSave() {
    transcationRecord({
      Name: this.transactionName,
      PurchaseDate: this.date,
      paymentDate: this.paymentDate,
      amount: this.amount,
      noOfMonth: this.month
    })
      .then((recordId) => {
        console.log("Transaction saved successfully:", recordId);
        this.transactionId = recordId;
        console.log(this.installments);
        const records = this.installments.map((item) => ({
          Name: item.installmentName,
          BillingDate__c: item.billingDate,
          Amount__c: item.amount
        }));

        monthlyInstallment({
          parentId: this.transactionId,
          installments: records
        })
          .then(() => {
            console.log("Child records created successfully");
          })
          .catch((error) => {
            console.error("Error creating child records:", error);
          });
      })
      .catch((error) => {
        console.log("Transaction saved successfully:", error);
      });
  }
}