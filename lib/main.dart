import 'package:flutter/material.dart';

void main(){
  runApp(const MaterialApp(home: ProfilSayfasi()));
}

class ProfilSayfasi extends StatefulWidget{
  const ProfilSayfasi({super.key});

  @override
  State<ProfilSayfasi> createState() {
    return _ProfilSayfasiState();
  }
}


class _ProfilSayfasiState extends State<ProfilSayfasi>{
  int likes = 0;
  bool isLiked = false;

  void _changeLike(){
    setState(() {
      if (isLiked){
        likes--;
        isLiked = false;
      }
      else{
        likes++;
        isLiked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.person, size: 50, color: Colors.white,),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Enes Dağdelen',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Flutter Geliştirici',
                    style: TextStyle(color: Colors.grey)
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.message),
                        label: const Text('Mesaj')
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.person_add), 
                        label: Text('Takip Et')
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _changeLike,
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Beğeni Sayısı: $likes',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    ]
                  )
                ]
              ),
            ),
            
            const SizedBox(width: 32),

            SizedBox(
              width: 350,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.map), 
                    title: const Text('Adres'),
                    subtitle: const Text('Bursa, Türkiye'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: const Text('telefon numarası'),
                    subtitle: const Text('05556667788'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: const Text('E-mail'),
                    subtitle: const Text('deneme@hotmail.com'),
                  )
                ],
              )
            )
          ],
        )
      )
    );
  }
}