# AZSearchView
A search controller with auto-complete suggestions written in Swift 3.

<img src="screenshots/gif1.gif"  height="400" />

## Installation

```bash
pod 'AZSearchView'
```

## Usage

Create a property of type ```AZSearchViewController``` and a String array to hold the data.
```swift
    var searchController: AZSearchViewController!
    var resultArray:[String] = []
```

Implement the delegate and data source protocols:
```swift
extension ViewController: AZSearchViewDelegate{
    
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
        searchView.dismiss(animated: true, completion: {
            self.pushWithTitle(text: text)
        })
    }
}

extension ViewController: AZSearchViewDataSource{
    
    func results() -> [String] {
        return self.resultArray
    }
}
```

Now initialize the controller object:
```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = AZSearchViewController()
        self.searchController.delegate = self
        self.searchController.dataSource = self
    }
```

And finally present when needed:

```swift
searchController.show(in: self)
```

## Customizations

Default Vs. Customized

<img src="screenshots/default.png"  height="400" />
<img src="screenshots/customized.png"  height="400" />

```swift
    self.searchController.searchBarPlaceHolder = "Search Top Artists"
    self.searchController.navigationBarClosure = { bar in
        //The navigation bar's background color
        bar.barTintColor = #colorLiteral(red: 0.9019607843, green: 0.2235294118, blue: 0.4, alpha: 1)

        //The tint color of the navigation bar
        bar.tintColor = UIColor.lightGray
    }
    self.searchController.searchBarBackgroundColor = .white
    self.searchController.statusBarStyle = .lightContent
    self.searchController.keyboardAppearnce = .dark
    let item = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(ViewController.close(sender:)))
    item.tintColor = .white
    self.searchController.navigationItem.rightBarButtonItem = item
```

And by implementing these optional delegate/datasource methods:

```swift
extension ViewController: AZSearchViewDelegate{
    func searchView(_ searchView: AZSearchViewController, tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
```

```swift
extension ViewController: AZSearchViewDataSource{

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
        }    
        remove.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        return [remove]
    }
} 
```

