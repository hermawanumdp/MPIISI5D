import 'dart:convert';

import 'package:fasumsi6d/screens/full_image.screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.imageBase64,
    required this.description,
    required this.createdAt,
    required this.fullname,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.heroTag,
  });

  final String imageBase64;
  final String description;
  final DateTime createdAt;
  final String fullname;
  final double latitude;
  final double longitude;
  final String category;
  final String heroTag;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<void> openMap() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}',
    );
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final createdAtFormat = DateFormat(
      'dd MMM yyyy HH;mm',
    ).format(widget.createdAt);

    return Scaffold(
      appBar: AppBar(title: Text('Detail Laporan')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.heroTag,
                  child: Image.memory(
                    base64Decode(widget.imageBase64),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FullScreenImageScreen(
                                imageBase64: widget.imageBase64,
                              ),
                        ),
                      );
                    },
                    icon: Icon(Icons.fullscreen, color: Colors.purple),
                    tooltip: 'Lihat Full Screen',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.category,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  createdAtFormat,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: openMap,
                        icon: Icon(
                          Icons.map,
                          size: 38,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
