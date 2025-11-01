import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/globals/constants/assets.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/globals.dart';
import 'package:hackathon/globals/constants/styles.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/features/landing/appbar_landing.dart';
import 'package:hackathon/features/landing/footer_landing.dart';
import 'package:hackathon/features/landing/widgets/banner_base.dart';
import 'package:hackathon/widgets/auth_button.dart';
import 'package:hackathon/widgets/customer_widget.dart';
import 'package:hackathon/widgets/intro_widgets.dart';
import 'package:hackathon/widgets/nav_arrow_button.dart';

class LandingPage extends StatefulWidget {
  static const routePath = '/landing-page';
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late PageController headingPageController;
  late PageController middlePageController;

  late Timer _timerHeading;
  late Timer _timerMiddle;

  int _headingCurrentIndex = 0;
  int _middleCurrentIndex = 0;
  List<String> footerItems = [
    'About Us',
    'Privacy Policy',
    'Terms of Service',
    'Contact Us',
    'Help & Support',
    'Careers',
    'FAQ',
    'Press & Media',
    'Investor Relations',
    'Blog',
    'Sitemap',
    'Community Guidelines',
    'Social Media',
    'Advertise with Us',
    'Subscribe to Newsletter',
    'Feedback',
    'Legal Information',
    'Affiliate Program',
    'Accessibility',
    'Cookie Policy'
  ];

  List<Widget> listBannermiddle = const [
    BannerBase(
      rotation: 10,
      text:
          "WhatsApp \n in anim dolore do laboris deserunt fugiat reprehenderit eu non. Aliqua id esse nostrud nostrud pariatur fugiat ut voluptate. Laboris commodo ipsum ea laborum laborum. Cillum tempor aliqua sunt cupidatat eiusmod deserunt. Anim exercitation aliqua deserunt sunt.",
      image: ImageAssets.whatsapp,
      size: 30,
      imageScale: 1.5,
    ),
    BannerBase(
      rotation: 10,
      text:
          "Discord \n in anim dolore do laboris deserunt fugiat reprehenderit eu non. Aliqua id esse nostrud nostrud pariatur fugiat ut voluptate. Laboris commodo ipsum ea laborum laborum. Cillum tempor aliqua sunt cupidatat eiusmod deserunt. Anim exercitation aliqua deserunt sunt.",
      image: ImageAssets.discord,
      size: 30,
      imageScale: 1.5,
    ),
    BannerBase(
      rotation: 10,
      text:
          "Jira \n in anim dolore do laboris deserunt fugiat reprehenderit eu non. Aliqua id esse nostrud nostrud pariatur fugiat ut voluptate. Laboris commodo ipsum ea laborum laborum. Cillum tempor aliqua sunt cupidatat eiusmod deserunt. Anim exercitation aliqua deserunt sunt.",
      image: ImageAssets.jira,
      size: 30,
      imageScale: 1.5,
    ),
    BannerBase(
      rotation: 10,
      text:
          "Slack \n in anim dolore do laboris deserunt fugiat reprehenderit eu non. Aliqua id esse nostrud nostrud pariatur fugiat ut voluptate. Laboris commodo ipsum ea laborum laborum. Cillum tempor aliqua sunt cupidatat eiusmod deserunt. Anim exercitation aliqua deserunt sunt.",
      image: ImageAssets.slack,
      size: 30,
      imageScale: 1.5,
    ),
  ];
  List<Widget> listBannerHeading = const [
    BannerBase(
      text: "Interactive and pleasing Dashboard.",
      image: ImageAssets.dashboard,
    ),
    BannerBase(
      text: "Neat And Clean Chat UIs.",
      image: ImageAssets.chatUI,
    ),
    BannerBase(
      text: "Easily Connect With Your Team.",
      image: ImageAssets.meeting,
    ),
  ];

  @override
  void initState() {
    super.initState();
    headingPageController = PageController();
    middlePageController = PageController();
    _headingAutoScroll();
    _middleAutoScroll();
  }

  @override
  void dispose() {
    _timerHeading.cancel();
    _timerMiddle.cancel();
    headingPageController.dispose();
    middlePageController.dispose();
    super.dispose();
  }

  void _headingAutoScroll() {
    _timerHeading = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_headingCurrentIndex < listBannerHeading.length - 1) {
        _headingCurrentIndex++;
      } else {
        _headingCurrentIndex = 0;
      }
      headingPageController.animateToPage(
        _headingCurrentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _middleAutoScroll() {
    _timerMiddle = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_middleCurrentIndex < listBannermiddle.length - 1) {
        _middleCurrentIndex++;
      } else {
        _middleCurrentIndex = 0;
      }
      middlePageController.animateToPage(
        _middleCurrentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final sheight = MediaQuery.of(context).size.height;
    final swidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: ColorPallete.background,
            transform: GradientRotation(1),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                child: LandingAppBar(swidth: swidth),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 350,
                child: Row(
                  children: [
                    NavArrowButton(
                      text: "<",
                      onpressed: () {
                        if (headingPageController.page == 0) {
                          headingPageController.animateToPage(
                              listBannerHeading.length - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        } else {
                          headingPageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                      color: ColorPallete.blackPrimary,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: headingPageController,
                        itemBuilder: (context, index) =>
                            listBannerHeading[index],
                        itemCount: listBannerHeading.length,
                      ),
                    ),
                    NavArrowButton(
                      text: ">",
                      onpressed: () {
                        if (headingPageController.page ==
                            listBannerHeading.length - 1) {
                          headingPageController.animateToPage(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        } else {
                          headingPageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                      color: ColorPallete.blackPrimary,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: informationTab(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: SelectableText(
                  "INSPIRED BY:",
                  style: textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: middlePageController,
                  itemBuilder: (context, index) => listBannermiddle[index],
                  itemCount: listBannermiddle.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: Text(
                  "OUR CUSTOMERS:",
                  style: textTheme.headlineMedium,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomerWidget(),
                    CustomerWidget(),
                    CustomerWidget(),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 80,
                  child: AuthButton(
                    text: "Let's Get Started",
                    onpressed: () {
                      context.go(Dashboard.routePath);
                    },
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 45, 45, 45),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FooterWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row informationTab() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IntroWidgets(
          onTap: () {
            showWorkInProgress(context);
          },
          text:
              "SAMPNet - Start-up Advancement and Management Platform Network",
        ),
        IntroWidgets(
          onTap: () {
            showWorkInProgress(context);
          },
          text:
              "SAMPNet - Start-up Advancement and Management Platform Network",
        ),
        IntroWidgets(
          onTap: () {
            showWorkInProgress(context);
          },
          text:
              "SAMPNet - Start-up Advancement and Management Platform Network",
        ),
      ],
    );
  }

  void showWorkInProgress(BuildContext context) {}
}
