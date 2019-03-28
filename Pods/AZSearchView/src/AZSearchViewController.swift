//
//  AZSearchViewController.swift
//  AZSearchViewController
//
//  Created by Antonio Zaitoun on 04/01/2017.
//  Copyright © 2017 Crofis. All rights reserved.
//

import Foundation
import UIKit


public class AZSearchViewController: UIViewController{
    
    ///The search bar
    fileprivate (set) open var searchBar:UISearchBar!
    
    ///Auto complete tableview
    fileprivate var tableView: UITableView!
    
    ///SearchView delegate
    open var delegate: AZSearchViewDelegate?
    
    ///SearchView data source
    open var dataSource: AZSearchViewDataSource?
    
    open var navigationBarClosure: ((UINavigationBar)->Void)?
    
    ///The search bar offset
    internal var searchBarOffset: UIOffset{
        get{
            return self.searchBar.searchFieldBackgroundPositionAdjustment
        }set{
            self.searchBar.searchFieldBackgroundPositionAdjustment = newValue
        }
    }
    
    ///Computed variable to set the search bar background color
    open var searchBarBackgroundColor: UIColor = AZSearchViewDefaults.searchBarColor{
        didSet{
            if searchBar != nil, let searchField = searchBar.value(forKey: "searchField"){
                (searchField as! UITextField).backgroundColor = searchBarBackgroundColor
            }
        }
    }
    
    open var keyboardAppearnce: UIKeyboardAppearance = .default {
        didSet{
            self.searchBar.keyboardAppearance = keyboardAppearnce
        }
    }
    
    
    ///The search bar place holder text
    open var searchBarPlaceHolder: String = "Search"{
        didSet{
            if (self.searchBar != nil){
                self.searchBar.placeholder = searchBarPlaceHolder
            }
            
        }
    }
    
    ///A var to change the status bar appearnce
    open var statusBarStyle: UIStatusBarStyle = .default{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    ///A var to change the separator color
    open var separatorColor: UIColor = UIColor.lightGray{
        didSet{
            self.tableView.separatorColor = separatorColor
        }
    }
    
    ///A var to modify the separator offset
    open var separatorInset: UIEdgeInsets = UIEdgeInsets.zero{
        didSet{
            self.tableView.separatorInset = separatorInset
        }
    }
    
    ///The cell reuse identifier
    private (set) open var cellIdentifier: String = AZSearchViewDefaults.reuseIdetentifer
    
    ///The cell reuse class
    private (set) open var cellClass: AnyClass = UITableViewCell.self
    
    //The preferred status bar style
    override public var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }
    
    ///Private var to assist viewDidAppear
    fileprivate var didAppear = false
    
    //MARK: - Init
    convenience init(){
        //let bundle = Bundle(for: AZSearchViewController.self)
        //self.init(nibName: AZSearchViewDefaults.nibName, bundle: bundle)
        self.init(nibName: nil, bundle: nil)
    }
    
    convenience init(cellReuseIdentifier cellId: String,cellReuseClass: AnyClass){
        self.init()
        self.cellIdentifier = cellId
        self.cellClass = cellReuseClass
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    deinit {
        //remove keyboard oberservers
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - UIViewController
    
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.searchBar.resignFirstResponder()
        self.delegate?.searchView(self, didDismissWithText: searchBar.text!)
        super.dismiss(animated: flag, completion: completion)
        
    }
    
    open func show(in controller: UIViewController,animated: Bool = true,completion: (()->Void)? = nil){
        let navgation = WrapperNavigationController(rootViewController: self)
        navgation.dataSource = self
        navgation.modalPresentationStyle = .overCurrentContext
        navgation.modalTransitionStyle = .crossDissolve
        navgation.modalPresentationCapturesStatusBarAppearance = true
        navigationBarClosure?(navgation.navigationBar)
        controller.present(navgation, animated: animated, completion: completion)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        //update view background
        self.view.backgroundColor = AZSearchViewDefaults.backgroundColor
        
        //setup tableview
        self.tableView.register(self.cellClass, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.tableFooterView = UIView()
        self.tableView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //setup search bar
        self.searchBar.placeholder = self.searchBarPlaceHolder
        
        if let searchField = searchBar.value(forKey: "searchField"){(searchField as! UITextField).backgroundColor = self.searchBarBackgroundColor}
        
        self.navigationItem.titleView = self.searchBar
        
        self.searchBar.delegate = self
        
        //setup background tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(AZSearchViewController.didTapBackground(sender:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        //add observers to listen to keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(AZSearchViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AZSearchViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //open keyboard
        self.searchBar.becomeFirstResponder()
    }
    
    
    fileprivate func setup(){
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationCapturesStatusBarAppearance = true
        self.searchBar = UISearchBar()
        self.tableView = UITableView()
        //if ((self.view) != nil){}
    }
    
    ///reloadData - refreshes the UITableView. If the data source function `results()` contains 0 index, the table view will be hidden.
    open func reloadData(){
        if (self.dataSource?.results().count ?? 0) > 0 {
            tableView.isHidden = false
        }else{
            tableView.isHidden = true
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Selectors
    
    @objc func didTapBackground(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let kbSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let kbDurationNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        animateToKeyboardHeight(kbHeight: kbSizeValue.cgRectValue.height, duration: kbDurationNumber.doubleValue)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let kbDurationNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        animateToKeyboardHeight(kbHeight: 0, duration: kbDurationNumber.doubleValue)
    }
    
    func animateToKeyboardHeight(kbHeight: CGFloat, duration: Double) {
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top, left: 0, bottom: kbHeight, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: tableView.contentInset.top, left: 0, bottom: kbHeight, right: 0)
    }
    
}

//MARK: - UIGestureRecognizerDelegate

extension AZSearchViewController: UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.tableView))!{
            return false
        }
        return true
    }
}

//MARK: - UITableViewDelegate

extension AZSearchViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.searchView(self, didSelectResultAt: indexPath.row, text: dataSource?.results()[indexPath.row] ?? "")
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.delegate?.searchView(self, tableView: tableView, editActionsForRowAtIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.delegate?.searchView(self, tableView: tableView, heightForRowAt: indexPath) ?? 0
    }
    
}

//MARK: - UITableViewDataSource

extension AZSearchViewController: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.results().count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.dataSource?.searchView(self,tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.dataSource?.searchView(self, tableView: tableView, canEditRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.dataSource?.searchView(self, tableView: tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
}

//MARK: - UISearchBarDelegate

extension AZSearchViewController: UISearchBarDelegate{
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.delegate?.searchView(self, didTextChangeTo: searchBar.text!, textLength: searchBar.text!.count)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.searchView(self, didSearchForText: searchBar.text!)
    }
}

extension AZSearchViewController: WrapperDataSource{
    func statusBar()-> UIStatusBarStyle{
        return self.dataSource?.statusBarStyle() ?? .default
    }
}

fileprivate protocol WrapperDataSource{
    func statusBar()-> UIStatusBarStyle
}

fileprivate class WrapperNavigationController: UINavigationController{
    open var dataSource: WrapperDataSource?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.dataSource?.statusBar() ?? .default
    }
}
