# magic_test

Note:

The project has been tested on an Android physical device.


Architecture :

I have implemented a feature based approach to this project. By doing this , we can achieve separation between repository, business logic and screen. By doing it this way , we can make changes easily to the respective sections without it directly affecting another.

There are two features here : workout and WorkoutList. 

State management :

I have used Bloc as my preferred choice of state management. I have used this because it is designed to be scalable, testable, and maintainable.

Navigation :

goRouter has been used here as it is a versatile package which can be used for both web and mobile navigation. It keeps all navigation logic in one page.

Testing :
Unit , widget testing implemented for the screens.
Integration test for end to end testing.


Third party packages used : 

  flutter_bloc: ^9.1.1 : 
  Core BLoC functionality

  equatable: ^2.0.7 :
  Needed for value comparison rather than referential comparison which bloc does.

  go_router: ^16.1.0 : 
  Routes are defined in one place, easy to understand.
  Efficient navigation

  Hive has been chosen as the local storage package as it is a fast and performant local storage.
  hive: ^2.2.3
  Core database functionality

  hive_flutter: ^1.1.0
  Flutter-specific Hive integration

  uuid: ^4.5.1
  Ensures each workout and set has a unique identifier

  build_runner: ^2.5.4
  hive_generator: ^2.0.0
  These two packages are used to generate the hive adapters as we have complex types.

  bloc_test: ^10.0.0
  An package which makes bloc testing easier

  mocktail: ^1.0.4
  A package to mock the behaviour of blocs without actually running its real logic and we can test the UI independantly.
  Avoids the dependency on repositories, which depend on APIs or Hive.



