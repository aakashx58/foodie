import 'package:flutter/material.dart';
import 'package:flutter_scroll_animation/models/food.dart';
import 'package:flutter_scroll_animation/repository/food_repository.dart';

class FinalView extends StatefulWidget {
  const FinalView({Key? key}) : super(key: key);

  @override
  _FinalViewState createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  /// Categories keys
  final List<GlobalKey> foodCategories = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  /// Scroll Controller
  late ScrollController scrollController;

  /// Tab Context
  BuildContext? tabContext;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(animateToTab);
    super.initState();
  }

  /// Animate To Tab
  void animateToTab() {
    late RenderBox box;

    for (var i = 0; i < foodCategories.length; i++) {
      box = foodCategories[i].currentContext!.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);

      if (scrollController.offset >= position.dy) {
        DefaultTabController.of(tabContext!).animateTo(
          i,
          duration: const Duration(milliseconds: 100),
        );
      }
    }
  }

  /// Scroll to Index
  void scrollToIndex(int index) async {
    scrollController.removeListener(animateToTab);
    final categories = foodCategories[index].currentContext!;
    await Scrollable.ensureVisible(
      categories,
      duration: const Duration(milliseconds: 600),
    );
    scrollController.addListener(animateToTab);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          tabContext = context;
          return Scaffold(
            appBar: _buildAppBar(),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  /// recommended Title - Content
                  _buildCategoryTitle('Recommended', 0),
                  _buildItemList(FoodRepository.Recommended),

                  /// superdeals Title - Content
                  _buildCategoryTitle('Super Deals', 1),
                  _buildItemList(FoodRepository.SuperDeals),

                  /// vegan Title - Content
                  _buildCategoryTitle('Vegan', 2),
                  _buildItemList(FoodRepository.Vegan),

                  /// Empty Bottom space
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Text("Back")],
      ),
      bottom: TabBar(
        tabs: const [
          Tab(child: Text('Reconnended')),
          Tab(child: Text('Super Deals')),
          Tab(child: Text('Vegan')),
        ],
        onTap: (int index) => scrollToIndex(index),
      ),
    );
  }

  /// Item Lists
  Widget _buildItemList(List<FoodModel> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 4.0, // Adjusted vertical spacing
        childAspectRatio: 0.75, // You can adjust this ratio as needed
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildSingleItem(categories[index]);
      },
    );
  }

  /// Single Product item widget
  Widget _buildSingleItem(FoodModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image.network(
            item.image,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '\$${item.price}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            // Text(
            //   '\$${item.price}',
            //   style: const TextStyle(
            //     decoration: TextDecoration.lineThrough,
            //     fontSize: 12,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  /// Category Title
  Widget _buildCategoryTitle(String title, int index) {
    return Padding(
      key: foodCategories[index],
      padding: const EdgeInsets.only(top: 14, right: 12, left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
