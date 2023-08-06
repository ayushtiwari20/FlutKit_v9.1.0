import 'package:flutkit/loading_effect.dart';
import 'package:flutkit/theme/app_theme.dart';
import 'package:flutkit/theme/material_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';

import '../controllers/home_controller.dart';
import '../models/shop.dart';
import 'single_shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeData theme;
  late MaterialThemeData mTheme;

  late HomeController homeController;

  @override
  void initState() {
    super.initState();
    homeController =
        FxControllerStore.putOrFind<HomeController>(HomeController());
    theme = AppTheme.theme;
    mTheme = MaterialTheme.homemadeTheme;
  }

  List<Widget> _buildShopList() {
    List<Widget> list = [];

    for (Shop shop in homeController.shops) {
      list.add(_buildSingleShop(shop));
    }
    return list;
  }

  Widget _buildSingleShop(Shop shop) {
    return FxContainer(
      margin: FxSpacing.bottom(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SingleShopScreen(shop)),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FxContainer(
            paddingAll: 0,
            clipBehavior: Clip.hardEdge,
            child: Image(
              height: 80,
              width: 80,
              fit: BoxFit.fill,
              image: AssetImage(shop.url),
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.b1(
                      shop.name,
                      fontWeight: 600,
                    ),
                    Icon(
                      FeatherIcons.heart,
                      color: mTheme.primary,
                      size: 20,
                    ),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: theme.colorScheme.onBackground.withAlpha(140),
                      size: 16,
                    ),
                    FxSpacing.width(8),
                    Expanded(
                        child: FxText.b3(
                      shop.location,
                      xMuted: true,
                    )),
                  ],
                ),
                FxSpacing.height(6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      color: theme.colorScheme.onBackground.withAlpha(140),
                      size: 16,
                    ),
                    FxSpacing.width(8),
                    Expanded(
                        child: FxText.b3(
                      shop.contact,
                      xMuted: true,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _endDrawer() {
    return SafeArea(
      child: Container(
        margin: FxSpacing.fromLTRB(16, 16, 16, 80),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: mTheme.card,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Drawer(
          child: Container(
            color: mTheme.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: FxSpacing.xy(16, 12),
                  color: mTheme.primary,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: FxText(
                            "Filter",
                            fontWeight: 700,
                            color: mTheme.onPrimary,
                          ),
                        ),
                      ),
                      FxContainer.rounded(
                          onTap: () {
                            homeController.closeEndDrawer();
                          },
                          paddingAll: 6,
                          color: mTheme.onPrimary.withAlpha(80),
                          child: Icon(
                            FeatherIcons.x,
                            size: 12,
                            color: mTheme.onPrimary,
                          ))
                    ],
                  ),
                ),
                Expanded(
                    child: ListView(
                  padding: FxSpacing.all(16),
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxText.b2(
                            "Type",
                            color: theme.colorScheme.onBackground,
                            fontWeight: 600,
                          ),
                          FxText.b3(
                            homeController.selectedChoices.length.toString() +
                                " selected",
                            color: theme.colorScheme.onBackground,
                            fontWeight: 600,
                            xMuted: true,
                          ),
                        ],
                      ),
                    ),
                    FxSpacing.height(16),
                    Container(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _buildType(),
                      ),
                    ),
                    FxSpacing.height(24),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxText.b2(
                            "Price Range",
                            color: theme.colorScheme.onBackground,
                            fontWeight: 600,
                          ),
                          FxText.b3(
                            "\$" +
                                homeController.selectedRange.start
                                    .toInt()
                                    .toString() +
                                " - \$" +
                                homeController.selectedRange.end
                                    .toInt()
                                    .toString(),
                            color: mTheme.secondary,
                            fontWeight: 600,
                            letterSpacing: 0.35,
                          )
                        ],
                      ),
                    ),
                    FxSpacing.height(16),
                    Container(
                      child: RangeSlider(
                          activeColor: mTheme.primary,
                          inactiveColor: mTheme.secondary.withAlpha(100),
                          max: 10000,
                          min: 0,
                          values: homeController.selectedRange,
                          onChanged: (RangeValues newRange) {
                            homeController.onChangePriceRange(newRange);
                          }),
                    ),
                  ],
                )),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: FxContainer(
                        onTap: () {
                          homeController.closeEndDrawer();
                        },
                        padding: FxSpacing.y(12),
                        child: Center(
                          child: FxText(
                            "Clear",
                            color: mTheme.secondary,
                            fontWeight: 600,
                          ),
                        ),
                      )),
                      Expanded(
                          child: FxContainer.none(
                        onTap: () {
                          homeController.closeEndDrawer();
                        },
                        padding: FxSpacing.y(12),
                        child: Center(
                          child: FxText(
                            "Apply",
                            color: mTheme.onPrimary,
                            fontWeight: 600,
                          ),
                        ),
                        color: mTheme.primary,
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildType() {
    List<String> categoryList = [
      "ECom",
      "Automobile",
      "Crimes",
      "Business",
      "Fitness",
      "Astro",
      "Politics",
      "Relationship",
      "Food",
      "Electronics",
      "Health",
      "Tech",
      "Entertainment",
      "World",
      "Sports",
      "Other",
    ];

    List<Widget> choices = [];
    categoryList.forEach((item) {
      bool selected = homeController.selectedChoices.contains(item);
      if (selected) {
        choices.add(FxContainer.none(
            color: mTheme.primary.withAlpha(28),
            bordered: true,
            borderRadiusAll: 12,
            paddingAll: 8,
            border: Border.all(color: mTheme.primary),
            onTap: () {
              homeController.removeChoice(item);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check,
                  size: 14,
                  color: mTheme.primary,
                ),
                FxSpacing.width(6),
                FxText.b3(
                  item,
                  fontSize: 11,
                  color: mTheme.primary,
                )
              ],
            )));
      } else {
        choices.add(FxContainer.none(
          // color: mTheme.border,
          borderRadiusAll: 12,
          padding: FxSpacing.xy(12, 8),
          onTap: () {
            homeController.addChoice(item);
          },
          child: FxText.l3(
            item,
            color: theme.colorScheme.onBackground,
            fontSize: 11,
          ),
        ));
      }
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<HomeController>(
        controller: homeController,
        builder: (homeController) {
          return _buildBody();
        });
  }

  Widget _buildBody() {
    if (homeController.uiLoading) {
      return Scaffold(
          backgroundColor: mTheme.card,
          body: Container(
              margin: FxSpacing.top(FxSpacing.safeAreaTop(context) + 20),
              child: LoadingEffect.getSearchLoadingScreen(
                context,
                theme,
                mTheme,
              )));
    } else {
      return Scaffold(
        key: homeController.scaffoldKey,
        endDrawer: _endDrawer(),
        resizeToAvoidBottomInset: false,
        body: ListView(
          padding: FxSpacing.fromLTRB(24, 44, 24, 64),
          children: [
            Row(
              children: [
                FxContainer.bordered(
                    onTap: () {
                      homeController.openLocationDialog();
                    },
                    splashColor: mTheme.secondary,
                    borderRadiusAll: 8,
                    paddingAll: 13,
                    color: mTheme.secondary.withAlpha(28),
                    border: Border.all(color: mTheme.secondary.withAlpha(120)),
                    child: Icon(
                      FeatherIcons.mapPin,
                      color: mTheme.secondary,
                      size: 18,
                    )),
                FxSpacing.width(16),
                Expanded(
                    child: TextFormField(
                  controller: homeController.searchEditingController,
                  style: FxTextStyle.b2(color: mTheme.onPrimaryContainer),
                  cursorColor: mTheme.secondary,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: FxTextStyle.b2(color: mTheme.onPrimaryContainer),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: mTheme.primaryContainer,
                    prefixIcon: Icon(
                      FeatherIcons.search,
                      size: 20,
                      color: mTheme.onPrimaryContainer,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.only(right: 16),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                )),
                FxSpacing.width(16),
                FxContainer.bordered(
                    onTap: () {
                      homeController.openEndDrawer();
                    },
                    color: mTheme.secondary.withAlpha(28),
                    border: Border.all(color: mTheme.secondary.withAlpha(120)),
                    borderRadiusAll: 8,
                    paddingAll: 13,
                    child: Icon(
                      FeatherIcons.sliders,
                      color: mTheme.secondary,
                      size: 18,
                    )),
              ],
            ),
            FxSpacing.height(16),
            Column(
              children: _buildShopList(),
            ),
          ],
        ),
      );
    }
  }
}
