import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/taxation/data/models/tax_model.dart';

part 'report_model.g.dart';

@HiveType(typeId: 5)
@JsonSerializable()
class ReportModel {
  @HiveField(0)
  @JsonKey(name: 'id')
  final String id;

  @HiveField(1)
  @JsonKey(name: 'title')
  final String title;

  @HiveField(2)
  @JsonKey(name: 'type')
  final ReportType type;

  @HiveField(3)
  @JsonKey(name: 'format')
  final ReportFormat format;

  @HiveField(4)
  @JsonKey(name: 'status')
  final ReportStatus status;

  @HiveField(5)
  @JsonKey(name: 'date_range')
  final DateRange? dateRange;

  @HiveField(6)
  @JsonKey(name: 'parameters')
  final Map<String, dynamic> parameters;

  @HiveField(7)
  @JsonKey(name: 'file_url')
  final String? fileUrl;

  @HiveField(8)
  @JsonKey(name: 'file_size')
  final int? fileSize;

  @HiveField(9)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @HiveField(10)
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @HiveField(11)
  @JsonKey(name: 'download_count')
  final int downloadCount;

  ReportModel({
    required this.id,
    required this.title,
    required this.type,
    required this.format,
    required this.status,
    this.dateRange,
    required this.parameters,
    this.fileUrl,
    this.fileSize,
    required this.createdAt,
    this.completedAt,
    this.downloadCount = 0,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);

  String get fileSizeFormatted {
    if (fileSize == null) return 'Unknown';
    if (fileSize! < 1024) return '${fileSize} B';
    if (fileSize! < 1024 * 1024)
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get isCompleted => status == ReportStatus.completed;
  bool get isFailed => status == ReportStatus.failed;
  bool get isPending => status == ReportStatus.pending;
  bool get isProcessing => status == ReportStatus.processing;
}

@HiveType(typeId: 6)
@JsonSerializable()
class DateRange {
  @HiveField(0)
  @JsonKey(name: 'start_date')
  final DateTime startDate;

  @HiveField(1)
  @JsonKey(name: 'end_date')
  final DateTime endDate;

  DateRange({required this.startDate, required this.endDate});

  factory DateRange.fromJson(Map<String, dynamic> json) =>
      _$DateRangeFromJson(json);

  Map<String, dynamic> toJson() => _$DateRangeToJson(this);

  String get formattedRange =>
      '${_formatDate(startDate)} - ${_formatDate(endDate)}';

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

@HiveType(typeId: 7)
enum ReportType {
  @HiveField(0)
  @JsonValue('PROPERTY_LIST')
  propertyList,

  @HiveField(1)
  @JsonValue('TAX_COLLECTION')
  taxCollection,

  @HiveField(2)
  @JsonValue('VALUATION')
  valuation,

  @HiveField(3)
  @JsonValue('OWNERSHIP')
  ownership,

  @HiveField(4)
  @JsonValue('TAX_DUE')
  taxDue,

  @HiveField(5)
  @JsonValue('PAYMENT_RECEIPTS')
  paymentReceipts,

  @HiveField(6)
  @JsonValue('CLEARANCE_CERTIFICATES')
  clearanceCertificates,

  @HiveField(7)
  @JsonValue('WARD_WISE')
  wardWise,

  @HiveField(8)
  @JsonValue('ZONE_WISE')
  zoneWise,

  @HiveField(9)
  @JsonValue('ANNUAL_SUMMARY')
  annualSummary,
}

@HiveType(typeId: 8)
enum ReportFormat {
  @HiveField(0)
  @JsonValue('PDF')
  pdf,

  @HiveField(1)
  @JsonValue('EXCEL')
  excel,

  @HiveField(2)
  @JsonValue('CSV')
  csv,

  @HiveField(3)
  @JsonValue('WORD')
  word,
}

@HiveType(typeId: 9)
enum ReportStatus {
  @HiveField(0)
  @JsonValue('PENDING')
  pending,

  @HiveField(1)
  @JsonValue('PROCESSING')
  processing,

  @HiveField(2)
  @JsonValue('COMPLETED')
  completed,

  @HiveField(3)
  @JsonValue('FAILED')
  failed,
}

@HiveType(typeId: 10)
@JsonSerializable()
class ReportData {
  @HiveField(0)
  @JsonKey(name: 'total_properties')
  final int totalProperties;

  @HiveField(1)
  @JsonKey(name: 'total_tax_collected')
  final double totalTaxCollected;

  @HiveField(2)
  @JsonKey(name: 'total_tax_due')
  final double totalTaxDue;

  @HiveField(3)
  @JsonKey(name: 'ward_distribution')
  final Map<String, WardData> wardDistribution;

  @HiveField(4)
  @JsonKey(name: 'property_type_distribution')
  final Map<String, int> propertyTypeDistribution;

  @HiveField(5)
  @JsonKey(name: 'top_properties')
  final List<PropertySummary> topProperties;

  ReportData({
    required this.totalProperties,
    required this.totalTaxCollected,
    required this.totalTaxDue,
    required this.wardDistribution,
    required this.propertyTypeDistribution,
    required this.topProperties,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDataToJson(this);
}

@HiveType(typeId: 11)
@JsonSerializable()
class WardData {
  @HiveField(0)
  @JsonKey(name: 'ward_name')
  final String wardName;

  @HiveField(1)
  @JsonKey(name: 'property_count')
  final int propertyCount;

  @HiveField(2)
  @JsonKey(name: 'total_valuation')
  final double totalValuation;

  @HiveField(3)
  @JsonKey(name: 'total_tax')
  final double totalTax;

  @HiveField(4)
  @JsonKey(name: 'tax_collected')
  final double taxCollected;

  WardData({
    required this.wardName,
    required this.propertyCount,
    required this.totalValuation,
    required this.totalTax,
    required this.taxCollected,
  });

  factory WardData.fromJson(Map<String, dynamic> json) =>
      _$WardDataFromJson(json);

  Map<String, dynamic> toJson() => _$WardDataToJson(this);
}

@HiveType(typeId: 12)
@JsonSerializable()
class PropertySummary {
  @HiveField(0)
  @JsonKey(name: 'property_id')
  final String propertyId;

  @HiveField(1)
  @JsonKey(name: 'address')
  final String address;

  @HiveField(2)
  @JsonKey(name: 'ward')
  final String ward;

  @HiveField(3)
  @JsonKey(name: 'current_valuation')
  final double currentValuation;

  @HiveField(4)
  @JsonKey(name: 'annual_tax')
  final double annualTax;

  @HiveField(5)
  @JsonKey(name: 'tax_paid')
  final double taxPaid;

  PropertySummary({
    required this.propertyId,
    required this.address,
    required this.ward,
    required this.currentValuation,
    required this.annualTax,
    required this.taxPaid,
  });

  factory PropertySummary.fromJson(Map<String, dynamic> json) =>
      _$PropertySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$PropertySummaryToJson(this);
}
