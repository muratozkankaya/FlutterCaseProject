import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_project/service/api_service.dart';
import 'package:flutter_project/KurumAyrintiSayfa.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Türkiye Cumhuriyeti Kamu Kurumları',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<KurumModel> _tumKurumlar = [];
  List<KurumModel> _filtrelenmisKurumlar = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _internetBaglantisiKontrolu();
    _getKurumlar();
  }

  Future<void> _internetBaglantisiKontrolu() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Internet Bağlantısı Yok'),
            content: Text('Lütfen internet bağlantınızı kontrol edin.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _getKurumlar() async {
    try {
      List<KurumModel> kurumlar = await ApiService().getKurumlar();
      setState(() {
        _tumKurumlar = kurumlar;
        _filtrelenmisKurumlar = kurumlar;
        _isLoading =
            false; 
      });
    } catch (e) {
      print('Kurumlar getirilirken hata oluştu: $e');
      _isLoading = false; 
    }
  }

  void _filtrele(String aramaKelimesi) {
    setState(() {
      _filtrelenmisKurumlar = _tumKurumlar
          .where((kurum) =>
              kurum.title!.toLowerCase().contains(aramaKelimesi.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Türkiye Cumhuriyeti Kamu Kurumları'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Loading Indicator
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filtrele,
                    decoration: InputDecoration(
                      labelText: 'Kurum Ara',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _filtrelenmisKurumlar.isEmpty
                      ? Center(
                          child: Text(
                            'Herhangi bir kurum bulunamadı.',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filtrelenmisKurumlar.length,
                          itemBuilder: (context, index) {
                            KurumModel kurum = _filtrelenmisKurumlar[index];
                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                onTap: () {
                                  _kurumDetaySayfasinaGit(kurum);
                                },
                                title: Text(
                                  kurum.title ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(kurum.adres ?? ''),
                                trailing: Icon(Icons.arrow_forward),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _kurumDetaySayfasinaGit(KurumModel kurum) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        duration: Duration(milliseconds: 500),
        child: KurumAyrintiSayfa(
          kurumAdi: kurum.title ?? '',
          telefon: kurum.tel ?? '',
          adres: kurum.adres ?? '',
          link: kurum.link ?? '',
          email: kurum.email ?? '',
        ),
      ),
    );
  }
}
