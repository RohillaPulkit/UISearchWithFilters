//
//  ViewController.swift
//  UISearchWithFilters
//
//  Created by Pulkit Rohilla on 01/08/17.
//  Copyright © 2017 PulkitRohilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchWithFilterViewDelegate {

    var searchView : UISearchWithFilterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func searchTapped(_ sender: Any) {
        
        self.navigationController?.navigationBar.addSubview(searchView)
        
        searchView.show()
        initNavigationBar()
    }
    
    //MARK: UISearchWithFilterViewDelegate

    func searchWithFilterViewTextDidBeginEditing(searchView: UISearchWithFilterView) {
        
        
    }
    
    func searchWithFilterViewCancelButtonClicked(searchView: UISearchWithFilterView) {
    
        initNavigationBar()
    }
    
    func searchWithFilterViewTextDidChange(searchView: UISearchWithFilterView, searchText: String) {
        
    }
    
    func numberOfFilters(in searchView: UISearchWithFilterView) -> Int {
    
        return 7
    }
    
    //MARK: OtherMethods

    func initUI(){
        
        searchView = UISearchWithFilterView.init()
        searchView.delegate = self
        
        initNavigationBar()
    }
    
    func initNavigationBar(){
        
        if searchView.isActive {
            
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.title = nil
        }
        else{
            
            let barBtnSearch : UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(searchTapped(_:)))
            barBtnSearch.tintColor = UIColor.white
            
            self.navigationItem.rightBarButtonItem = barBtnSearch
            self.navigationItem.title = "Search"
        }


    }
}

