// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map json) => ReportModel(
  id: json['id'] as String,
  title: json['title'] as String,
  type: $enumDecode(_$ReportTypeEnumMap, json['type']),
  format: $enumDecode(_$ReportFormatEnumMap, json['format']),
  status: $enumDecode(_$ReportStatusEnumMap, json['status']),
  dateRange: json['date_range'] == null
      ? null
      : DateRange.fromJson(
          Map<String, dynamic>.from(json['date_range'] as Map),
        ),
  parameters: Map<String, String>.from(json['parameters'] as Map),
  fileUrl: json['file_url'] as String?,
  fileSize: (json['file_size'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  downloadCount: (json['download_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$ReportTypeEnumMap[instance.type]!,
      'format': _$ReportFormatEnumMap[instance.format]!,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'date_range': instance.dateRange?.toJson(),
      'parameters': instance.parameters,
      'file_url': instance.fileUrl,
      'file_size': instance.fileSize,
      'created_at': instance.createdAt.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'download_count': instance.downloadCount,
    };

const _$ReportTypeEnumMap = {
  ReportType.propertyList: 'PROPERTY_LIST',
  ReportType.taxCollection: 'TAX_COLLECTION',
  ReportType.valuation: 'VALUATION',
  ReportType.ownership: 'OWNERSHIP',
  ReportType.taxDue: 'TAX_DUE',
  ReportType.paymentReceipts: 'PAYMENT_RECEIPTS',
  ReportType.clearanceCertificates: 'CLEARANCE_CERTIFICATES',
  ReportType.wardWise: 'WARD_WISE',
  ReportType.zoneWise: 'ZONE_WISE',
  ReportType.annualSummary: 'ANNUAL_SUMMARY',
};

const _$ReportFormatEnumMap = {
  ReportFormat.pdf: 'PDF',
  ReportFormat.excel: 'EXCEL',
  ReportFormat.csv: 'CSV',
  ReportFormat.word: 'WORD',
};

const _$ReportStatusEnumMap = {
  ReportStatus.pending: 'PENDING',
  ReportStatus.processing: 'PROCESSING',
  ReportStatus.completed: 'COMPLETED',
  ReportStatus.failed: 'FAILED',
};

DateRange _$DateRangeFromJson(Map json) => DateRange(
  startDate: DateTime.parse(json['start_date'] as String),
  endDate: DateTime.parse(json['end_date'] as String),
);

Map<String, dynamic> _$DateRangeToJson(DateRange instance) => <String, dynamic>{
  'start_date': instance.startDate.toIso8601String(),
  'end_date': instance.endDate.toIso8601String(),
};

ReportData _$ReportDataFromJson(Map json) => ReportData(
  totalProperties: (json['total_properties'] as num).toInt(),
  totalTaxCollected: (json['total_tax_collected'] as num).toDouble(),
  totalTaxDue: (json['total_tax_due'] as num).toDouble(),
  wardDistribution: (json['ward_distribution'] as List<dynamic>)
      .map((e) => WardData.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  propertyTypeDistribution: Map<String, int>.from(
    json['property_type_distribution'] as Map,
  ),
  topProperties: (json['top_properties'] as List<dynamic>)
      .map((e) => PropertySummary.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$ReportDataToJson(ReportData instance) =>
    <String, dynamic>{
      'total_properties': instance.totalProperties,
      'total_tax_collected': instance.totalTaxCollected,
      'total_tax_due': instance.totalTaxDue,
      'ward_distribution': instance.wardDistribution
          .map((e) => e.toJson())
          .toList(),
      'property_type_distribution': instance.propertyTypeDistribution,
      'top_properties': instance.topProperties.map((e) => e.toJson()).toList(),
    };

WardData _$WardDataFromJson(Map json) => WardData(
  wardName: json['ward_name'] as String,
  propertyCount: (json['property_count'] as num).toInt(),
  totalValuation: (json['total_valuation'] as num).toDouble(),
  totalTax: (json['total_tax'] as num).toDouble(),
  taxCollected: (json['tax_collected'] as num).toDouble(),
);

Map<String, dynamic> _$WardDataToJson(WardData instance) => <String, dynamic>{
  'ward_name': instance.wardName,
  'property_count': instance.propertyCount,
  'total_valuation': instance.totalValuation,
  'total_tax': instance.totalTax,
  'tax_collected': instance.taxCollected,
};

PropertySummary _$PropertySummaryFromJson(Map json) => PropertySummary(
  propertyId: json['property_id'] as String,
  address: json['address'] as String,
  ward: json['ward'] as String,
  currentValuation: (json['current_valuation'] as num).toDouble(),
  annualTax: (json['annual_tax'] as num).toDouble(),
  taxPaid: (json['tax_paid'] as num).toDouble(),
);

Map<String, dynamic> _$PropertySummaryToJson(PropertySummary instance) =>
    <String, dynamic>{
      'property_id': instance.propertyId,
      'address': instance.address,
      'ward': instance.ward,
      'current_valuation': instance.currentValuation,
      'annual_tax': instance.annualTax,
      'tax_paid': instance.taxPaid,
    };
