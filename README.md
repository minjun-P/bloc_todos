# Flutter Todos
bloc 상태관리를 사용한 todo app 
[(bloc 공식 튜토리얼(todo app))](https://bloclibrary.dev/ko/tutorials/flutter-todos/)
---
### Project Structure
```
├── lib
├── packages
│   ├── local_storage_todos_api
│   ├── todos_api
│   └── todos_repository
└── test
```
메인 앱 코드가 `lib`에 들어가고, 3가지 별도의 패키지로 나누어져 있다. \
각 패키지간 종속 관계를 명확히 관리하기 위함이라고 한다. 그리고 SRP 를 지키고자 함도 있다고 한다.

### Architecture
구성도는 다음과 같다. 우리가 써 오던 clean architecture와 유사하지만, use case가 없다는 점, 
presentation layer가 아닌 feature layer로 분리한다는 점이 약간 다르다.
- data layer
- domain layer
  - repository
- feature layer
  - business logic (blocs/cubits - view model)
  - presentation (widgets)


### Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Flutter Todos works on iOS, Android, Web, and Windows._

---

### Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---
