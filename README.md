# Rickipedia iOS App

Rickipedia is an iOS app developed in Swift that allows users to explore information about characters from the popular TV show Rick and Morty. The app consumes the [Rick and Morty API](https://rickandmortyapi.com) to fetch character data and provides features such as character listing, filtering, and detailed character information.

## Features

### Character Listing

The app fetches data from the `/character` endpoint of the Rick and Morty API to display a list of characters. Each character is represented by their photo and name.

### Character Filtering

The character listing screen allows users to filter characters by name and status. The app sends appropriate parameters to the `/character` endpoint to fetch filtered results based on user input.

### Character Details

When a user selects a character from the listing, the app navigates to a detailed character screen. This screen displays additional information about the character, including species, gender, and type.

### Pagination

The character listing supports pagination, allowing users to scroll through multiple pages of characters. The app fetches additional pages from the /character endpoint as the user reaches the end of the current page.

### Offline Support

The app caches API responses locally to provide offline support. Once a user has fetched character data, they can view the cached information even without an internet connection.

### Rotation Support

The app supports both portrait and landscape orientations, adapting the user interface to provide an optimal viewing experience in different device orientations.

## Stack

The Rickipedia app utilizes the following technologies and frameworks:

- **Swift**: The programming language used to develop the application.

- **UIKit**: Apple's native framework for building user interfaces. UIKit is used to create the app's screens and components.

- **View Code**: The app utilizes a programmatic approach to UI development, also known as View Code. This approach allows for more control and flexibility in defining the UI layout and behavior.
Diffable Data Source: The Diffable Data Source is used for implementing the character list. It provides an easy and efficient way to manage and update data in the user interface, ensuring a smooth and fast scrolling experience.

- **Combine**: Combine is a powerful framework introduced by Apple for reactive programming in Swift. It is used in the app to observe and react to changes in the view model's state, updating the view controller accordingly.

- **Unit Testing**: The app includes unit tests to verify the correctness and reliability of essential components, such as view models. Unit tests cover business logic and data processing in the view models, ensuring the expected behavior of the app.

- **UI Testing**: In addition to unit tests, the app also includes UI tests to simulate user interactions and verify the proper functioning of the app's interface.

## Architecture

The Rickipedia app follows the MVVM-C (Model-View-ViewModel-Coordinator) architecture pattern, ensuring separation of concerns, improved testability, and clear navigation flow. The app is structured into the following components:

- Coordinators: The coordinators handle navigation and flow control between different screens of the app, adhering to the coordinator pattern.

- View Controllers: The view controllers are responsible for displaying the user interface and interacting with the user. The character listing and character details screens are implemented as view controllers.

- View Models: The view models encapsulate the business logic and data for the views. They fetch data from the API, process it, and provide formatted data to the view controllers.

- Networking: The app communicates with the Rick and Morty API using the REST API. The networking layer is separated into the RKPService package, which handles API requests and responses.

- Design: The design-related components are organized in the RKPDesign package. This package contains reusable UI components, ensuring consistency and maintainability in the app's user interface.

## Testing

The Rickipedia app includes unit tests to ensure the correctness and reliability of critical components, such as view models, networking, and persistence. The unit tests cover the business logic, data processing, and API communication, validating the expected behavior of the app.

Additionally, the app includes UI tests to simulate user interactions and verify the proper functioning of the user interface and snapshot tests for the reusable UI components.

## Dependencies
The Rickipedia app utilizes the following third-party dependencies:

- [FLANimatedImage](https://github.com/Flipboard/FLAnimatedImage): FLANimatedImage is a library that provides support for displaying animated GIFs and APNGs in iOS applications. It is used in the app to display animated images, enhancing the visual experience.

- [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing): SnapshotTesting is a powerful library for iOS UI testing that enables snapshot-based testing. It allows capturing and comparing snapshots of UI components to ensure visual consistency and catch unintended changes in the app's appearance.
