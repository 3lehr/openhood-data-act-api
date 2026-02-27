import 'dart:convert';


import 'package:openhood_data_act_api/src/models/oem_contact.dart';

/// Service zum Laden und Abfragen der OEM-Kontaktdatenbank.
///
/// Laedt [assets/data/oem_contacts.json] und stellt
/// OEM-Kontakte nach ID oder WMI-Code bereit.
class OemContactService {
  OemContactService._();

  static OemContactService? _instance;
  static List<OemContact>? _contacts;
  static Map<String, OemContact>? _byId;
  static Map<String, OemContact>? _byWmi;

  /// Singleton-Zugriff.
  static OemContactService get instance {
    _instance ??= OemContactService._();
    return _instance!;
  }

  /// Laedt die OEM-Kontakte aus dem Asset-Bundle.
  ///
  /// Muss einmal aufgerufen werden bevor [getById] oder [getByWmi]
  /// verwendet werden koennen. Ist idempotent.
  void loadFromJson(String jsonString, {String locale = 'de'}) {
    if (_contacts != null) return;

    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    final contacts = <OemContact>[];
    final byId = <String, OemContact>{};
    final byWmi = <String, OemContact>{};

    for (final entry in jsonMap.entries) {
      if (entry.key == '_meta') continue;

      final contact = OemContact.fromJson(
        entry.key,
        entry.value as Map<String, dynamic>,
        locale: locale,
      );
      contacts.add(contact);
      byId[entry.key] = contact;

      for (final wmi in contact.wmiCodes) {
        byWmi[wmi.toUpperCase()] = contact;
      }
    }

    _contacts = contacts;
    _byId = byId;
    _byWmi = byWmi;
  }

  /// Gibt den OEM-Kontakt fuer eine gegebene ID zurueck.
  OemContact? getById(String id) => _byId?[id];

  /// Gibt den OEM-Kontakt fuer einen WMI-Code zurueck.
  OemContact? getByWmi(String wmi) =>
      _byWmi?[wmi.toUpperCase()];

  /// Gibt den OEM-Kontakt fuer eine FIN (VIN) zurueck.
  ///
  /// Extrahiert die ersten 3 Zeichen als WMI.
  OemContact? getByVin(String vin) {
    if (vin.length < 3) return null;
    return getByWmi(vin.substring(0, 3));
  }

  /// Alle geladenen OEM-Kontakte.
  List<OemContact> get all => _contacts ?? [];

  /// Anzahl geladener Kontakte.
  int get count => _contacts?.length ?? 0;

  /// Gibt alle OEMs einer Konzerngruppe zurueck.
  List<OemContact> getByGroup(String group) {
    return all.where((c) => c.group == group).toList();
  }

  /// Gibt alle OEMs mit Data-Act-Portal zurueck.
  List<OemContact> get withPortal {
    return all.where((c) => c.dataActPortal != null).toList();
  }
}
