//
//  UISearchWithFilterView.swift
//  UISearchWithFilters
//
//  Created by Pulkit Rohilla on 01/08/17.
//  Copyright © 2017 PulkitRohilla. All rights reserved.
//

import UIKit

protocol UISearchWithFilterViewDelegate{
    
    func searchWithFilterViewCancelButtonClicked(searchView : UISearchWithFilterView)
    func searchWithFilterViewTextDidBeginEditing(searchView : UISearchWithFilterView)
    func searchWithFilterViewTextDidChange(searchView : UISearchWithFilterView, searchText : String)
    
    func numberOfFilters(in searchView : UISearchWithFilterView) -> Int
}

class UISearchWithFilterView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    var delegate : UISearchWithFilterViewDelegate!
    
    var isActive : Bool = false
    var isFilterVisible : Bool = false
    var isConstraintAdded : Bool = false
    
    var filterRowHeight : CGFloat = 44
    var numberOfFilters : Int = 0
    
    var containerView : UIView!
    var searchView : UIView!
    var filterView : UIView!
    
    var filterViewHeightConstraint : NSLayoutConstraint!
    
    var tblView : UITableView!
    
    override func updateConstraints() {
        
        super.updateConstraints()
        
        self.addConstraints()
    
        if isFilterVisible {
            
            filterViewHeightConstraint?.constant = CGFloat(numberOfFilters)*filterRowHeight
        }
        else
        {
            filterViewHeightConstraint?.constant = 0
        }
    }
    
    override init(frame: CGRect) {
    
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.cornerRadius = 5
        self.alpha = 0
        
        addContainterView()
        addSearchView()
        addFilterView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfFilters
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Filter \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return filterRowHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Select")
    }
    
    //MARK: OtherMethods
    
    func show(){
        
        if self.delegate != nil {
            
            numberOfFilters = self.delegate.numberOfFilters(in: self)
        }
        
        isActive = true
        isFilterVisible = true

        self.tblView.frame.size.height = CGFloat(100)

        updateConstraints()

        UIView.animate(withDuration: 0.5) {
            
            self.alpha = 1
        }
    }
    
    func addContainterView(){
    
        containerView = UIView.init()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 5

        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 5
        
        self.addSubview(containerView)
    }
    
    func addSearchView(){
     
        searchView = UIView.init()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        let lblSearchIcon = UILabel.init()
        lblSearchIcon.text = ""
        lblSearchIcon.font = UIFont.init(name: "FontAwesome", size: 16.0)
        lblSearchIcon.translatesAutoresizingMaskIntoConstraints = false
        lblSearchIcon.textAlignment = .center
        lblSearchIcon.textColor = UIColor.lightGray
        
        let txtFieldSearch = UITextField.init()
        txtFieldSearch.placeholder = "Search"
        txtFieldSearch.translatesAutoresizingMaskIntoConstraints = false
        txtFieldSearch.delegate = self
        txtFieldSearch.tintColor = UIColor.black
        txtFieldSearch.returnKeyType = .search
        txtFieldSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtFieldSearch.font = UIFont.systemFont(ofSize: 16)
        
        let btnCancel = UIButton.init(type: .system)
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.titleLabel?.font = UIFont.init(name: "FontAwesome", size: 22)
        btnCancel.setTitleColor(UIColor.darkGray, for: .normal)
        btnCancel.setTitle("", for: .normal)
        btnCancel.addTarget(self, action: #selector(actionCancel), for: .touchUpInside)

        let btnToggleFilters = UIButton.init(type: .system)
        btnToggleFilters.translatesAutoresizingMaskIntoConstraints = false
        btnToggleFilters.titleLabel?.font = UIFont.init(name: "FontAwesome", size: 22)
        btnToggleFilters.setTitleColor(UIColor.darkGray, for: .normal)
        btnToggleFilters.setTitle("", for: .normal)
        btnToggleFilters.addTarget(self, action: #selector(actionToggleFilterView), for: .touchUpInside)

        searchView.addSubview(lblSearchIcon)
        searchView.addSubview(txtFieldSearch)
        searchView.addSubview(btnCancel)
        searchView.addSubview(btnToggleFilters)
        
        let viewsDict = ["lblSearchIcon":lblSearchIcon,
                         "txtFieldSearch":txtFieldSearch,
                         "btnCancel":btnCancel,
                         "btnToggleFilters":btnToggleFilters]
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblSearchIcon(20)]-8-[txtFieldSearch]-8-[btnToggleFilters(35)]-8-[btnCancel(35)]-0-|",
                                                                   options: .alignAllCenterY,
                                                                   metrics: nil,
                                                                   views: viewsDict)
        
        searchView.addConstraints(horizontalConstraints)

        let centreY = NSLayoutConstraint.init(item: lblSearchIcon,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: searchView,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0)
        
        searchView.addConstraint(centreY)
        
        containerView.addSubview(searchView)
    }
    
    func addFilterView(){

        filterView = UIView.init()
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.clipsToBounds = true
        filterView.layer.cornerRadius = 5

        tblView = UITableView.init()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin, .flexibleHeight, .flexibleWidth]
        tblView.bounces = false;
        tblView.backgroundColor = UIColor.clear;
        tblView.separatorStyle = .none;
        tblView.showsHorizontalScrollIndicator = false;
        tblView.showsVerticalScrollIndicator = false;

        filterView.addSubview(tblView)

        let viewsDict : [String : Any] = ["tblView":tblView]

        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tblView]-0-|",
                                                                   options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: viewsDict)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tblView]-0-|",
                                                                   options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: viewsDict)
        
        filterView.addConstraints(horizontalConstraints)
        filterView.addConstraints(verticalConstraints)

        containerView.addSubview(filterView)
    }
    
    func addConstraints(){
        
        if !isConstraintAdded {
            
            isConstraintAdded = true
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view]-|",
                                                                       options: .alignAllCenterY,
                                                                       metrics: nil,
                                                                       views: ["view" : self])
            
            
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[view]",
                                                                     options: .alignAllCenterX,
                                                                     metrics: nil,
                                                                     views: ["view" : self])
            
            self.superview?.addConstraints(horizontalConstraints)
            self.superview?.addConstraints(verticalConstraints)
            
            //Subview Constraints
            let containerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[containerView]-0-|",
                                                                       options: .alignAllCenterY,
                                                                       metrics: nil,
                                                                       views: ["containerView" : containerView])
            
            
            let containerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[containerView]-0-|",
                                                                     options: .alignAllCenterX,
                                                                     metrics: nil,
                                                                     views: ["containerView" : containerView])
            
            self.addConstraints(containerHorizontalConstraints)
            self.addConstraints(containerVerticalConstraints)
            
         
            let subviewsDict : [String : UIView] = ["searchView":searchView,
                                "filterView":filterView]
            
            let searchViewHeightConstraint = NSLayoutConstraint.init(item: searchView,
                                                                 attribute: .height,
                                                                 relatedBy: .equal,
                                                                 toItem: nil,
                                                                 attribute: NSLayoutConstraint.Attribute(rawValue: 0)!,
                                                                 multiplier: 1.0,
                                                                 constant: 40)
            
            self.addConstraint(searchViewHeightConstraint)
            
            let searchViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[searchView]-0-|",
                                                                                 options: .alignAllCenterY,
                                                                                 metrics: nil,
                                                                                 views: subviewsDict)
            
            let searchViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[searchView]-0-[filterView]-0-|",
                                                                               options: .alignAllCenterX,
                                                                               metrics: nil,
                                                                               views: subviewsDict)
            
            containerView.addConstraints(searchViewHorizontalConstraints)
            containerView.addConstraints(searchViewVerticalConstraints)
            
            let filterHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[filterView]-0-|",
                                                                                 options: .alignAllCenterY,
                                                                                 metrics: nil,
                                                                                 views: subviewsDict)

            containerView.addConstraints(filterHorizontalConstraints)

            filterViewHeightConstraint = NSLayoutConstraint.init(item: filterView,
                                                                 attribute: .height,
                                                                 relatedBy: .equal,
                                                                 toItem: nil,
                                                                 attribute: NSLayoutConstraint.Attribute(rawValue: 0)!,
                                                                 multiplier: 1.0,
                                                                 constant: 0)
            
            containerView.addConstraint(filterViewHeightConstraint!)
            
        }
    }
    
    //MAR: - UIButton Actions
    
    @objc func actionCancel(){
        
        self.isActive = false
        self.isConstraintAdded = false
        
        containerView.removeConstraint(filterViewHeightConstraint)
        self.alpha = 0
        self.removeFromSuperview()
        
        delegate.searchWithFilterViewCancelButtonClicked(searchView: self)
    }
    
    @objc func actionToggleFilterView(){

        self.isFilterVisible = !self.isFilterVisible
        self.updateConstraints()
        
        UIView.animate(withDuration: 0.3) {
            
            self.superview?.layoutIfNeeded()
        }
    }
    
    //MARK: UITextField Delegate
    
    @objc func textFieldDidChange(textField : UITextField){
        
        delegate.searchWithFilterViewTextDidChange(searchView: self, searchText: textField.text!)
    }

}
