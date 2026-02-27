/// OEM-Kontaktdaten fuer EU Data Act Art. 4 Anfragen.
///
/// Wird aus [assets/data/oem_contacts.json] geladen.
/// Schema: Pro Hersteller ein Eintrag mit i18n-Kontakten.
class OemContact {
  const OemContact({
    required this.id,
    required this.brandName,
    required this.legalEntity,
    required this.group,
    required this.wmiCodes,
    required this.email,
    required this.department,
    this.postal,
    this.phone,
    this.dataActPortal,
    this.preferredChannel = 'email',
    this.notes,
  });

  /// Hersteller-Key (z.B. "volkswagen", "bmw").
  final String id;

  /// Markenname wie auf dem Fahrzeug (z.B. "Volkswagen").
  final String brandName;

  /// Juristische Person (z.B. "Volkswagen AG").
  final String legalEntity;

  /// Konzerngruppe (z.B. "volkswagen_group").
  final String group;

  /// WMI-Codes (erste 3 Zeichen der FIN).
  final List<String> wmiCodes;

  /// E-Mail des Datenschutzbeauftragten / Data Act Kontakt.
  final String email;

  /// Abteilungsname (z.B. "Datenschutzbeauftragter").
  final String department;

  /// Postanschrift.
  final String? postal;

  /// Telefon.
  final String? phone;

  /// URL des Data-Act-Portals (falls vorhanden).
  final String? dataActPortal;

  /// Bevorzugter Kanal: "email", "portal", "postal".
  final String preferredChannel;

  /// Besonderheiten bei diesem OEM.
  final String? notes;

  /// Erstellt einen [OemContact] aus einem JSON-Eintrag.
  ///
  /// [id] ist der Map-Key, [json] der Wert,
  /// [locale] bestimmt welche Kontaktdaten geladen werden (default: "de").
  factory OemContact.fromJson(
    String id,
    Map<String, dynamic> json, {
    String locale = 'de',
  }) {
    final contacts = json['contacts'] as Map<String, dynamic>? ?? {};
    final localeContact =
        contacts[locale] as Map<String, dynamic>? ??
        contacts['de'] as Map<String, dynamic>? ??
        <String, dynamic>{};

    return OemContact(
      id: id,
      brandName: json['brand_name'] as String? ?? id,
      legalEntity: json['legal_entity'] as String? ?? '',
      group: json['group'] as String? ?? '',
      wmiCodes: (json['wmi_codes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      email: localeContact['email'] as String? ?? '',
      department: localeContact['department'] as String? ?? '',
      postal: localeContact['postal'] as String?,
      phone: localeContact['phone'] as String?,
      dataActPortal: localeContact['data_act_portal'] as String?,
      preferredChannel:
          localeContact['preferred_channel'] as String? ?? 'email',
      notes: localeContact['notes'] as String?,
    );
  }
}
