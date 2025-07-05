import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/lease_model.dart';

class LeaseManagementScreen extends StatefulWidget {
  const LeaseManagementScreen({super.key});

  @override
  _LeaseManagementScreenState createState() => _LeaseManagementScreenState();
}

class _LeaseManagementScreenState extends State<LeaseManagementScreen> {
  List<LeaseModel> _leases = [];

  @override
  void initState() {
    super.initState();
    _loadLeases();
  }

  void _loadLeases() {
    // Mock lease data
    _leases = [
      LeaseModel(
        id: '1',
        propertyAddress: '123 Main St, Manhattan, NY',
        tenantName: 'John Doe',
        landlordName: 'Sarah Johnson',
        monthlyRent: 1500,
        securityDeposit: 3000,
        startDate: DateTime.now().subtract(Duration(days: 30)),
        endDate: DateTime.now().add(Duration(days: 335)),
        status: LeaseStatus.active,
        nextPaymentDate: DateTime.now().add(Duration(days: 5)),
      ),
      LeaseModel(
        id: '2',
        propertyAddress: '456 Oak Ave, Brooklyn, NY',
        tenantName: 'Mike Wilson',
        landlordName: 'John Doe',
        monthlyRent: 1200,
        securityDeposit: 2400,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        status: LeaseStatus.pending,
        nextPaymentDate: DateTime.now().add(Duration(days: 10)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lease Management'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _leases.length,
        itemBuilder: (context, index) {
          return _buildLeaseCard(_leases[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/roommate-agreement');
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildLeaseCard(LeaseModel lease) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lease.propertyAddress,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(lease.status),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Tenant: ${lease.tenantName}',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            Text(
              'Landlord: ${lease.landlordName}',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Rent',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '\${lease.monthlyRent}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Next Payment',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      _formatDate(lease.nextPaymentDate),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showLeaseDetails(lease);
                    },
                    child: Text('View Details'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: lease.status == LeaseStatus.active
                        ? () => _makePayment(lease)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: Text('Pay Rent'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(LeaseStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case LeaseStatus.active:
        color = Colors.green;
        text = 'Active';
        break;
      case LeaseStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case LeaseStatus.expired:
        color = Colors.red;
        text = 'Expired';
        break;
      case LeaseStatus.terminated:
        color = Colors.grey;
        text = 'Terminated';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLeaseDetails(LeaseModel lease) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lease Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Property', lease.propertyAddress),
              _buildDetailRow('Tenant', lease.tenantName),
              _buildDetailRow('Landlord', lease.landlordName),
              _buildDetailRow('Monthly Rent', '\${lease.monthlyRent}'),
              _buildDetailRow('Security Deposit', '\${lease.securityDeposit}'),
              _buildDetailRow('Start Date', _formatDate(lease.startDate)),
              _buildDetailRow('End Date', _formatDate(lease.endDate)),
              _buildDetailRow('Status', lease.status.toString().split('.').last),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Download lease document
              _downloadLease(lease);
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _makePayment(LeaseModel lease) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pay Rent'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Amount: \${lease.monthlyRent}'),
            Text('Due Date: ${_formatDate(lease.nextPaymentDate)}'),
            SizedBox(height: 16),
            Text('Select payment method:'),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Credit Card'),
              onTap: () {
                Navigator.pop(context);
                _processPayment(lease, 'Credit Card');
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Bank Transfer'),
              onTap: () {
                Navigator.pop(context);
                _processPayment(lease, 'Bank Transfer');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _processPayment(LeaseModel lease, String method) {
    // Simulate payment processing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment of \${lease.monthlyRent} processed via $method')),
    );
  }

  void _downloadLease(LeaseModel lease) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lease document downloaded')),
    );
  }
}