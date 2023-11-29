import 'dart:convert';
import 'package:http/http.dart' as http;

class KurumModel {
  String? code;
  String? title;
  String? link;
  String? tel;
  String? email;
  String? adres;

  KurumModel({
    this.code,
    this.title,
    this.link,
    this.tel,
    this.email,
    this.adres,
  });

  factory KurumModel.fromJson(Map<String, dynamic> json) {
    return KurumModel(
      code: json['code']?.toString(),
      title: json['title']?.toString(),
      link: json['link']?.toString(),
      tel: json['tel']?.toString(),
      email: json['email']?.toString(),
      adres: json['adres']?.toString(),
    );
  }
}

class ApiService {
  static const String apiUrl =
      'https://gist.githubusercontent.com/berkanaslan/35511991222bfc0914cd4c2c031057e2/raw/9ed856f43fc499be9f88c3b01608bce9b667eff6/kurumlar.json';

  Future<List<KurumModel>> getKurumlar() async {
    try {
      
      final response = await http.get(Uri.parse(apiUrl));

      
      if (response.statusCode == 200) {
        
        final List<dynamic> data = json.decode(response.body);

        
        List<KurumModel> kurumlar =
            data.map((item) => KurumModel.fromJson(item)).toList();

        return kurumlar;
      } else {
        
        throw Exception('API isteği başarısız oldu: ${response.statusCode}');
      }
    } catch (e) {
      
      throw Exception('Hata: $e');
    }
  }
}
