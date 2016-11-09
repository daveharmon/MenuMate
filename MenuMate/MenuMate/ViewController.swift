//
//  ViewController.swift
//  MenuMate
//
//  Created by Jack Cardwell on 11/6/16.
//  Copyright © 2016 HarmonCardwell. All rights reserved.
//

import UIKit
import ConversationV1
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet var searchField: UITextField!

    var query: String=""      //the string of the query
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        searchField.delegate=self;
        
        
        //code for the IBM Bluemix Conversation Service
        let username = "your-username-here"
        let password = "your-password-here"
        let version = "YYYY-MM-DD" // use today's date for the most recent version
        let conversation = Conversation(username: username, password: password, version: version)
        
        let workspaceID = "your-workspace-id-here"
        let failure = { (error: Error) in print(error) }
        var context: Context? // save context to continue conversation
        conversation.message(withWorkspace: workspaceID, failure: failure) { response in
            print(response.output.text)
            context = response.context
        }
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
                print(query)
            }
        default:
            break
       
        }
    }

}

