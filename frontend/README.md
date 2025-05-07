# Mobile App Project

This project is a mobile application built with Flutter for the frontend and Node.js for the backend. The application is designed to provide a seamless user experience and efficient data handling.

## Project Structure

- **backend/**: Contains the Node.js backend code.
  - **src/**: Source files for the backend.
    - **app.js**: Main application file.
    - **controllers/**: Contains the controllers for handling requests.
    - **routes/**: Defines the API routes.
    - **models/**: Contains the data models.
  - **package.json**: Node.js dependencies and scripts.
  - **README.md**: Documentation for the backend.

- **frontend/**: Contains the Flutter frontend code.
  - **lib/**: Main directory for Flutter application code.
    - **main.dart**: Entry point of the Flutter application.
    - **screens/**: Contains different screens of the application.
    - **widgets/**: Custom widgets used in the application.
  - **pubspec.yaml**: Flutter dependencies and configurations.
  - **README.md**: Documentation for the frontend.

## Getting Started

### Prerequisites

- Flutter SDK
- Node.js and npm

### Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the backend directory and install dependencies:
   ```
   cd backend
   npm install
   ```

3. Navigate to the frontend directory and install dependencies:
   ```
   cd frontend
   flutter pub get
   ```

### Running the Application

1. Start the backend server:
   ```
   cd backend
   node src/app.js
   ```

2. Run the Flutter application:
   ```
   cd frontend
   flutter run
   ```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.