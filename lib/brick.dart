class Brick {
  int? id;
  String color;
  String size;
  String type;
  int quantity;

  Brick({
    this.id,
    required this.color,
    required this.size,
    required this.type,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color,
      'size': size,
      'type': type,
      'quantity': quantity,
    };
  }

  static Brick fromMap(Map<String, dynamic> map) {
    return Brick(
      id: map['id'],
      color: map['color'],
      size: map['size'],
      type: map['type'],
      quantity: map['quantity'],
    );
  }

  // Returns a brick with no id based on the string format we use, LDRAW-ID_TYPE(may include a subtype after another '_')_SIZE
  // Second arg is a string of color
  // The LDRAW id is NOT used here
  // Performs no sanity checks on the string other than the delim split; be sure it's right
  static Brick? fromStrings(String b, String color, [int? count]) {
    var substrs = b.split("_");
    if(substrs.length == 3) {
      return Brick(
        color: color,
        type: substrs[1],
        size: substrs[2],
        quantity: count ?? 1  
      );
    }
    else if(substrs.length == 4) {
      return Brick(
        color: color,
        // Type and subtype are merged with "_"
        type: "${substrs[1]}_${substrs[2]}",
        size: substrs[3],
        quantity: count ?? 1  
      );
    }
    else {
      return null;
    }
  }
}
