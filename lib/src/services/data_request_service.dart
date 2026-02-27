import 'package:intl/intl.dart';

import 'package:openhood_data_act_api/src/models/data_request.dart';
import 'package:openhood_data_act_api/src/models/oem_contact.dart';

/// Service zum Generieren von EU Data Act Anfrage-Schreiben.
///
/// Erstellt personalisierte Anfragen gemaess Art. 4 VO (EU) 2023/2854.
/// Alle Texte in Konjunktiv-Form (Legal-Pflicht).
class DataRequestService {
  DataRequestService._();

  /// Die anfragbaren Datenkategorien.
  ///
  /// Basiert auf typischen vernetzten Fahrzeugdaten
  /// die unter Art. 4 Data Act fallen koennten.
  static const List<DataCategory> availableCategories = [
    DataCategory(
      id: 'location',
      labelDe: 'Standort- und Bewegungsdaten',
      labelEn: 'Location and movement data',
      descriptionDe: 'GPS-Positionen, Routenverlaeufe, Parkpositionen',
      descriptionEn: 'GPS positions, route history, parking locations',
    ),
    DataCategory(
      id: 'driving',
      labelDe: 'Fahrdaten und Fahrverhalten',
      labelEn: 'Driving data and behavior',
      descriptionDe:
          'Geschwindigkeit, Beschleunigung, Bremsverhalten, Lenkwinkel',
      descriptionEn: 'Speed, acceleration, braking, steering angle',
    ),
    DataCategory(
      id: 'diagnostics',
      labelDe: 'Diagnose- und Fehlerdaten',
      labelEn: 'Diagnostic and error data',
      descriptionDe: 'Fehlercodes (DTC), Warnmeldungen, Systemstatus',
      descriptionEn: 'Fault codes (DTC), warnings, system status',
    ),
    DataCategory(
      id: 'energy',
      labelDe: 'Energie- und Verbrauchsdaten',
      labelEn: 'Energy and consumption data',
      descriptionDe:
          'Kraftstoff-/Stromverbrauch, Reichweite, Ladezyklen',
      descriptionEn: 'Fuel/energy consumption, range, charging cycles',
    ),
    DataCategory(
      id: 'maintenance',
      labelDe: 'Wartungs- und Servicedaten',
      labelEn: 'Maintenance and service data',
      descriptionDe: 'Serviceintervalle, Oelstand, Bremsenverschleiss',
      descriptionEn: 'Service intervals, oil level, brake wear',
    ),
    DataCategory(
      id: 'connectivity',
      labelDe: 'Konnektivitaets- und App-Daten',
      labelEn: 'Connectivity and app data',
      descriptionDe:
          'Verbundene Geraete, App-Nutzung, Online-Dienste',
      descriptionEn: 'Connected devices, app usage, online services',
    ),
    DataCategory(
      id: 'safety',
      labelDe: 'Sicherheits- und Assistenzsysteme',
      labelEn: 'Safety and assistance systems',
      descriptionDe: 'Airbag-Status, ABS/ESP-Eingriffe, Notbremsungen',
      descriptionEn: 'Airbag status, ABS/ESP interventions, emergency braking',
    ),
    DataCategory(
      id: 'environment',
      labelDe: 'Umwelt- und Emissionsdaten',
      labelEn: 'Environmental and emission data',
      descriptionDe: 'CO2-Ausstoss, Abgaswerte, Partikelfilter-Status',
      descriptionEn: 'CO2 emissions, exhaust values, particle filter status',
    ),
  ];

