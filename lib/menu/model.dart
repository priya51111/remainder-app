class Menus {
  final String id;        // Unique identifier for the menu
  final String menuname;  // Name of the menu
  final String date;      // Date associated with the menu
  final String menuId;    // Menu ID from the response

  Menus({
    required this.id,      // Make id a required parameter
    required this.menuname, // Make menuname a required parameter
    required this.date,    // Make date a required parameter
    required this.menuId,  // Make menuId a required parameter
  });

  // Factory constructor to create a Menu from JSON
  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      id: json['_id'],                 // Access the unique ID
      menuname: json['menuname'],       // Access the menu name
      date: json['date'],               // Access the date
      menuId: json['_id'],              // Assuming menuId is the same as _id
    );
  }

  // Convert Menu instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,                       // Include id in the JSON
      'menuname': menuname,            // Include menuname in the JSON
      'date': date,                    // Include date in the JSON
      'menuId': menuId,                // Include menuId in the JSON if needed
    };
  }
}
