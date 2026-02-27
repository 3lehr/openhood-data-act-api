/// Model fuer eine EU Data Act Art. 4 Datenanfrage.
///
/// Speichert alle Daten die fuer das Anfrage-Schreiben benoetigt werden.
/// Wird lokal auf dem Geraet gespeichert (SharedPreferences / JSON).
class DataRequest {
  DataRequest({
    required this.vin,
    required this.brand,
    this.model,
    this.year,
    this.firstRegistration,
    required this.ownerName,
    this.ownerAddress,
    this.ownerEmail,
    this.ownerPhone,
    this.isForSelf = true,
    required this.selectedDataCategories,
    required this.oemContactId,
    this.createdAt,
    this.sentAt,
    this.deadlineAt,
    this.status = DataRequestStatus.draft,
  });

  /// Fahrzeug-Identifikationsnummer (17 Zeichen).
  final String vin;

  /// Marke (z.B. "Volkswagen").
  final String brand;

  /// Modell (z.B. "Golf").
  final String? model;

  /// Baujahr (aus FIN Position 10).
  final String? year;

  /// Erstzulassung.
  final String? firstRegistration;

  /// Name des Antragstellers.
  final String ownerName;

  /// Anschrift.
  final String? ownerAddress;

  /// E-Mail.
  final String? ownerEmail;

  /// Telefon.
  final String? ownerPhone;

  /// Fuer sich selbst oder fuer jemand anderen?
  final bool isForSelf;

  /// Gewaehlte Datenkategorien fuer die Anfrage.
  final List<String> selectedDataCategories;

  /// ID des OEM-Kontakts (Key aus oem_contacts.json).
  final String oemContactId;

  /// Erstellungsdatum.
  final DateTime? createdAt;

  /// Absende-Datum (null = noch nicht gesendet).
  final DateTime? sentAt;

  /// Frist-Datum (30 Tage nach Versand).
  final DateTime? deadlineAt;

  /// Status der Anfrage.
  final DataRequestStatus status;

  /// Erstellt eine Kopie mit geaenderten Feldern.
  DataRequest copyWith({
    String? vin,
    String? brand,
    String? model,
    String? year,
    String? firstRegistration,
    String? ownerName,
    String? ownerAddress,
    String? ownerEmail,
    String? ownerPhone,
    bool? isForSelf,
    List<String>? selectedDataCategories,
    String? oemContactId,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? deadlineAt,
    DataRequestStatus? status,
  }) {
    return DataRequest(
      vin: vin ?? this.vin,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      firstRegistration: firstRegistration ?? this.firstRegistration,
      ownerName: ownerName ?? this.ownerName,
      ownerAddress: ownerAddress ?? this.ownerAddress,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      isForSelf: isForSelf ?? this.isForSelf,
      selectedDataCategories:
          selectedDataCategories ?? this.selectedDataCategories,
      oemContactId: oemContactId ?? this.oemContactId,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      deadlineAt: deadlineAt ?? this.deadlineAt,
      status: status ?? this.status,
    );
  }
}

/// Status einer Datenanfrage.
enum DataRequestStatus {
  /// Entwurf — noch nicht gesendet.
  draft,

  /// Gesendet — wartet auf Antwort.
  sent,

  /// Beantwortet — OEM hat reagiert.
  answered,

  /// Abgelaufen — Frist ueberschritten, keine Antwort.
  expired,
}
