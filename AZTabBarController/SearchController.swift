//
//  SearchController.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 13/04/2017.
//  Copyright © 2017 Crofis. All rights reserved.
//

import Foundation
import UIKit
import AZSearchView

class SearchController: UIViewController{
    
    class func instance()->UIViewController{
        let searchController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchController")
        let nav = UINavigationController(rootViewController: searchController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    var resultArray:[String] = []
    
    //The search controller
    var searchController:AZSearchViewController!
    
    @IBAction func click(_ sender: UIBarButtonItem) {
        //self.present(searchController, animated: true, completion: nil)
        searchController.show(in: currentTabBar!)
    }
    
    
    @objc func close(sender:AnyObject?){
        searchController.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init search controller
        self.searchController = AZSearchViewController()
        
        //add setup delegate and data source
        self.searchController.delegate = self
        self.searchController.dataSource = self
        
        /*
         preform optional customizations
         */
        
        //The search bar's placeholder text
        self.searchController.searchBarPlaceHolder = "Search Top Artists"
        
        
        self.searchController.navigationBarClosure = { bar in
            //The navigation bar's background color
            bar.barTintColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
            
            //The tint color of the navigation bar
            bar.tintColor = UIColor.lightGray
        }
        
        //The search bar's (text field) background color
        self.searchController.searchBarBackgroundColor = .white
        
        //The status bar's color (light or dark)
        self.searchController.statusBarStyle = .lightContent
        
        //Keyboard appearnce (dark,light or default)
        self.searchController.keyboardAppearnce = .dark
        
        //The tableview's seperator color
        self.searchController.separatorColor = .clear
        
        //Add bar button item on the navigation bar using the navigation item.
        let item = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(SearchController.close(sender:)))
        item.tintColor = .white
        self.searchController.navigationItem.rightBarButtonItem = item
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }
    
    
    ///this function is for demo purposes only
    func pushWithTitle(text: String){
        let controller = UIViewController()
        controller.title = text
        controller.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchController: AZSearchViewDelegate{
    
    
    func searchView(_ searchView: AZSearchViewController, didSearchForText text: String) {
        searchView.dismiss(animated: false, completion: nil)
    }
    
    func searchView(_ searchView: AZSearchViewController, didTextChangeTo text: String, textLength: Int) {
        self.resultArray.removeAll()
        
        if textLength > 3 {
            for i in 0..<arc4random_uniform(10)+1 {self.resultArray.append("\(text) \(i+1)")}
        }
        
        searchView.reloadData()
    }
    
    func searchView(_ searchView: AZSearchViewController, didSelectResultAt index: Int, text: String) {
        self.searchController.dismiss(animated: true, completion: {
            self.pushWithTitle(text: text)
        })
    }
    
    func searchView(_ searchView: AZSearchViewController, tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension SearchController: AZSearchViewDataSource{
    
    func statusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
    func results() -> [String] {
        return self.resultArray
    }
    
    func searchView(_ searchView: AZSearchViewController, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchView.cellIdentifier)
        cell?.textLabel?.text = self.resultArray[indexPath.row]
        cell?.imageView?.image = #imageLiteral(resourceName: "ic_history").withRenderingMode(.alwaysTemplate)
        cell?.imageView?.tintColor = UIColor.gray
        cell?.contentView.backgroundColor = .white
        return cell!
    }
    
    func searchView(_ searchView: AZSearchViewController, tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func searchView(_ searchView: AZSearchViewController, tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { action, index in
            self.resultArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //searchView.reloadData()
        }
        
        remove.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        
        
        return [remove]
    }
    
}
