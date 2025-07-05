import 'package:flutter/material.dart';

class AROverlay extends StatelessWidget {
  final bool isScanning;
  final double scanProgress;
  final Map<String, dynamic> roomData;

  const AROverlay({
    super.key,
    required this.isScanning,
    required this.scanProgress,
    required this.roomData,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isScanning ? 'Scanning Room...' : roomData.isNotEmpty ? 'Scan Results' : 'Ready to Scan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            if (isScanning)
              LinearProgressIndicator(
                value: scanProgress,
                backgroundColor: Colors.grey[700],
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
              ),
            if (roomData.isNotEmpty) ...[
              ...roomData.entries.map((entry) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          entry.value.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}