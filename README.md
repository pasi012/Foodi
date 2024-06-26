# Complete Food Delivery App
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)

 </br>
 A Complete Food Delivery Flutter App with Admin web portal. basically it contains (rider app,seller app and user app with super admin web portal) .

 # Foodi App

This is a mobile application developed using Flutter that allows users to order food from various restaurants for delivery.

## Features
### This project contains following apps and web application.
- Resturant App
- User App
- Rider App
- Admin App
## resturant App
- Seller registration and authentication
- Manage Profile
- Browse restaurants and menus
- Add Menu and Menu Items
- Delete Menu and Menu Items
- Accept Order
- Place orders for delivery
- Track order status
- Browse History
- Browse Total Earning
## User App
- User registration and authentication
- Browse restaurants and menus
- Add items to the cart
- Add Address(Live Location) 
- Place orders for delivery
- Track order status
- Browse History
## Rider App
- Rider registration and authentication
- Manage Profile
- Browse New Orders
- Accept Order
- Browse Not Delivered Orders
- Browse To Be Delivered Orders
- Track order status
- Browse History
- Browse Total Earning
## Admin App
- Admin registration and authentication
- Block/Unblock User Account
- Block/Unblock Seller Account
- Block/Unblock Rider Account 

## Installation

1. Clone the repository:

```bash
git clone https://github.com/pasi012/Foodi
```

2. Change to the project directory:

```bash
cd Foodi
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```
5. Run the web application:

```bash
flutter run -d chrome or select device chrome and and run, flutter run command
```

Make sure you have Flutter and Dart installed on your development machine.

## Configuration

In order to use certain features of the app, you need to configure the following:

1. Firebase Integration:
   - Create a new project in Firebase console (https://console.firebase.google.com).
   - Enable Firebase Authentication, Cloud Firestore, and Firebase Cloud Messaging.
   - Download the `google-services.json` file and place it in the `android/app/` directory.
   - Update the `android/build.gradle` file with your Firebase project details.

2. Payment Integration:
   - Obtain API keys for your chosen payment gateway (e.g., Stripe).
   - Update the payment configuration files (`lib/services/payment_service.dart`) with your API keys.

## Contributing

Contributions are welcome! If you find any bugs or want to add new features, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework used for building the app.
- [Firebase](https://firebase.google.com/) - Backend services for user authentication and data storage.
- [Stripe](https://stripe.com/) - Payment gateway integration.

