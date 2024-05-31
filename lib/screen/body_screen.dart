import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olxm_project/model/data.dart';
import 'package:olxm_project/screen/search_screen.dart';
import 'package:olxm_project/widgets/item_card.dart';

List<IconData> categoryIcons = [
  Icons.smartphone,
  Icons.laptop,
  Icons.tablet,
  Icons.tv,
  Icons.games_outlined
  // tambahkan ikon lain sesuai jumlah kategori
];

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String selectedCategory = 'All'; // Default category is 'All'
  int selectedIndexOfCategory = 0;
  int selectedIndexOfFeatured = 1;
  PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Timer untuk auto slide
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      int nextPage = _pageController.page!.round() + 1;
      if (nextPage == 3) {
        nextPage = 0;
      }
      _pageController.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            topSearchWidget(width, height),
            bannerWidget(width, height),
            topCategoriesWidget(width, height),
            const SizedBox(height: 10),
            const SizedBox(height: 5),
            moreTextWidget(),
            lastCategoriesWidget(width, height),
          ],
        ),
      ),
    );
  }

  Widget bannerWidget(double width, double height) {
    return Container(
      width: width,
      height: height / 4, // Sesuaikan tinggi sesuai kebutuhan
      child: PageView(
        controller: _pageController,
        children: [
          bannerItem(width, height, 'assets/image/benner1.jfif'),
          bannerItem(width, height, 'assets/image/benner2.png'),
          bannerItem(width, height, 'assets/image/benner3.jfif'),
        ],
      ),
    );
  }

  // Widget untuk setiap item Banner
  Widget bannerItem(double width, double height, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: width,
        height: height / 4, // Sesuaikan tinggi sesuai kebutuhan
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.orange,
          image: DecorationImage(
            image: AssetImage(imagePath), // Path ke gambar banner Anda
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

// Top Categories Widget Components
  topCategoriesWidget(width, height) {
    return Column(
      children: [
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Categori',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: width,
              height: height / 10,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = 'All';
                          selectedIndexOfCategory = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selectedIndexOfCategory == 0
                                  ? Colors.black
                                  : Colors.white,
                              width: 1.5,
                            ),
                            color: selectedIndexOfCategory == 0
                                ? Colors.black
                                : Colors.white,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.category, // Ikon untuk 'All'
                                color: selectedIndexOfCategory == 0
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'All',
                                style: TextStyle(
                                  fontSize:
                                      selectedIndexOfCategory == 0 ? 21 : 18,
                                  color: selectedIndexOfCategory == 0
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  final category = categories[index - 1];
                  final icon = categoryIcons[index - 1];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        selectedIndexOfCategory = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedIndexOfCategory == index
                                ? Colors.black
                                : Colors.white,
                            width: 1.5,
                          ),
                          color: selectedIndexOfCategory == index
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              icon,
                              color: selectedIndexOfCategory == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            SizedBox(width: 5),
                            Text(
                              category,
                              style: TextStyle(
                                fontSize:
                                    selectedIndexOfCategory == index ? 21 : 18,
                                color: selectedIndexOfCategory == index
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: selectedIndexOfCategory == index
                                    ? FontWeight.normal
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  topSearchWidget(width, height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 14),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
            },
            child: Container(
              width: double.infinity, // Membuat container mengambil lebar penuh
              height: 40, // Tinggi container
              decoration: BoxDecoration(
                color: Colors.grey.shade300, // Warna latar belakang
                borderRadius: BorderRadius.circular(30), // Sudut melengkung
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.orange, // Warna ikon
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 7, top: 7),
          child: Text(
            "Sell Or Buy Products",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 7, top: 1),
          child: Text(
            "Now",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

// More Text Widget Components
  moreTextWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text("Product On Sell",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
          Expanded(child: Container()),
          const Icon(
            Icons.arrow_downward,
            size: 35,
          )
        ],
      ),
    );
  }

// Last Categories Widget Components
  lastCategoriesWidget(width, height) {
    return Container(
      width: width,
      height: height / 3,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          padding: const EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          // itemCount: shoesList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, index) {
            // Shoes shoes = shoesList[index];
            return ItemCard();
          }),
    );
  }
}
