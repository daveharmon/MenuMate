//
//  ViewController.swift
//  MenuMate
//
//  Created by Jack Cardwell on 11/6/16.
//  Copyright © 2016 HarmonCardwell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var queryBar: UISearchBar!
    
    var textFieldValue="";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //handle the search bar actions here
        if ((queryBar.delegate?.searchBarTextDidEndEditing) != nil){
            
            //get the text value from the field
            textFieldValue=(queryBar.delegate?.description)!
        }
        
        print(textFieldValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

