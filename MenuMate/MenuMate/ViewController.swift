//
//  ViewController.swift
//  MenuMate
//
//  Created by Jack Cardwell on 11/6/16.
//  Copyright © 2016 HarmonCardwell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    //MARK: Properties
    @IBOutlet weak var queryBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setup delegates
        queryBar.delegate = self;
    }
    
    //a method that gathers the text from the search field when the user finishes editing
    func searchBar(_ searchBar: UISearchBar, searchBarDidEndEditing searchText: String) {
        
        print(searchText)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

