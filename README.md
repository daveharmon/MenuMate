# MenuMate
A Watson-powered mobile application for aiding Dartmouth students in on-campus meal prep.

Description
---------------------------
MenuMate is a Watson-powered iOS application, written in Swift 3, that helps Dartmouth students navigate the Class of 1953 Commons ("FoCo"). MenuMate relies on a IBM Conversation Service instance and a Cloudant CouchDB instance, both run in IBM Bluemix. The app is currently deployed for iOS 10.0 for use on iPhone exclusively. Additionally, this application only has access to the FoCo menus for Monday, Tuesday, Wednesday, and Friday. 

Inputs
---------------------------
This system is run on iPhone. The user interacts with a search bar that is at the top of the screen, either directly through text input or through Siri Voice-to-Text. The input must contain a meal (Breakfast, Lunch, Dinner) a day and FoCo station.

Outputs
---------------------------
Upon a successful query, the screen updates with a list of food at the desired station. Upon failure, the screen updates with a "Document Not Found" message.

Third-Party Reliance
---------------------------

1.	iOS Watson SDK
	https://github.com/watson-developer-cloud/ios-sdk

2.	iOS Cloudant CouchDB SDK
	https://github.com/cloudant/swift-cloudant

3.	Dartmouth Dining Service Menus

