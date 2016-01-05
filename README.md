# Redux

[![CI Status](http://img.shields.io/travis/oursky/Redux.svg?style=flat)](https://travis-ci.org/oursky/Redux)
[![codecov.io](https://codecov.io/github/oursky/Redux/coverage.svg?branch=master)](https://codecov.io/github/oursky/Redux?branch=master)
[![Version](https://img.shields.io/cocoapods/v/Redux.svg?style=flat)](http://cocoapods.org/pods/Redux)
[![License](https://img.shields.io/cocoapods/l/Redux.svg?style=flat)](http://cocoapods.org/pods/Redux)
[![Platform](https://img.shields.io/cocoapods/p/Redux.svg?style=flat)](http://cocoapods.org/pods/Redux)

Redux is a swift implementation of [redux](https://github.com/rackt/redux).

A thorough walk through and description of the framework can be found at the official Redux repository: [redux](http://redux.js.org/index.html).

## Features

- Project scaffolding, includes basic redux structure and test cases
- File templates
- Static typed State
- Handy functions for integrating with UIViewController, similar to [react-redux](https://github.com/rackt/react-redux)

## Getting Started

### Quick Start from [Project Template](https://github.com/oursky/Redux-Project-Template)

Start with our project template

```bash
curl https://raw.githubusercontent.com/oursky/Redux-Project-Template/master/download | bash -s YOUR_PROJECT_NAME
```

### Add to an existing project with [CocoaPods](https://guides.cocoapods.org/)

Add the following in Podfile
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod "Redux", "~> 0.1.0"
```

Then, run the following command
```bash
pod install
```

## Install Xcode Redux File Templates

Run the following command
```bash
# if your XCode path is '/Applications/Xcode.app'
curl https://raw.githubusercontent.com/oursky/Redux-Project-Template/file-templates/install-template.sh | bash -s

# else
curl https://raw.githubusercontent.com/oursky/Redux-Project-Template/file-templates/install-template.sh | bash -s YOUR_XCODE_PATH
```

Then, you may open Xcode, go to `File -> New -> File...`, you should be able to find the file templates under `Redux`

See https://github.com/oursky/Redux-Project-Template/tree/file-templates

## Try Example

```bash
git clone git@github.com:oursky/Redux.git
cd Redux
pod install --project-directory=Example
open Example/Redux.xcworkspace
```

Then you may run **Redux-Example** in XCode

## Credit

Inspired from
- https://github.com/rackt/redux
- https://github.com/mwise/Redux.swift

## License

Redux is available under the MIT license. See the LICENSE file for more info.