  /// Generiert den Anfrage-Text.
  ///
  /// Konjunktiv-Pflicht: "mache ich von meinem Recht Gebrauch"
  /// ist aktiv (kein Konjunktiv noetig), da der User SELBST handelt.
  /// Konjunktiv nur bei Aussagen ueber OEM-Pflichten.
  static String generateRequestText({
    required DataRequest request,
    required OemContact contact,
    String locale = 'de',
  }) {
    if (locale != 'de') {
      return _generateEnglish(request: request, contact: contact);
    }

    final dateFormat = DateFormat('dd.MM.yyyy', 'de');
    final today = dateFormat.format(DateTime.now());

    final dataList = request.selectedDataCategories
        .map((id) {
          final cat = availableCategories.where((c) => c.id == id);
          return cat.isNotEmpty ? '- ${cat.first.labelDe}' : '- $id';
        })
        .join('\n');

    final registrationLine = request.firstRegistration != null
        ? '\n- Erstzulassung: ${request.firstRegistration}'
        : '';

    final modelLine = request.model != null
        ? ' ${request.model}'
        : '';

    return '''${contact.department}
${contact.legalEntity}
${contact.postal ?? ''}

$today

Betreff: Datenanfrage gemaess Art. 4 VO (EU) 2023/2854 (EU Data Act)

Sehr geehrte Damen und Herren,

hiermit mache ich von meinem Recht auf Datenzugang gemaess Art. 4 der Verordnung (EU) 2023/2854 ("Data Act") Gebrauch.

Ich bin Halter/Nutzer des folgenden Fahrzeugs:
- Marke/Modell: ${request.brand}$modelLine
- Fahrzeug-Identifikationsnummer (FIN): ${request.vin}$registrationLine

Als Nachweis meiner Berechtigung fuege ich eine Kopie meiner Zulassungsbescheinigung Teil I bei.

Ich bitte um Bereitstellung folgender vom Fahrzeug generierter Daten in einem gaengigen, maschinenlesbaren Format (z.B. CSV, JSON):

$dataList

Gemaess Art. 4 Abs. 1 der VO (EU) 2023/2854 bitte ich um Bereitstellung der Daten innerhalb von 30 Tagen.

Mit freundlichen Gruessen
${request.ownerName}
${request.ownerAddress ?? ''}
${request.ownerEmail ?? ''}''';
  }

  static String _generateEnglish({
    required DataRequest request,
    required OemContact contact,
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'en');
    final today = dateFormat.format(DateTime.now());

    final dataList = request.selectedDataCategories
        .map((id) {
          final cat = availableCategories.where((c) => c.id == id);
          return cat.isNotEmpty ? '- ${cat.first.labelEn}' : '- $id';
        })
        .join('\n');

    final registrationLine = request.firstRegistration != null
        ? '\n- First registration: ${request.firstRegistration}'
        : '';

    final modelLine = request.model != null
        ? ' ${request.model}'
        : '';

    return '''${contact.department}
${contact.legalEntity}
${contact.postal ?? ''}

$today

Subject: Data access request pursuant to Art. 4 Regulation (EU) 2023/2854 (EU Data Act)

Dear Sir or Madam,

I hereby exercise my right of access to data pursuant to Art. 4 of Regulation (EU) 2023/2854 ("Data Act").

I am the holder/user of the following vehicle:
- Brand/Model: ${request.brand}$modelLine
- Vehicle Identification Number (VIN): ${request.vin}$registrationLine

As proof of my entitlement, I enclose a copy of my vehicle registration document.

I request the provision of the following vehicle-generated data in a commonly used, machine-readable format (e.g. CSV, JSON):

$dataList

Pursuant to Art. 4(1) of Regulation (EU) 2023/2854, I request the data to be provided within 30 days.

Yours faithfully
${request.ownerName}
${request.ownerAddress ?? ''}
${request.ownerEmail ?? ''}''';
  }

  /// Berechnet die 30-Tage-Frist ab einem Datum.
  static DateTime calculateDeadline(DateTime sentDate) {
    return sentDate.add(const Duration(days: 30));
  }

  /// Prueft ob eine Frist abgelaufen ist.
  static bool isDeadlineExpired(DateTime deadline) {
    return DateTime.now().isAfter(deadline);
  }
}

/// Eine anfragbare Datenkategorie.
class DataCategory {
  const DataCategory({
    required this.id,
    required this.labelDe,
    required this.labelEn,
    this.descriptionDe,
    this.descriptionEn,
  });

  final String id;
  final String labelDe;
  final String labelEn;
  final String? descriptionDe;
  final String? descriptionEn;
}
