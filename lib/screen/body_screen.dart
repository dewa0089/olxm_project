import 'package:flutter/material.dart';

class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  final PageController _pageController = PageController();
  
  int _currentPage = 0;

  final List<String> _imageUrls = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/2023_Lamborghini_Huracan_Tecnica_1.jpg/1200px-2023_Lamborghini_Huracan_Tecnica_1.jpg'
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _autoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _imageUrls.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
        _autoScroll();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _autoScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    // Tambahkan aksi yang diinginkan di sini!
                  },
                  child: Container(
                    width: double
                        .infinity, // Membuat container mengambil lebar penuh
                    height: 40, // Tinggi container
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300, // Warna latar belakang
                      borderRadius:
                          BorderRadius.circular(30), // Sudut melengkung
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
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(_imageUrls[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_imageUrls.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: _currentPage == index ? 20 : 10,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == index ? Colors.orange : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
              Row(
                children: [

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
