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

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
