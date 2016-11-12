//
//  ViewController.swift
//  MenuMate
//
//  Created by Jack Cardwell on 11/6/16.
//  Copyright © 2016 HarmonCardwell. All rights reserved.
//

import UIKit
import ConversationV1
import RestKit
import SwiftCloudant

//the class for the main view and all its components
class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: Properties
    @IBOutlet var searchField: UITextField!
    
    var meals: [String] = []
    @IBOutlet var resultsText: UITextView!

    var query: String = ""      //the string of the query, initially null
    let workspaceID = "d6bc02c1-c3d6-4876-a43d-87a28fd6b75c";
    let conversation = Conversation(username: "b59c37bb-15e4-426e-8ce8-091744acd484", password: "8HqlYHFNOU2o", version: "2016-11-10");
    
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
        
        switch textField{
            
        case searchField:
            if (searchField.text != nil){
                query=searchField.text!
                converse()
                self.resultsText.text=self.toPrint
                self.resultsText.setNeedsDisplay()
                print(query)
            }
        default:
            break
       
        }
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 0;
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
//        return meals.count;
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "meal", for: indexPath as IndexPath) as! Meal
//        cell.setLabel(text: meals[indexPath.row])
//        return cell
//    }
    
    //a function that defines the interaction of the query with the Watson conversation service
    func converse(){
        //check to see whether or not the user has or hasn't entered text to send to Watson
        
        if (self.query.isEmpty==false){
            
            //continue the existing conversation with the   Watson agent
            let text = self.query
            let failure = { (error: Error) in print(error) }
            
            var context:Context?;
            var toPrint:[String]=[]
            
            let request = MessageRequest(text: text, context: context)
            conversation.message(withWorkspace: workspaceID, request: request, failure: failure, success:{ response in
                print(response.json)
                
                var station:String="";
                var day:String="";
                var meal:String="";
                
                //handle the entities
                for entity in response.entities {
                    if (entity.entity=="station"){
                        station=entity.value
                    }
                    else if (entity.entity=="day"){
                        day=entity.value
                    }
                }
                for intent in response.intents{
                    meal=intent.intent
                }
                
                //query the database
                let cloudantURL = URL(string:"https://0fc1924a-e31c-46ad-ba50-13fc5400577e-bluemix.cloudant.com")!
                let client = CouchDBClient(url:cloudantURL, username:"0fc1924a-e31c-46ad-ba50-13fc5400577e-bluemix", password:"9f4054a1e8f0c1dd4ddadc7ed61d234eb9a463c95a86084ba8eb7b22151caaae")
                let dbName = "fooddata"
                
                let find = FindDocumentsOperation(selector: ["day":day, "meal":meal,"station":station], databaseName: dbName, fields: ["items"], documentFoundHandler: {(dict) in
                    
                    print("COMING HERE>>>>>>>>>>>>>>>>>>>>")
//                    print(dict.debugDescription)
//                    for current in dict["items"] as! [String]{
//                        print(current)
//                    }
//                    
//                    toPrint.append(contentsOf: (dict["items"] as! [String]))
                })
               
                
                client.add(operation: find)
                context = response.context
            })
            self.toPrint=toPrint.joined(separator: ",")
        }
    }
}

