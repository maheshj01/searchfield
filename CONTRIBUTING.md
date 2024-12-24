# Contributing

### Contributor

Thanks for taking you time to contribute to this repo. Before you start contributing please go through the following guidelines which we consider are important to maintain this repository and can help new contributers to open source.

- Before you submit a Pull request ensure a issue exist describing the issue / feature request. If it doesn't please file an issue so that we could discuss about the issue before the actual PR is submitted.

- The issue should be sufficient enough to explain the bug/feature request and a possible solution/ proposal

- We appreciate any contribution, from fixing a grammar mistake in a comment, improving code snippets to fixing a bug or making a feature requests and writing proper tests are also highly welcome.

- Follow the [dart best practices](https://dart.dev/guides/language/effective-dart) to maintain the quality of code.

(Optional)

- Additional changes for publishing a release. Update the version in readme, pubspec.yaml, and update the changelog. Make sure the documentation is updated as per the changes. Make sure existing and new tests are passing. Make sure the code is well formatted. Ensure the linter warnigs are zero.

### Contributing

1. Fork This repo
2. Create a new branch
3. Commit a Fix
4. Add appropriate tests(recommended)
5. Submit a PR referencing the issue
6. Request a review
7. wait for LGTM 🚀 comment

### Publishing (Optional for contributors)

This part is mainly applicable to the maintainer of the repository but you are welcome to make the below changes which are required to publish the package. When publishing a new release of this package ensure all the checklist are completed.

- ✅ Update the version in readme, pubspec.yaml, and update the changelog
- ✅ Make sure the documentation is updated as per the new changes.
- ✅ Make sure existing and new tests are passing by running `flutter test`

- (Optional) To see the code coverage run the following commands
  ```bash
  flutter test --coverage
  genhtml coverage/lcov.info -o coverage/html
  open coverage/html/index.html
  ```
- ✅ Make sure the code is well formatted by running `dart format .`
- ✅ ensure there are no linter warnings by running `flutter analyze`
- ✅ Tag a package release in github [related to #Issue 103](https://github.com/maheshj01/searchfield/issues/103)
- ✅ Publish the package by running `flutter pub publish --dry-run` and `flutter pub publish`
- Update Min Flutter Sdk Constraints in pubspec.yaml, if a new flutter API is used and mention the version in the changelog.
- ✅ Tag the release in github with the version number.
