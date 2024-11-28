class Menus {
  final String id;        
  final String menuname;  
  final String date;      
  final String menuId;    

  Menus({
    required this.id,      
    required this.menuname, 
    required this.date,    
    required this.menuId, 
  });

 
  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      id: json['_id'],                 
      menuname: json['menuname'],      
      date: json['date'],              
      menuId: json['_id'],             
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,                       
      'menuname': menuname,           
      'date': date,                    
      'menuId': menuId,                
    };
  }
}
