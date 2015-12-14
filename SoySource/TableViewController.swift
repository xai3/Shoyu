//
//  TableViewController.swift
//  SoySource
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: TableView!
    
    let members = [
        Member(firstName: "N", lastName: "Takahiro"),
        Member(firstName: "H", lastName: "Naoki"),
        Member(firstName: "K", lastName: "Kotaro"),
        Member(firstName: "A", lastName: "Yuki"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.soySource = SoySource().createSection { (section: PlainSection) in
            section.createHeader { header in
                header.reuseIdentifier = "Header"
                header.height = 32
                header.configureView = { view, _ in
                    view.backgroundColor = UIColor.blueColor()
                }
            }
            section.createFooter { footer in
                footer.createView = { _ in
                    let view = UIView()
                    view.backgroundColor = UIColor.orangeColor()
                    return view
                }
                footer.height = 52
            }
            section.createRows(members) { (member: Member, row: Row<DefaultTableViewCell>) in
                row.height = 52
                row.configureCell = configureMemberCell(member)
                row.didSelect = didSelectMember(member)
            }
            section.createRows(5) { (index: UInt, row: Row<DefaultTableViewCell>) -> Void in
                row.heightFor = { _ -> CGFloat? in
                    return 44
                }
                row.configureCell = configureCountCell(index)
            }
        }
        tableView.reloadData()
    }
    
    private func configureMemberCell<T: DefaultTableViewCell>(member: Member) -> (T, NSIndexPath) -> Void {
        return { cell, _ in
            cell.setupWith(DefaultTableViewCellModel(name: member))
        }
    }
    
    private func didSelectMember(member: Member) -> NSIndexPath -> Void {
        return { [weak self] indexPath in
            self?.memberSelected(member)
        }
    }
    
    private func configureCountCell<T: DefaultTableViewCell>(index: UInt) -> (T, NSIndexPath) -> Void {
        return { cell, _ in
            cell.nameLabel.text = String(index)
        }
    }
    
    private func memberSelected(member: Member) {
        print("Member selected: " + member.fullName)
    }
    
    deinit {
        print("TableViewController deinit")
    }

}

class DefaultTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    
    func setupWith(viewModel: DefaultTableViewCellModel) {
        nameLabel.text = viewModel.fullName
    }
    
    deinit {
        print("DefaultTableViewCellModel deinit")
    }
}

struct DefaultTableViewCellModel {
    var name: NameProtocol
    
    var fullName: String {
        return name.fullName
    }
}

class TableView: UITableView {
    
    deinit {
        print("TableView deinit")
    }
}

protocol NameProtocol {
    var firstName: String { get }
    var lastName: String { get }
    var fullName: String { get }
}

struct Member: NameProtocol {
    var firstName: String
    var lastName: String
    
    var fullName: String {
        return lastName + " " + firstName
    }
}
