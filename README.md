# Hitchhiker Prophecy

This project contains the API and UI implementation of The Hitchhiker's Prophecy. APIs documentation is here [Document Link 1][url1] and [Document Link 2][url2]

## Features

* Marvel Heroes and Heroines Listing
* Detail screen thats showcases superhero description

## Architecture

"VIP" approach is used in development of this project

### Model
It stores all the models related to the controller. The Models class is related to each component. It is of type struct and mostly it contain Request, Response, and ViewModel structs.

### Router
The router takes care for the transition and passing data between view controllers.

### Worker
The Worker component handles all the API/CoreData requests and responses. The Response struct (from Models) gets the data ready for the Interactor. It handles the success/error response, so the Interactor can know how to proceed.

### Interactor
This is the “mediator” between the Worker and the Presenter. It communicates with the ViewController which passes all the Request params needed for the Worker. Before proceeding to the Worker, a validation is done to check if everything is sent properly. The Worker returns a response and the Interactor passes that response towards the Presenter.

### Presenter
When we get the Response from the Interactor, it is formatted into a ViewModel and passed to ViewController. Presenter is in charge of the presentation logic. This component decides how the data is presented to the user.

### ViewController
ViewController communicates with the Interactor, and get a response back from the Presenter. Also, when there is a need for transition, it communicates with the Router.

# Pods

### Alamofire
Alamofire is an HTTP networking library written in Swift.
### AlamofireImage
AlamofireImage is an image component library for Alamofire.

##  Version
Current Version ```1.0```

## Developed By
Taimur Mushtaq.

[url1]: <https://developer.marvel.com>
[url2]: <https://developer.marvel.com/documentation/authorization>
