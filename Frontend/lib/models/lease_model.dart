class LeaseModel {
  final String id;
  final String propertyAddress;
  final String tenantName;
  final String landlordName;
  final double monthlyRent;
  final double securityDeposit;
  final DateTime startDate;
  final DateTime endDate;
  final LeaseStatus status;
  final DateTime nextPaymentDate;

  LeaseModel({
    required this.id,
    required this.propertyAddress,
    required this.tenantName,
    required this.landlordName,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.nextPaymentDate,
  });
}

enum LeaseStatus {
  active,
  pending,
  expired,
  terminated,
}