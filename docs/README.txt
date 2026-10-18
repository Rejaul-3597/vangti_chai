VangtiChai - CSE 489 Assignment 1
=================================

Name:
Student ID:

Framework: Flutter (Dart)

What the app does
-----------------
- Shows a numeric keypad built from scratch (digits 0-9 and CLEAR).
- Each tapped digit is added to the right of the current amount.
- Shows the change for that amount in Taka notes
  (500, 100, 50, 20, 10, 5, 2, 1) using the fewest notes.
- Portrait: change table on the left, 3-column keypad on the right.
- Landscape: change table in two columns of four, 4-column keypad.
- The entered amount and change list are kept when the device rotates.
  (The amount is stored in the screen's State object, which survives
  rotation.)
- Maximum amount length is 9 digits.

Layouts (4)
-----------
- Phone, portrait
- Phone, landscape
- Tablet, portrait
- Tablet, landscape
Screens with a shortest side of 600 dp or more use the tablet sizes.
All text sizes, paddings, margins and heights are in lib/sizes.dart
(the Flutter equivalent of sizes.xml). They are not hardcoded in main.dart.

How to run
----------
  flutter pub get
  flutter run

Devices / screen types tested
-----------------------------
(Write only what you really tested. Examples of the format:)
- OnePlus Nord 5 (real phone, USB), portrait and landscape:
- Chrome at 411 x 731 dp (Pixel XL size), portrait and landscape:
- Chrome at 800 x 1280 dp (Nexus 10 size), portrait and landscape:
- Other sizes tried:

Minimum Android version
-----------------------
(Check minSdk in android/app/build.gradle.kts and write it here.)
