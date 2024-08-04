# Yoyo Chatt

Simple chat application using `firebase`.

## Installation

> You need the following tools to be already installed.

- [flutter](http://flutter.dev/)
- [node](https://nodejs.org/en)
- [firebase-tools](https://www.npmjs.com/package/firebase-tools)
- [flutterfire_cli](https://pub.dev/packages/flutterfire_cli)
- [derry](https://pub.dev/packages/derry) - Optional

Firebase configuration

- Go to [Firebase console](https://console.firebase.google.com/), create a project.
- Enable authentication method (Email/Password sign in)
- Go to firestore database and replace the following rules with old ones and published it.

  ```
  rules_version = '2';
  service cloud.firestore {
  match /databases/{database}/documents {
      // Function available for all collections
      // Checks that request is coming from an authenticated user
      function isSignedIn() {
      return request.auth != null;
      }

      // Rules for the users collection
      match /users/{userId} {
      // Validates user's object format
      // Remove this if you don't plan to provide first or last names
      function isUserCorrect() {
          return isSignedIn() && request.resource.data.firstName is string && request.resource.data.lastName is string;
      }

      // Checks that the document was created by currently logged in user
      function isSelf() {
          return request.auth.uid == userId;
      }

      // Rules set for the users collection
      allow create: if isUserCorrect();
      allow delete: if isSelf();
      allow read: if isSignedIn();
      allow update: if isUserCorrect() && isSelf();
      }

      // Rules for the rooms collection
      match /rooms/{roomId} {
      // Checks that currently logged in user exists in users collection
      function userExists() {
          return isSignedIn() && exists(/databases/$(database)/documents/users/$(request.auth.uid));
      }

      // Checks that currently logged in user is in the room
      function isUserInRoom() {
          return isSignedIn() && request.auth.uid in resource.data.userIds;
      }

      // Validates room's object format
      function isRoomCorrect() {
          return request.resource.data.type is string && request.resource.data.userIds is list;
      }

      // Rules set for the rooms collection
      allow create: if userExists() && isRoomCorrect();
      allow delete, read, update: if isUserInRoom();

      // Rules for the messages collection
      match /messages/{messageId} {
          // Checks that currently logged in user is in the room
          function isUserInRoomUsingGet() {
          return isSignedIn() && request.auth.uid in get(/databases/$(database)/documents/rooms/$(roomId)).data.userIds;
          }

          // Validates message's object format
          function isMessageCorrect() {
          return request.resource.data.authorId is string && request.resource.data.createdAt is timestamp;
          }

          // Checks that message's author is currently logged in user
          function isMyMessage() {
          return request.auth.uid == resource.data.authorId;
          }

          // Rules set for the messages collection
          allow create: if isSignedIn() && isMessageCorrect();
          allow delete, read: if isUserInRoomUsingGet();
          allow update: if isUserInRoomUsingGet() && isMyMessage();
        }
      }
    }
  }
  ```

- Go to Storage, enable and add the following rules.

  ```
  rules_version = '2';

  service firebase.storage {
  match /b/{bucket}/o {
      match /{allPaths=**} {
      allow read, write: if request.auth != null;
      }
    }
  }
  ```

1. Clone repository and change directory.

   ```bash
   git clone https://github.com/mixin27/yoyo_chatt.git
   cd yoyo_chatt/
   ```

2. Run `flutter pub get`

   ```bash
   flutter pub get
   ```

3. Login your firebase account that have a project you created before.

   ```
   firebase login
   ```

4. Configure firebase project within your project.

   ```
   flutterfire configure
   ```

   Select a project you created before and choose platform you like: android, ios, etc.

5. Run `build_runner` to generate necessary files.

   ```
   dart run build_runner build -d
   ```

6. Install npm packages - Optional

   ```
   npm i
   ```

7. copy `.env.example`, rename to `.env` and fill your secrets

8. Run your app.

## Main Technologies Use

- [flutter](http://flutter.dev/)
- [flutter_chat_ui](https://pub.dev/packages/flutter_chat_ui)
- [flutter_firebase_chat_core](https://pub.dev/packages/flutter_firebase_chat_core)
- [firebase](https://firebase.google.com/docs/flutter/setup?platform=android)
- [riverpod](https://riverpod.dev/)
- [auto_route](https://pub.dev/packages/auto_route)
