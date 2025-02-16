# hng two App

The **Hng two App** is a Flutter-based mobile application that allows users to explore information about different countries. It provides a list of countries, their flags, capitals, and the ability to search for specific countries. The app also supports dark and light themes, which can be toggled by the user.

## Features

- **Country List**: Displays a list of countries with their flags and capitals.

- **Search Functionality**: Allows users to search for countries by name.

- **Filter by Language**: Filter countries based on their official languages.

- **Filter by Continent**: Filter countries by their continent.

- **Filter by Time Zone**: Filter countries by their time zone.

- **Dark/Light Theme**: Supports both dark and light themes, which can be toggled via a button in the app bar.

- **Country Details**: Tapping on a country in the list navigates to a detailed view of the country (not implemented in this code snippet).

## Getting Started

### Prerequisites

Before running the app, ensure you have the following installed:

- **Flutter SDK**: [Flutter SDK](https://flutter.dev/docs/get-started/install) Make sure you have Flutter installed on your machine. If not, follow the official Flutter installation guide. https://docs.flutter.dev/get-started/install

- **Dart SDK**: Flutter comes with Dart, so no separate installation is needed.

- **IDE**: You can use Android Studio, IntelliJ IDEA, or Visual Studio Code with the Flutter and Dart plugins installed.

### Installation

- **Clone the repository**:
   ```bash
   git clone https://github.com/GodswillErondu/hng_two.git
   cd hng_two

- **Fetch dependencies**:
  flutter pub get

- **Run the app**:
  flutter run

🔗 Links:

GitHub Repository: https://github.com/GodswillErondu/hng_two.git

## Dependencies

The app uses the following dependencies:

- **provider**: For state management, specifically for managing the app's theme.

- **http**: For making HTTP requests to fetch country data (used in CountryService).

## Usage

- **Search for a Country**: Type the name of a country in the search bar to filter the list.

- **Toggle Theme**: Use the theme toggle button in the app bar to switch between dark and light modes.

- **View Country Details**: Tap on a country in the list to navigate to its detailed view.

- **Filter Button**: Tap the filter button to open the filter bottom sheet.

### Filter Bottom Sheet

- **Continent**: Tap "Continent" to open a list of continents and select one.

- **Time Zone**: Tap "Time Zone" to open a list of time zones and select one.

- **Reset**: Tap "Reset" to clear all filters.

Show Results: Tap "Show Results" to apply the selected filters and close the bottom sheet.
## 📱 Live Demo

Try the app directly in your browser using Appetize.io:

-Android demo:  https://appetize.io/app/b_zovyc5zpyywo45v4koqgywvel4

## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

- Fork the repository.

- Create a new branch for your feature or bugfix.

- Commit your changes with clear and descriptive messages.

- Submit a pull request.

## Acknowledgments

Flutter: For providing an excellent framework for building cross-platform apps.

Country API: For providing the data used in this app (used in CountryService).

HNG Internship: For providing a wonderful opportunity to work on stage 2 mobile task.

## License

This project is licensed under the MIT License.