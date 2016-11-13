//
//  ViewController.swift
//  MenuMate
//
//  Created by Jack Cardwell on 11/6/16.
//  Copyright © 2016 HarmonCardwell. All rights reserved.
//

//import the necessary libraries and packages
import UIKit
import ConversationV1
import RestKit
import SwiftCloudant

//the class for the main view and all its components
class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: Properties
    @IBOutlet var searchField: UITextField!
    
    //global variables that are used to interact with the database and the view controller
    var meals: [String] = []
    var lock: Bool = true
    @IBOutlet var resultsText: UITextView!
    
    
    var query: String = ""      //the string of the query, initially null
    
    //setup the IBM Conversation Service
    let workspaceID = "d6bc02c1-c3d6-4876-a43d-87a28fd6b75c";
    let conversation = Conversation(username: "b59c37bb-15e4-426e-8ce8-091744acd484", password: "8HqlYHFNOU2o", version: "2016-11-10");
    
    
    //the string that will eventually fill the Text View
    var toPrint:String=""
    
    override func viewDidLoad() {
        //load the view
        super.viewDidLoad()
        
        //link the search bar to the code
        searchField.delegate=self;
        resultsText.delegate=self;
        
        let failure = { (error: Error) in print(error) }
        
        //initialize and interact with the conversation serice
        
        var context:Context?;
        conversation.message(withWorkspace: workspaceID, failure: failure, success: { response in
            print("here")
            context = response.context
        })
        //self.mealTable.register(Meal.self, forCellReuseIdentifier: "meal")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text=nil;
        return true
    }
    //MARK: UITextFieldDelegate
    //a function that resigns the first responder status when the keyboard is escaped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //a function that updates the query text when the return key is pressed
    func textFieldShouldEndEditing(_ textField: UITextField){
        
        //check to see that the text bar being edited is the search bar
        switch textField{
            
        case searchField:
            
            //if the user has made a non-nil query
            if (searchField.text != nil){
                
                query=searchField.text!
                
                //call on converse to interact with the database
                converse()
                
                //a spin lock that ensures correct timing with the asynchrnous function converse()
                while (self.lock == true) {
                    print("spin");
                }
                
                //otherwise set the text view to the current error message
                if (self.meals == []) {
                    self.resultsText.text = self.toPrint
                }
                
                //if there are meals to display
                else {
                    self.resultsText.text=self.meals.joined(separator: ", \n")
                }
                
                //update the text view
                self.resultsText.setNeedsDisplay()
                
                //lock the thread until the app succesfully interacts with the database
                self.lock = true
                
                
                print(query)    //print the query to the console...mainly for debugging
            }
        default:
            break
       
        }
    }
    
    //a function that defines the interaction of the query with the Watson conversation service
    func converse(){
        //check to see whether or not the user has or hasn't entered text to send to Watson
        
        if (self.query.isEmpty==false){
            
            //continue the existing conversation with the   Watson agent
            let text = self.query
            
            //setup the message with Watson Conversation Service
            let failure = { (error: Error) in print(error) }
            
            var context:Context?;
            
            let request = MessageRequest(text: text, context: context)
            conversation.message(withWorkspace: workspaceID, request: request, failure: failure, success:{ response in
                //print(response.json)  //used for debugging
                
                //initialize the fields that we are looking for
                var station:String="";
                var day:String="";
                var meal:String="";
                
                
                //handle the case where Watson doesn't pick up on the keywords
                if (response.entities.count != 2 && response.intents.count != 1){
                    self.toPrint = "Watson could not find your input"
                    self.lock = false   //unlock the thread
                    return
                }
                
                //handle the entities
                for entity in response.entities {
                    if (entity.entity=="station"){
                        station=entity.value
                    }
                    else if (entity.entity=="day"){
                        day=entity.value
                    }
                }
                
                //hadle the intent of the user...which meal they are interested in
                for intent in response.intents{
                    meal=intent.intent
                }
                
                //query the database
                let cloudantURL = URL(string:"https://0fc1924a-e31c-46ad-ba50-13fc5400577e-bluemix.cloudant.com")!
                let client = CouchDBClient(url:cloudantURL, username:"0fc1924a-e31c-46ad-ba50-13fc5400577e-bluemix", password:"9f4054a1e8f0c1dd4ddadc7ed61d234eb9a463c95a86084ba8eb7b22151caaae")
                let dbName = "fooddata"
                let find = FindDocumentsOperation(selector: ["day":day, "meal":meal,"station":station], databaseName: dbName, fields: ["items"], documentFoundHandler: {(dict) in
                    
                    //save the array of Strings to a global variable
                    self.meals = dict["items"] as! [String]
                    self.lock = false;  //unlock the thread because the query was succesful
                
                }) {(response, httpInfo, error) in
                    
                    //handles errors from the database, such as losing connections
                    if let error = error {
                        self.meals = []
                        self.toPrint = error.localizedDescription
                        self.lock = false;
                    }
                    
                    //if the query was succesful, but no documents were found
                    else if (self.lock != false) {
                        self.meals = []
                        self.toPrint = "Document not found"
                        self.lock = false;
                        print("success")
                    }
                }
                
                //update the attributes of the Watson Conversation
                client.add(operation: find)
                context = response.context
            })
        }
    }
}

