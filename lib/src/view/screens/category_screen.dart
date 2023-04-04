import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  // Colors used to populate the category items, each line of the matrix correspond
  // to a pair of color to create a gradient
  static const _colorsArray = [
    [Color(0xFFE45BD2), Color(0xFFFF58AD)],
    [Color(0xFFFF6E7F), Color(0xFFFF944D)],
    [Color(0xFF6E8EFF), Color(0xFF02D9FF)],
    [Color(0xFFB0CF12), Color(0xFF30D06E)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          _buildAppBarr(context),
          Expanded(child: _buildCategoryList(context)),
        ]));
  }

  Container _buildAppBarr(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 80),
        child: SizedBox(
            width: double.infinity,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                const Center(
                  child: Text(
                    "Category",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 32),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ),
              ],
            )));
  }

  ListView _buildCategoryList(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(top: 26),
      shrinkWrap: true,
      children: <Widget>[
        _buildCategoryItem(context, "general", _colorsArray[0]),
        _buildCategoryItem(context, "technology", _colorsArray[1]),
        _buildCategoryItem(context, "sport", _colorsArray[2]),
        _buildCategoryItem(context, "History", _colorsArray[3]),
      ],
    );
  }

  Container _buildCategoryItem(
      BuildContext context, String title, List<Color> colors) {
    return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          //color: Colors.blue,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              colors[0],
              colors[1],
            ],
          ),
          borderRadius: BorderRadius.circular(120),
          image: const DecorationImage(
              image: AssetImage("assets/images/category_bg.png"),
              fit: BoxFit.cover),
          // implement shadow effect
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, // shadow color
                blurRadius: 10, // shadow radius
                offset: Offset(0, 10), // shadow offset
                spreadRadius:
                    1, // The amount the box should be inflated prior to applying the blur
                blurStyle: BlurStyle.normal // set blur style
                ),
          ],
        ),
        child: TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                )),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                //backgroundColor:
                //MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(120.0),
                        side: const BorderSide(color: Colors.white)))),
            onPressed: () => context.go('/category'),
            child: Text(title.toUpperCase(),
                style: const TextStyle(fontSize: 26))));
  }
}
