# AirLiftCaseStudy

![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/Language-Swift-orange.svg)

An image gallery app created for test purposes.

## Demo
<img src="https://media.giphy.com/media/1hubbxI70wONmW1NRG/giphy.gif" width="250" height="500" />

## Features

- [x] Unsplash Images API Using Pagination
- [x] Offline support
- [x] URL / JSON Parameter Encoding
- [x] Save images to disk for memory efficiency
- [x] Network Requests using URLSession
- [x] HTTP Response Validation

### Cool Features

- [x] WaterFall Custom Layout For CollectoinView
- [x] [Check internet connection before making api call using Reachability class](https://stackoverflow.com/questions/35427698/how-to-use-networkreachabilitymanager-in-alamofire/44300590#44300590) kindly also upvote my answer 😉

## Requirements

- iOS 14.5 (Change this to a lower version in project settings if you are not on latest xcode IDE)
- Xcode 12+
- Swift 5+

## Clean Architecture using MVVM
in Clean Architecture, we have different layers in the application. The main rule is not to have dependencies from inner layers to outers layers. The arrows pointing from outside to inside is the Dependency rule. There can only be dependencies from outer layer inward
After grouping all layers we have: Presentation, Domain and Data layers.
- #### Domain Layer 
  - Domain Layer (Business logic) is the inner-most part of the onion (without dependencies to other layers, it is totally isolated). It contains Entities(Business Models)
- #### Presentation Layer 
  - Presentation Layer contains UI (UIViewControllers or SwiftUI Views). Views are coordinated by ViewModels (Presenters). Presentation Layer depends only on the Domain Layer
- #### Data Layer
  - Data Layer contains Repository Implementations and one or many Data Sources. Repositories are responsible for coordinating data from different Data Sources. Data Source can be Remote or Local (for example persistent database). Data Layer depends only on the Domain Layer. In this layer, we can also add mapping of Network JSON Data (e.g. Decodable conformance) to Domain Models

- ### Dependency Direction
  - Presentation Layer -> Domain Layer <- Data Repositories Layer
  - Presentation Layer (MVVM) = ViewModels(Presenters) + Views(UI)
  - Domain Layer = Entities
  - Data Repositories Layer = Repositories Implementations + API(Network) + Persistence DB

## Dependencies

- None 😉. The reason for not including any third party dependency is that for tech challanges doing things in a Swifty way shows basic concepts and knowledge. In a production app this would differ using following dependencies below using [CocoaPods](https://cocoapods.org); 
- [x] Alamofire for Networking
- [x] AlamofireImage for loading images
- [x] RxSwift for reactive code base. This helps reacts to changes e.g viewModel in that case would have a publishRelay of photos array and an isLoading bool, which we can subscribe in our viewController on mainInstance and driver collectionView using publishRelay and showLoading indicator using isLoading bool as a Driver which ensure we are on mainThread.
- [x] Combine & SwiftUI only if the project supports ios13+ which is not the case :)

## Installation

- Clone the repo and open the .xcodeProj file
