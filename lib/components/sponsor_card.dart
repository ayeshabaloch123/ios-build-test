import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorCard extends StatelessWidget {
  final String name;
  final String level;
  final String imageUrl;
  final List<String> socialLinks;

  const SponsorCard({
    super.key,
    required this.name,
    required this.level,
    required this.imageUrl,
    required this.socialLinks,
  });

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  imageUrl,
                  height: 80,
                  width: 160,
                  fit: BoxFit.contain,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 78, 90, 254),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    level,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: socialLinks.map((link) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      String url;
                      if (link == 'linkedin') {
                        url =
                            'https://www.linkedin.com/company/${name.replaceAll(' ', '').toLowerCase()}';
                      } else if (link == 'instagram') {
                        url =
                            'https://www.instagram.com/${name.replaceAll(' ', '').toLowerCase()}';
                      } else if (link == 'profile') {
                        url =
                            'https://www.example.com/profile/${name.replaceAll(' ', '').toLowerCase()}';
                      } else {
                        url = 'https://www.example.com';
                      }
                      _launchUrl(url);
                    },
                    child: _getSocialImage(link),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSocialImage(String platform) {
    String assetPath;
    switch (platform) {
      case "linkedin":
        assetPath = "assests/icon1.png";
        break;
      case "instagram":
        assetPath = "assests/icon2.png";
        break;
      case "profile":
      default:
        assetPath = "assests/icon3.png";
        break;
    }
    return Image.asset(
      assetPath,
      height: 24,
      width: 24,
    );
  }
}
