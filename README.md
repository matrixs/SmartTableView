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

Use by including the follwing import:

```Swift
var dataSource = Array<AnyClass>()
yourTableView.registerClass(SmartTestCell.self, dataSource: dataSource, delegate: self)
... //data manipulation
dataSource.append(/some data/)
yourTableView.updateDataSource(dataSource)
[yourTableView reloadData];
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

Pop is released under a MIT License. See LICENSE file for details.
