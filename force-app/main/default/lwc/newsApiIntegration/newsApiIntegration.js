// NewsComponent.js
import { LightningElement, track, wire } from "lwc";
import retriveNews from "@salesforce/apex/NewsAPIClient.retriveNews";
import retrieveNewsOnSearch from "@salesforce/apex/NewsAPIClient.retrieveNewsOnSearch";
import NewsApiIntegration from "@salesforce/resourceUrl/NewsApiIntegration";

export default class NewsComponent extends LightningElement {
  altimage = NewsApiIntegration;
  @track category;
  @track country;
  @track error;
  @track result;

  // connectedCallback() {
  //   this.fetchNews();
  // }

  get CountryOptions() {
    return [
      { label: "Default", value: "" },
      { label: "United Arab Emirates", value: "ae" },
      { label: "Argentina", value: "ar" },
      { label: "Austria", value: "at" },
      { label: "Australia", value: "au" },
      { label: "Belgium", value: "be" },
      { label: "Bulgaria", value: "bg" },
      { label: "Brazil", value: "br" },
      { label: "Canada", value: "ca" },
      { label: "Switzerland", value: "ch" },
      { label: "China", value: "cn" },
      { label: "Colombia", value: "co" },
      { label: "Cuba", value: "cu" },
      { label: "Czech Republic", value: "cz" },
      { label: "Germany", value: "de" },
      { label: "Egypt", value: "eg" },
      { label: "France", value: "fr" },
      { label: "United Kingdom", value: "gb" },
      { label: "Greece", value: "gr" },
      { label: "Hong Kong", value: "hk" },
      { label: "Hungary", value: "hu" },
      { label: "Indonesia", value: "id" },
      { label: "Ireland", value: "ie" },
      { label: "Israel", value: "il" },
      { label: "India", value: "in" },
      { label: "Italy", value: "it" },
      { label: "Japan", value: "jp" },
      { label: "South Korea", value: "kr" },
      { label: "United States", value: "us" },
      { label: "Venezuela", value: "ve" },
      { label: "South Africa", value: "za" }
    ];
  }

  get CategoryOptions() {
    return [
      { label: "Default", value: "" },
      { label: "Business", value: "business" },
      { label: "Entertainment", value: "entertainment" },
      { label: "General", value: "general" },
      { label: "Health", value: "health" },
      { label: "Science", value: "science" },
      { label: "Sports", value: "sports" },
      { label: "Technology", value: "technology" }
    ];
  }

  // fetchNews() {
  //   retriveNews()
  //     .then((response) => {
  //       console.log(response);
  //       this.formatNewsData(response.articles);
  //     })
  //     .catch((error) => {
  //       this.error = error;
  //       this.dispatchEvent(
  //         new CustomEvent("toast", {
  //           detail: {
  //             variant: "error",
  //             message: error.body.message
  //           }
  //         })
  //       );
  //     });
  // }

  @wire(retriveNews)
  wiredNews({ error, data }) {
    if (data) {
      this.formatNewsData(data.articles);
    } else if (error) {
      this.error = error;
     
    }
  }
  // connectedCallback() {
  //   retriveNews()
  //     .then((response) => {
  //       console.log(response);
  //       this.formatNewsData(response.articles);
  //     })
  //     .catch((error) => {
  //       console.log("error is -->", error);
  //     });
  // }
  // formatNewsData(data) {
  //   // format the news data as needed
  //   this.newsData = data;
  // }

  formatNewsData(res) {
    this.result = res.map((item, index) => {
      let id = `new_${index + 1}`;
      let date = new Date(item.publishedAt).toDateString();
      let name = item.source.name;
      return { ...item, id: id, name: name, date: date };
    });
  }

  handleCategoryChange(event) {
    this.category = event.target.value;
  }

  handleCountryChange(event) {
    this.country = event.target.value;
  }

  handleSearch() {
    if (!this.category == ''|| !this.country == '') {
      // Call another method
      this.category = "business";
      this.country = "us";
     // this.connectedCallback();
      //return; // Exit the function
    }
    retrieveNewsOnSearch({ category: this.category, country: this.country })
      .then((response) => {
        // console.log(response);
        this.formatNewsData(response.articles);
      })
      .catch((error) => {
        console.error("Error fetching searched news:", error);
      });
  }
}