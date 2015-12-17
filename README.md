# Shoyu

**Shoyu** is a library written in Swift to represent UITableView data structures.

## Usege

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

`cell` is an argument of `configureCell` is the type specified in the generics.
section header and section footer are also similar.

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

`Row` has some delegate methods. `configureCell`, `heightFor`, `didSelect` and so on.

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

## License

Copyright (c) 2015 yukiasai.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
