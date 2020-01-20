# Validator

Validator is an app to check if e-mail addresses are disposable (e.g. <a href="https://temp-mail.org/">https://temp-mail.org/</a>) using the validation API at <a href="https://www.validator.pizza/">https://www.validator.pizza/</a> . Here I have explored iOS development with Objective-C for the first time since university. The most exciting feature is the scan feature with the power of the Vision and AVFoundation frameworks; the ability exists to scan e-mail address on paper or screen. The ML model is exchangeable for a more accurate one using Core ML. As it goes with e-mail address validation, it cannot be 100% accurate as many e-mail addresses will not exist, but the mail server for the domain will.

Technologies and concepts explored:

* Delegate pattern
* UITableView
* NSFetchedResultsController
* NSPersistentContainer

API's and frameworks in use:

* API: <a href="https://www.validator.pizza/">https://www.validator.pizza/</a>
* Foundation
* UIKit
* AVFoundation
* Vision
* Core Data