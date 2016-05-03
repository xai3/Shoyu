# Shoyu

[![Pod Version](http://img.shields.io/cocoapods/v/Shoyu.svg?style=flat)](http://cocoadocs.org/docsets/Shoyu/)
[![Pod Platform](http://img.shields.io/cocoapods/p/Shoyu.svg?style=flat)](http://cocoadocs.org/docsets/Shoyu/)
[![Pod License](http://img.shields.io/cocoapods/l/Shoyu.svg?style=flat)](http://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/yukiasai/Shoyu.svg?branch=master)](https://travis-ci.org/yukiasai/Shoyu)


**Shoyu** is a library written in Swift to represent UITableView data structures.

Shoyu means Soy Sauce in Japanese.

## Usage

### Create single section and single row

Use `createSection` and `createRow`.

``` swift
tableView.source = Source() { source in
    
    // Create section
    source.createSection { section in
        
        // Create row
        section.createRow { row in
            
            // Setting reuse identifier
            row.reuseIdentifier = "Cell"
            
            // Setting fixed height.
            row.height = 52
            
            // Configuring handler for cell.
            row.configureCell = { cell, _ in
                cell.textLabel?.text = "row 1"
            }
        }
    }
}
```

if `ClassName` and `ReuseIdentifier` specified in Storyboard are the same, you don't need to specify the reuseIdentifier.

### Create rows for corresponds to the array

Use `createRows`.

``` swift
let members = [
    Member(firstName: "John", lastName: "Paterson"),
    Member(firstName: "Matt", lastName: "Gray"),
    Member(firstName: "Jennifer", lastName: "Hart"),
    Member(firstName: "Katherine", lastName: "Nash"),
    Member(firstName: "Diane", lastName: "Nash"),
]

tableView.source = Source() { source in
    source.createSection { section in
        section.createRows(members) { member, row in
            row.height = 52
            row.configureCell = { cell, _ in
                cell.textLabel?.text = member.fullName
            }
        }
    }
}
```

### Create section header and section footer

Use `createHeader` and `createFooter`.

``` swift
tableView.source = Source() { source in
   source.createSection { section in
        
        // Create header.
        section.createHeader { header in
            // Setting title.
            header.title = "Header"
            
            header.height = 22
            header.configureView = { view, _ in
                view.backgroundColor = UIColor.lightGrayColor()
            }
        }
        
        // Create footer.
        section.createFooter { footer in
          ...
        }
    }
}
```

## Generics

`Section` and `Row` is compatible with generics.

### Section

``` swift
public class Section<HeaderType: UIView, FooterType: UIView>: SectionType {
  ...
}
```

### Row

``` swift
public class Row<CellType: UITableViewCell>: RowType {
  ...
}
```

`cell` in the arguments of `configureCell` is the type specified in the generics.
Section header and section footer are also similar.

``` swift
// Create generic row.
section.createRows(members) { (member, row: Row<MemberTableViewCell>) in
    row.configureCell = { cell, _ in
        // cell type is MemberTableViewCell.
        cell.nameLabel.text = member.fullName
    }
}
```

## Row's delegate

`Row` has some delegate methods.

```
section.createRow { row in
    
    // Configuring handler for height.
    row.heightFor = { _ -> CGFloat? in
        return 52
    }
    
    // Configuring handler for cell.
    row.configureCell = { cell, _ in
        cell.textLabel?.text = "row"
    }
    
    // Event handler for when cell is selected.
    row.didSelect = { _ in
        print("row is selected.")
    }
}
```

### Supported delegate methods

* configureCell
* heightFor
* canRemove
* canMove
* canMoveTo
* didSelect
* didDeselect
* willDisplayCell
* didEndDisplayCell
* willRemove
* didRemove

## License

Shoyu is released under the MIT license. See LICENSE for details.
