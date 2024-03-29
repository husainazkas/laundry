import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laundry/storage/storage.dart';
import 'package:laundry/model/home_item_model.dart';
import 'package:laundry/ui/main_page/order_form.dart';
import 'package:laundry/ui/widget/hero_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CarouselController _carouselController = CarouselController();
  final SharedPreferences _storage = locator<SharedPreferences>();
  final _menuItem = [
    HomeItem(
      icon: Icons.local_laundry_service,
      label: 'Cuci dan Setrika',
      routeName: '/order_form',
    ),
    HomeItem(
      icon: Icons.dry_cleaning,
      label: 'Hanya Setrika',
      routeName: '/order_form',
    ),
  ];

  final _ads = [
    'https://d2z8yrol3i8wid.cloudfront.net/wp-content/uploads/2020/06/front-view-pile-laundry_23-2148387001-300x200.jpg',
    'https://cdn1-production-images-kly.akamaized.net/PWQ_iCfc-PXUgf_qL8iotQJpRAI=/673x379/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/3175583/original/092818600_1594346182-row-industrial-laundry-machines-laundromat-public-laundromat-with-laundry-basket-thailand_28914-1091.jpg',
    'https://image-cdn.medkomtek.com/fpRidbB-Vkimhte7spZbulumt_M=/673x379/smart/klikdokter-media-buckets/medias/1511266/original/047999800_1487357530-rumah-sehat_Steam_Laundry_Menurunkan_Risiko_Penyakit_Kulit.jpg',
  ];

  // final _ads = ['assets/3.PNG', 'assets/5.PNG', 'assets/test.png'];

  int _indexAds = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 32.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selamat datang,\n${_storage.getString(keyName)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            Text(
              'Laundry',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: _ads.length,
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1.0,
                      aspectRatio: 4 / 3,
                      autoPlayInterval: Duration(seconds: 6),
                      onPageChanged: (index, reason) {
                        setState(() => _indexAds = index);
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, HeroDialog(
                              builder: (context) {
                                return Hero(
                                  tag: _ads[index].hashCode,
                                  child: Image.network(
                                    _ads[index],
                                    errorBuilder:
                                        (context, exception, stacktrace) {
                                      return Container();
                                    },
                                  ),
                                );
                              },
                            ));
                          },
                          child: Hero(
                            tag: _ads[index].hashCode,
                            child: Image.network(
                              _ads[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, exception, stacktrace) {
                                return Container(
                                  color: Colors.blue[200],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_ads.length, (index) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _indexAds == index
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120.0,
              margin: EdgeInsets.all(32.0),
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: _menuItem.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.all(12.0),
                        shape: CircleBorder(),
                        onPressed: () {
                          index > 1
                              ? Navigator.pushNamed(
                                  context, _menuItem[index].routeName)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderForm(_menuItem[index].label),
                                  ),
                                );
                        },
                        child: Icon(
                          _menuItem[index].icon,
                          size: 40.0,
                          color: Colors.blue[700],
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(_menuItem[index].label),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
