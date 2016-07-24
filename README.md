# SmartTableView

SmartTableView is an extension for UITableView and UITableViewCell. It's aimed to calculate cells' height which are layout based on AutoLayout automatically for you. 
It caches cell height during calculation process for optimization, and making it work is very easy.

## Installation

SmartTableView is available on [CocoaPods](https://cocoapods.org). Just add the following to you project Podfile:

```ruby
pod 'SmartTableView', '~>0.1.0'
```

Bugs are first fixed in master and then made available via a designated release. If you tend to live on the bleeding edge, you can use Pop from 
master with the following Podfile entry:

```ruby
pod 'SmartTableView', :git=>'https://github.com/matrixs/SmartTableView.git'
```

## Usage

#Situation 1: TableView only contains a kind of UITableViewCell type:

```Swift
var dataSource = Array<AnyClass>()
yourTableView.registerClass(SmartTestCell.self, dataSource: dataSource, delegate: self)
... //data manipulation
dataSource.append(/some data/)
yourTableView.updateDataSource(dataSource)
[yourTableView reloadData];
```
#Situation 2: TableView contains multiple kinds of UITableViewCell type:

```Swift
var dataSource = Array<AnyClass>()
tableView.registerClass(SmartTestCell.self, dataSource: dataSource, delegate: self, identifier: "CELL1")
tableView.registerClass(SmartTestCell2.self, dataSource: dataSource, delegate: self, identifier: "CELL2")
... //data manipulation
dataSource.append(/some data/)
yourTableView.updateDataSource(dataSource)
[yourTableView reloadData];
```
Apart from this, you need to implement another method showed below: 
```Swift
func identifierForRow(row: NSNumber) -> String {
    let dict = dataSource[row.integerValue] as! NSDictionary
    if dict["type"]?.integerValue == 1 {
        return "CELL1"
    } else {
        return "CELL2"
    }
}
```

And then in YourCustomCell class, you need implement below method:

```
override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //use autolayout to layout you content's views
        //TODO
}

override func fillData(data: NSObject) {
    //TODO
}

```
## Contributing
See the CONTRIBUTING file for how to help out.

## License

SmartTableView is released under a MIT License. See LICENSE file for details.
