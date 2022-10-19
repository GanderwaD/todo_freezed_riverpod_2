import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
 * ---------------------------
 * File : image_response.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


class ImageResponse {
  List<String>? message;
  String? status;
  ImageResponse({
    this.message,
    this.status,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
    };
  }

  factory ImageResponse.fromMap(Map<String, dynamic> map) {
    return ImageResponse(
      message: map['message'] != null ? List<String>.from((map['message'] )) : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageResponse.fromJson(String source) => ImageResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
