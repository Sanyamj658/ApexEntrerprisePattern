import { LightningElement } from "lwc";

export default class ToDoApplication extends LightningElement {
  taskDate = null;
  taskName = "";

  incompletetask = [];
  completetask = [];

  // Function to generate a unique ID
  generateUniqueId() {
    return "task-" + Date.now();
  }

  changeHandler(event) {
    const { name, value } = event.target;
    if (name === "taskName") {
      this.taskName = value;
    } else if (name === "taskDate") {
      this.taskDate = value;
    }
  }

  resetHandler() {
    this.taskName = "";
    this.taskDate = null;
  }

  addTaskHandler() {
    // If end date is missing, populate with today's date
    if (!this.taskDate) {
      this.taskDate = new Date().toISOString().slice(0, 10);
    }

    if (this.validateTask()) {
      this.incompletetask = [
        ...this.incompletetask,
        {
          id: this.generateUniqueId(), // Use the custom unique ID generator
          taskName: this.taskName,
          taskDate: this.taskDate
        }
      ];
      this.resetHandler();
      this.incompletetask = this.sortTask(this.incompletetask);
    }
  }

  validateTask() {
    let isValid = true;
    const element = this.template.querySelector(".taskName");
    if (!this.taskName) {
      isValid = false;
    } else {
      const taskItem = this.incompletetask.find(
        (currItem) =>
          currItem.taskName === this.taskName &&
          currItem.taskDate === this.taskDate
      );
      if (taskItem) {
        isValid = false;
        element.setCustomValidity("Task is already mentioned");
      }
    }

    if (isValid) {
      element.setCustomValidity("");
    }
    element.reportValidity();
    return isValid;
  }

  sortTask(inputArr) {
    return inputArr.sort((a, b) => new Date(a.taskDate) - new Date(b.taskDate));
  }

  removalHandler(event) {
    const id = event.target.dataset.id;
    this.incompletetask = this.incompletetask.filter((task) => task.id !== id);
    this.incompletetask = this.sortTask(this.incompletetask);
  }

  completeTaskHandler(event) {
    const id = event.target.dataset.id;
    const [completedTask] = this.incompletetask.filter(
      (task) => task.id === id
    );
    this.incompletetask = this.incompletetask.filter((task) => task.id !== id);
    this.incompletetask = this.sortTask(this.incompletetask);
    this.completetask = [...this.completetask, completedTask];
  }
}