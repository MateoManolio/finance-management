# WalletWise

WalletWise is a personal finance application developed in Flutter that serves to keep track of your expenses, organizing and presenting them in a way that is easily understandable for the user. Throughout this document, the technical details of the application's architecture will be outlined in more depth.

## Getting Started

This project is a Flutter application. Just clone the repository and run the command `flutter run` in the console

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Application Development
## Application Architecture
This Flutter project follows the following file structure:
```
└ lib
  ├ app
  │ ├ bindings # dependency injection binders
  │ ├ controllers # business logic files
  │ │ ├ screen 1
  │ │ ├ screen 2
  │ │ └ ...
  │ ├ data # data sources files
  │ │ ├ models
  │ │ └ repositories
  │ ├ core
  │ │ ├ themes
  │ │ ├ domain
  │ │ └ utils
  │ ├ service
  │ ├ translations
  │ │ └ es_ARG
  │ └ views
  │   ├ widgets   # global widgets
  │   └ screens
  │     ├ screen 1
  │     │  ├ widgets  # widgets of one screen
  │     │  └ page
  │     ├ screen 2
  │     │  ├ widgets
  │     │  └ page
  │     └ ...
  └ main.dart 
```
where we work with GetX as a state manager. Therefore, the **binding**, **controllers**, **routes**, **service**, and **translation** directories are used following the best practices provided by the [GetX documentation](https://chornthorn.github.io/getx-docs/). Each screen is associated with its corresponding page and associated widgets. Note that the `translation` section will be empty for now, as there are no plans to support multiple languages (**the application will be in Spanish**), but the idea is not ruled out, and the possibility remains open.

## GitHub Management
As part of best practices, the following guidelines will be followed when working with this version control system.
1. GitMoji will be used _without exception_ for the specification of each commit. These GitMojis may not always align with [their official page](https://gitmoji.dev/), prioritizing emojis that are representative of the commit.
2. Branch naming will follow this convention:
   - For incorporating a new feature: `FEATURE/name-with-dashes`
   - For code bugs or fixes: `FIX/name-with-dashes`
   - For code refactoring: `DEV/name-with-dashes`
3. Despite this project being managed by a single person, **PR**s will be created for each branch before merging into main. After that, the branch will be deleted. Pull requests will follow a detailed structure in a template, including screenshots when making UI changes and specifying the devices used to test the application's correct functionality. The justification for creating these PRs is to transparently showcase the development of the application, including challenges and bugs that needed fixing.

## User Stories
This application will **not** use [Jira](https://www.atlassian.com/es/software/jira) or any other task management program. This is simply because, as a developer, I will work on whatever I feel like at that moment.

## Effective Dart
While not an expert in Flutter or Dart, I will always strive to follow the best practices outlined on their official pages:
   - [Effective Dart](https://dart.dev/effective-dart)
   - [Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
