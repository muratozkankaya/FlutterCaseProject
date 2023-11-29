import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KurumAyrintiSayfa extends StatelessWidget {
  final String kurumAdi;
  final String telefon;
  final String adres;
  final String link;
  final String email;

  KurumAyrintiSayfa({
    required this.kurumAdi,
    required this.telefon,
    required this.adres,
    required this.link,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kurumAdi),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kurum Adı:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  kurumAdi,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Telefon:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  telefon,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _navigateToAddressOnMaps(adres);
                  },
                  child: Text(
                    'Adres: $adres',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _acLink(link);
                  },
                  child: Text(
                    'Link: $link',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'E-Mail: ${email.isNotEmpty ? email : "Kurum e-mail adresini paylaşmamıştır."}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _aramaYap(context, telefon);
                  },
                  child: Text('Ara'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _aramaYap(BuildContext context, String telefonNumarasi) async {
    final telefonURL = 'tel:$telefonNumarasi';

    if (await canLaunch(telefonURL)) {
      await launch(telefonURL);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Arama işlemi başlatılamıyor: $telefonNumarasi'),
        ),
      );
    }
  }

  void _acLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      print('Linki açarken bir hata oluştu: $link');
    }
  }

  Future<void> _navigateToAddressOnMaps(String address) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeFull(address)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Harita uygulaması açılamıyor: $url');
    }
  }
}
