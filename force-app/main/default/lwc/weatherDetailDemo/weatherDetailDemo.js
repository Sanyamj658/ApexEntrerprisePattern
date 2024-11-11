import { LightningElement } from "lwc";
import getWeatherDetails from "@salesforce/apex/weatherDetaiClass.getWeatherDetails";
export default class WeatherDetailDemo extends LightningElement {
  inputCityName = "";
  weatherDetails = {};
  showWeatherDetails = false;

  handleInputChange(event) {
    this.inputCityName = event.detail.value;
    console.log("this.inputCityName-->" + this.inputCityName);
  }

  handleWeatherDetails() {
    getWeatherDetails({ city: this.inputCityName })
      .then((result) => {
        this.showWeatherDetails = true;
        console.log(result);
        this.weatherDetails = result;
      })
      .catch((error) => {
        this.showWeatherDetails = false;
        console.log("Some error occurred while fetching weather details");
      });
    console.log("result " + JSON.stringify(this.weatherDetails));
  }
}