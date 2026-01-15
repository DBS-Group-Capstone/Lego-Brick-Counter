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
}
