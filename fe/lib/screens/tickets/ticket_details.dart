import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wall_et_ui/common/models.dart';
import 'package:wall_et_ui/common/utility.dart';

class TicketDetails extends StatelessWidget {
  final Ticket ticket;

  const TicketDetails({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ticket.eventName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: PhotoViewGallery(
                pageOptions: [
                  PhotoViewGalleryPageOptions(
                    imageProvider:
                        NetworkImage("${Utility.baseUrl}${ticket.ticketInfo}"),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  ),
                ],
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                scrollPhysics: const BouncingScrollPhysics(),
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBox('Event Name', ticket.eventName),
                  _buildInfoBox(
                      'Event Date', ticket.eventDate.toIso8601String()),
                  _buildInfoBox(
                      'Purchase Date', ticket.purchaseDate.toIso8601String()),
                  _buildInfoBox(
                      'Valid From', ticket.validFrom.toIso8601String()),
                  _buildInfoBox('Valid To', ticket.validTo.toIso8601String()),
                  _buildInfoBox('Status', ticket.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String heading, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), 
                ),
              ],
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
