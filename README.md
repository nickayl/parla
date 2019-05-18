# Parla
Parla is a modern and user-friendly Chat UI library for iOS. It has been built with flexibility in mind: There are a lot of things that you can change!

It is really easy to use, it requires only little configuration and you are ready to start!

<img src="https://github.com/cyclonesword/parla/blob/master/parla/Test%20Resources/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-18%20at%2012.17.46.png" width="276" height="598"><img src="https://github.com/cyclonesword/parla/blob/master/parla/Test%20Resources/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-18%20at%2012.17.41.png" width="276" height="598">


## Installation
### CocoaPods
Documentation under construction

### Carthage
Carthage support will be soon available

## Usage
### Quick Start Guide

In the view you want to display the Chat UI, set the custom class as  ```ParlaView``` :
<img src="https://github.com/cyclonesword/parla/blob/master/parla/Test%20Resources/github_task_1.png?raw=true" width="821" height="84">

Don't forget to bind the ParlaView view with an outlet inside your custom ViewController class.

Then in your ViewController, you need to implement at leat the ```ParlaViewDatasource``` class, but i highly reccomand to bind also the ```ParlaViewDelegate``` to receive notification when the user perform various operations (such us when press the send button, when it is recording a voice message etc.) :
```swift
class MyViewController : UIViewController, ParlaViewDataSource, ParlaViewDelegate { 
...
```

