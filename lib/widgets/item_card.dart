import 'package:flutter/material.dart';
import 'package:olxm_project/model/data.dart';

class ItemCard extends StatefulWidget {
  // TODO: 1. Deklarasi variabel yang dibutuhkan dan dipasang pada konstruktor
  // const ItemCard({super.key, required this.shoes});
  // final Shoes shoes;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // _ItemCardState({required this.shoes});
  // final Shoes shoes;
  bool isFavorite = false;
  bool isSignIn = false; // Menyimpan status sign in
  int? _isSelectedSize;
  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
    // _loadFavoriteStatus();
  }

//Memeriksa status sign in
  void _checkSignInStatus() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool signedIn = prefs.getBool('isSignedIn') ?? false;
    // setState(() {
    //   isSignIn = signedIn;
    // });
  }

  // Memeriksa status favorite
  // void _loadFavoriteStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool favorite = prefs.getBool('favorite_${widget.shoes.id}') ?? false;
  //   setState(() {
  //     isFavorite = favorite;
  //   });
  // }

  // Future<void> _toggleFavorite() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   if (!isSignIn) {
  //     //jika belum sign in, diarahkan ke Sign In Screen
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       Navigator.pushReplacementNamed(context, '/signin');
  //     });
  //     return;
  //   }

  //   bool favoriteStatus = !isFavorite;
  //   prefs.setBool('favorite_${widget.shoes.id}', favoriteStatus);
  //   // Tambahkan pemanggilan untuk memperbarui tampilan Favorit
  //   _loadFavoriteStatus();

  //   setState(() {
  //     isFavorite = favoriteStatus;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => DetailScreen(shoes: widget.shoes)));
      },
      child: Card(
        // TODO: 2. Tetapkan parameter shape, margin, dan elevation
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(12),
        color: Colors.blue,
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: 3. Buat Images sebagai anak dari Column
            Expanded(
              child: Hero(
                // tag: 'item_card_${widget.shoes.id}_${widget.shoes.model}',
                tag: categories,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RotationTransition(
                        turns: AlwaysStoppedAnimation(-20 / 360),
                        child: Container(
                            width: 100, height: 170, child: Image.asset(
                                // widget.shoes.imageAsset,
                                'assets/image/benner1.jfif'))),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40, right: 8),
                      child: IconButton(
                          onPressed: () {
                            // _toggleFavorite();
                          },
                          icon: Icon(
                            isSignIn && isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isSignIn && isFavorite ? Colors.red : null,
                            size: 30,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            //TODO: 4. Buat Text sebagai anak dari column
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                // widget.shoes.name,
                'Nama',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            //TODO: 5. Buat Text sebagai anak dari column
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                // "\$${widget.shoes.price.toStringAsFixed(2)}",
                'Harga',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
