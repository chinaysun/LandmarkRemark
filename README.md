# LandmarkRemark
The codebase of Landmark Remark project, which is an application that allows users to save location based notes on a map.

## Table of contents
### Setting up
1. Tools
2. Services

### Projects
1. App Scope
2. Architecture
3. Dependencies
4. Files Management

### Future Improvement
1. Features Aspect
2. Project Management Aspect
3. Peformance Aspect

---

# Setting up
## 1. Tools
- __Cocoapods__: Dependency Manager
- __Github__: Version Control

## 2. Services ##
- [__Firebase__](http://firebase.google.com/): Backend Support

---

# Projects
## 1. App Scopes
* Users can track their current location on the map
* Users can add a note to their current location on the map
* Users can see other users marked places and see notes they left
* Users can searching places based on username or notes

## 2. Architecture
This project is following MVVM architecture, which stands for Model, View and ViewModel.

### 2.1 Explaination 
There is a bit different with MVVM architecture, since a ViewController not always comes with its ViewModel. For those View Controlle do not need any business/presenting logic, we don't need to provide a ViewModel for it.

### 2.2 Usage
  * Model: - Abstract the business entities to a model `User, Mark and Location`
  * ViewModel: - Including business/presenting logic process inside, providing view-ready data to ViewController 
  ````HomeViewModel```` 
  * ViewController: - Binding ViewModel to View

### 2.3 Dependency Injection
ViewModel should be able to stub and easy to test. All data fetcher layer stuff should be injected into ViewModel, rather than having ViewModel to calling static func to fetch data.
* Fetching: - a interface between ViewModel Layer and Data Fetcher Layer `HomeDataFetching`
* Fetcher: - Connecting between App and Service `FirebaseFetcher`

ViewModel only take a fetching rather a fetcher directly, a fetcher needs to conform the fetching protocol defined by ViewModel.

## 3. Dependencies
Dependencies management power by Cocoapods
  * RxSwift - a framework for interacting with the Swift programming language
  * RxCocoa - a framework that makes Cocoa APIs used in iOS and OS X easier to use with reactive techniques.
  * Firebase - a framewor for connecting firebase service
  * RxTest - Unit test for reactive programming in Swift

## 4. File Managment
Inside of the project, files are grouping by its function.
* Network: - Network Requester Package `FirebaseFetcher`
* Entities: - Model Package `User, Mark and Location`
* Screens: - Features Package `Home, NewMark, MarkDetail`
* Manager: - Manager Package `CoreLocationManager`

---

# Future Improvement
## 1. Features Aspect
1. Need to provide Annotation Clustering
2. It is better to introduce a list view to show marks
3. Map bottom Sheet

## 2. Project Management Aspect
1. Swiflint - Code style management
2. git branch managment - master/develop
3. versioning x.y.z
4. CI/CD tootls

## 3. Peformance Aspect
1. Annotation Clustering Efficiency 
2. Searching Efficiency
