//
//  ViewController.swift
//  MenuMate
//
//  Created by Jack Cardwell on 11/6/16.
//  Copyright © 2016 HarmonCardwell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet var searchField: UITextField!

    var query=""      //the string of the query
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        searchField.delegate=self;
        //setup the default values of the text field
        searchField.clearsOnBeginEditing=true;
        searchField.clearsOnInsertion=true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    //a function that resigns the first responder status when the keyboard is escaped
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        switch textField {
        case searchField:
            searchField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    //a function that updates the query text when the return key is pressed
    func textFieldShouldEndEditing(textField: UITextField) {
        
        switch textField{
            
        case searchField:
            query = textField.text!
            print(query)
            
        default:
            break
        }
    }

}

