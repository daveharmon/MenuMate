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
import AVFoundation

//the class for the main view and all its components
class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet var searchField: UITextField!

    var query: String = ""      //the string of the query, initially null
//    let username = "b59c37bb-15e4-426e-8ce8-091744acd484";
//    let password = "8HqlYHFNOU2o";
//    let version = "2016-11-10";
    let workspaceID = "d6bc02c1-c3d6-4876-a43d-87a28fd6b75c";
    let conversation = Conversation(username: "b59c37bb-15e4-426e-8ce8-091744acd484", password: "8HqlYHFNOU2o", version: "2016-11-10");
    
//    
//    required init?(coder:NSCoder){
//        
//        
//        //code for the IBM Bluemix Conversation Service
//        self.username = "b59c37bb-15e4-426e-8ce8-091744acd484"
//        self.password = "8HqlYHFNOU2o"
//        self.version = "2016-11-10" // use today's date for the most recent version
//        self.conversation = Conversation(username: username, password: password, version: version)
//        
//        //initialize and interact with the conversation serice
//        self.workspaceID = "d6bc02c1-c3d6-4876-a43d-87a28fd6b75c"
//
//        super.init(coder: coder)
//    }

//    override func awakeFromNib() {
//        searchField.text = "Enter a Query!"
//    }
    
    override func viewDidLoad() {
        //load the view
        super.viewDidLoad()
        
        //link the search bar to the code
        searchField.delegate=self;
        
        let failure = { (error: Error) in print(error) }
        
        //initialize and interact with the conversation serice
        var context:Context?;
        conversation.message(withWorkspace: workspaceID, failure: failure, success: { response in
            print("here")
            context = response.context
        })
        
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
                print(query)
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
            let failure = { (error: Error) in print(error) }
            var context:Context?;
            let request = MessageRequest(text: text, context: context)
            conversation.message(withWorkspace: workspaceID, request: request, failure: failure, success:{ response in
                print(response.output.text)
                context = response.context
            })
        }
    }
}

