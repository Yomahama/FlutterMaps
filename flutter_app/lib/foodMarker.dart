class FoodMarker {
  String id;
  String latLng; // Splitted by commas only
  String title;
  String address;
  String number;
  String imageSource;

  FoodMarker(this.id, this.latLng, this.title, this.address, this.number,
      this.imageSource);

  Map<String, dynamic> toJson() {
    return {
      id: this.id,
      latLng: this.latLng,
      title: this.title,
      address: this.address,
      number: this.number,
      imageSource: this.imageSource
    };
  }

  FoodMarker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latLng = json['latidudeLongtidude'];
    title = json['title'];
    address = json['address'];
    number = json['number'];
    imageSource = json['imageSource'];
  }
}
