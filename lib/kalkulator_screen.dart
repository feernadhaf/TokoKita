import 'package:flutter/material.dart';

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});

  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  final TextEditingController angkaPertamaController = TextEditingController();
  final TextEditingController angkaKeduaController = TextEditingController();

  String hasilPerhitungan = '';


    void Hasil (String operasi) {
      double angka1 = double.parse(angkaPertamaController.text);
      double angka2 = double.parse(angkaKeduaController.text);

      double HasilOprasi = 0;

      //hitung bedasarkan oprasi
      // if (operasi == '+') {
      //   setState(() {
      //     hasilPerhitungan = (angka1 + angka2).toString();
      //   });
        
      // }
      // if (operasi == '-') {
      //   setState(() {
      //     hasilPerhitungan = (angka1 - angka2).toString();
      //   });
        
      // }
      // if (operasi == '*') {
      //   setState(() {
      //     hasilPerhitungan = (angka1 * angka2).toString();
      //   });
        
      // }
      // if (operasi == '/') {
      //   setState(() {
      //     hasilPerhitungan = (angka1 / angka2).toString();
      //   });
        
      // }
      switch (operasi) {
        case '+':
          setState(() {
            hasilPerhitungan = (angka1 + angka2).toString();
          });
          break;
        case '-':
          setState(() {
            hasilPerhitungan = (angka1 - angka2).toString();
          });
          break;
        case '*':
          setState(() {
            hasilPerhitungan = (angka1 * angka2).toString();
          });
          break;
        case '/':
          setState(() {
            hasilPerhitungan = (angka1 / angka2).toString();
          });
          break;
        default:
          setState(() {
            hasilPerhitungan = 'Operasi tidak valid';
          });
      }


    }



    
  @override
  void dispose() {
    angkaPertamaController.dispose();
    angkaKeduaController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator')
      ),
      body: Column(children: [
        TextField(
          controller: angkaPertamaController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Masukkan angka pertama', 
          border: OutlineInputBorder()
          ),),
        SizedBox(height: 10),
        TextField(
          controller: angkaKeduaController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Masukkan angka kedua', 
          border: OutlineInputBorder())),
        Row(
          children: [
            ElevatedButton(onPressed: () => Hasil('+') ,child: const Text('+')),
            ElevatedButton(onPressed: () => Hasil('-') ,child: const Text('-')),
            ElevatedButton(onPressed: () => Hasil('*') ,child: const Text('*')),
            ElevatedButton(onPressed: () => Hasil('/') ,child: const Text('/')),
          ],
        ),
        SizedBox(height: 10),
        Text('Hasil: '),
        SizedBox(height: 10),
        Text(hasilPerhitungan,),
      ]),
    );
  }


}