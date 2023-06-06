// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ShoppingItem {
  final String name;
  bool done;
  final String id;

  ShoppingItem({
    required this.name,
    required this.done,
    required this.id,
  });

  void setDone(newValue) {
    this.done = newValue;
  }

  ShoppingItem copyWith({
    String? name,
    bool? done,
    String? id,
  }) {
    return ShoppingItem(
      name: name ?? this.name,
      done: done ?? this.done,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'done': done,
      'id': id,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      name: map['name'] as String,
      done: map['done'] as bool,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingItem.fromJson(String source) =>
      ShoppingItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ShoppingItem(name: $name, done: $done, id: $id)';

  @override
  bool operator ==(covariant ShoppingItem other) {
    if (identical(this, other)) return true;

    return other.name == name && other.done == done && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ done.hashCode ^ id.hashCode;
}
