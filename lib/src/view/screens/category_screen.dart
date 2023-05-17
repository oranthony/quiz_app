import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/factories/factory_method.dart';
import 'package:quiz_app/providers.dart';
import 'package:quiz_app/utils/constants.dart' as Constants;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _GategoryScreenState();
}

class _GategoryScreenState extends State<CategoryScreen> {
  late GameSessionProvider _gameSessionProvider;

  // List of item for the quiz factory. Used to instantiate the right item.
  // Initialized after init in _createCustomQuizList() to be able to pass context
  List<CustomQuiz> _customQuizList = [];

  // Colors used to populate the category items, each line of the matrix correspond
  // to a pair of color to create a gradient
  static const _colorsArray = [
    [Color(0xFFE45BD2), Color(0xFFFF58AD)],
    [Color(0xFFFF6E7F), Color(0xFFFF944D)],
    [Color(0xFF6E8EFF), Color(0xFF02D9FF)],
    [Color(0xFFB0CF12), Color(0xFF30D06E)],
  ];

  @override
  void initState() {
    _gameSessionProvider =
        Provider.of<GameSessionProvider>(context, listen: false);
    // Making sure the build function has been called before updating state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gameSessionProvider.isLoaded = false;
    });
    _createCustomQuizList();
    super.initState();
  }

  // Initializing all items of the factory with the context
  void _createCustomQuizList() {
    _customQuizList = [
      GeneralQuiz(context),
      TechnologyQuiz(context),
      SportQuiz(context),
      HistoryQuiz(context),
      MegaMixGeneralQuiz(context)
    ];
  }

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
        _buildCategoryItem(
            context: context,
            title: "general",
            categoryID: 0,
            colors: _colorsArray[0]),
        _buildCategoryItem(
            context: context,
            title: "technology",
            categoryID: 1,
            colors: _colorsArray[1]),
        _buildCategoryItem(
            context: context,
            title: "sport",
            categoryID: 2,
            colors: _colorsArray[2]),
        _buildCategoryItem(
            context: context,
            title: "History",
            categoryID: 3,
            colors: _colorsArray[3]),
        _buildCategoryItem(
            context: context,
            title: "Mega Mix",
            subTitle: 'Mix of general questions with both easy and hard levels',
            categoryID: 4,
            colors: _colorsArray[0]),
      ],
    );
  }

  void _startGame(int category) {
    _gameSessionProvider.category = category;
    // Instantiate the right item for my factory
    _gameSessionProvider.setCustomQuiz = _customQuizList[category];
    _gameSessionProvider.getCustomQuiz.initializeProvider(context);
    _gameSessionProvider.getCustomQuiz.getQuestions();
    context.go('/before_quiz');
  }

  Container _buildCategoryItem(
      {required BuildContext context,
      required String title,
      String subTitle = "",
      required int categoryID,
      required List<Color> colors}) {
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
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(120.0),
                        side: const BorderSide(color: Colors.white)))),
            onPressed: () => _startGame(categoryID),
            child: subTitle.isEmpty
                ? _buildTextButton(title)
                : _buildTextButtonWithSubTitle(title, subTitle)));
  }

  // Sadly Polymorphism is not fully supported -> no function overloading in dart
  // so I have to make two functions with different names to handle the scenario
  // where there is just the title and the senario where there is both title and
  // subtitle
  Widget _buildTextButton(String title) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 40,
        ),
        child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 26)));
  }

  // Would have loved to use function overloading here
  Widget _buildTextButtonWithSubTitle(String title, String subTitle) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 17,
      ),
      child: Column(
        children: [
          Text(title.toUpperCase(), style: const TextStyle(fontSize: 26)),
          Container(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
              child: Text(
                subTitle,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}
