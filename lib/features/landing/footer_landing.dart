import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class FooterWidget extends StatelessWidget {
  final List<String> footerItems = [
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

  FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: ColorPallete.textSecondary,
          borderRadius:
              BorderRadius.circular(10)), // Background color for footer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Disable scrolling within GridView
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 4, // Adjust height to make it more tabular
            ),
            itemCount: footerItems.length,
            itemBuilder: (context, index) {
              return Text(
                footerItems[index],
                style: const TextStyle(
                  color: ColorPallete.textPrimary,
                  fontSize: 14,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
