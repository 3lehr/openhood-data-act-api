# OpenHood Data Act API

This is the open-source core of the OpenHood app, providing the logic to generate EU Data Act (Art. 4) requests for connected vehicles.

## Features

- **Data Categories**: Pre-defined categories of vehicle data that can be requested under the EU Data Act.
- **Request Generation**: Generates legally compliant, personalized request letters in German and English.
- **OEM Contacts**: Manages a database of OEM contacts (manufacturers) to direct the requests to the correct legal entity.

## Installation

Add this package to your `pubspec.yaml` as a git dependency (until it is published to pub.dev):

```yaml
dependencies:
  openhood_data_act_api:
    git:
      url: https://github.com/3lehr/openhood-data-act-api.git
```

## Usage Example

```dart
import 'package:openhood_data_act_api/openhood_data_act_api.dart';

void main() {
  final service = DataRequestService();
  
  // Generate a request for a specific OEM
  final requestText = service.generateRequestText(
    oemName: 'Volkswagen AG',
    userName: 'Max Mustermann',
    userAddress: 'Musterstraße 1, 12345 Berlin',
    vin: 'WVWZZZ...',
    languageCode: 'de',
  );
  
  print(requestText);
}
```

## Roadmap & Future Outlook: Direct OEM API Access

Currently, this package generates formal legal requests (PDF/Email) based on Art. 4 of the EU Data Act to force OEMs to provide vehicle data. 

**The ultimate goal is direct API access.** As the EU Data Act enforcement progresses, OEMs are legally required to provide direct, real-time API access to the user's vehicle data without artificial barriers. 

Future versions of this package will evolve from a "legal request generator" into a **direct OEM API client**, providing standardized interfaces to fetch telemetry, battery status, and diagnostic data directly from the manufacturers' servers on behalf of the user.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
