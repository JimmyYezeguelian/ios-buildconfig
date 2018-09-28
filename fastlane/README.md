fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios coverage
```
fastlane ios coverage
```
Slather code coverage with limit
### ios shared_tests
```
fastlane ios shared_tests
```
Run unit tests
### ios shared_sample
```
fastlane ios shared_sample
```
Build a sample
### ios shared_ci
```
fastlane ios shared_ci
```
Build everything
### ios release
```
fastlane ios release
```
Module Pre-Release checks
### ios stg_lint
```
fastlane ios stg_lint
```
Lint the podspec on STG spec repo
### ios prd_lint
```
fastlane ios prd_lint
```
Lint the podspec on PROD spec repo
### ios lint_module
```
fastlane ios lint_module
```

### ios generate_doxygen
```
fastlane ios generate_doxygen
```
Generate Doxygen documentation for module using red-gendoc script
### ios setup_project
```
fastlane ios setup_project
```
Set up project, including git hooks
### ios format_objc
```
fastlane ios format_objc
```
Format Objective-C code using clang-format tool

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
