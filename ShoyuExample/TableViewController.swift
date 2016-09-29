//
//  TableViewController.swift
//  Shoyu
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
        tableView.source = Source().createSection { (section: Section<HeaderTableViewCell, FooterTableViewCell>) in
            section.createHeader { header in
                header.reuseIdentifier = "Header"
                header.height = 32
                header.configureView = { headerCell, _ in
                    headerCell.contentView.backgroundColor = UIColor.blue
                }
            }
            section.createFooter { footer in
                footer.createView = { [weak self] _ in
                    return self?.createViewForFooterCell()
                }
                footer.configureView = { footerCell, _ in
                    footerCell.contentView.backgroundColor = UIColor.orange
                }
                footer.titleFor = { _ -> String? in
                    return "footer"
                }
                footer.heightFor = { _ -> CGFloat? in
                    return 32
                }
            }
            section.createRows(for: members) { (member: Member, row: Row<DefaultTableViewCell>) in
                row.height = 52
                row.configureCell = configureMemberCell(member: member)
                row.didSelect = didSelectMember(member: member)
                
                row.canRemove = { _ -> Bool in
                    return true
                }
                row.canMove = { _ -> Bool in
                    return false
                }
                row.canMoveTo = { event -> Bool in
                    return event.sourceIndexPath.section == event.destinationIndexPath.section
                }
                row.willRemove = { _ -> UITableViewRowAnimation? in
                    return .left
                }
                row.didRemove = { event in
                    print(event.row)
                }
            }
            section.createRows(for: 5) { (index: UInt, row: Row<DefaultTableViewCell>) -> Void in
                row.heightFor = { _ -> CGFloat? in
                    return 44
                }
                row.configureCell = configureCountCell(index: index)
            }
        }
        tableView.reloadData()
        
        tableView.source?.didMoveRow = {
            print(String(describing: $0) + " " + String(describing: $1))
        }
        
        tableView.setEditing(true, animated: true)
    }
    
    private func configureMemberCell<T: DefaultTableViewCell>(member: Member) -> (T, Row<T>.RowInformation) -> Void {
        return { cell, _ in
            cell.setupWith(viewModel: DefaultTableViewCellModel(name: member))
        }
    }
    
    private func didSelectMember<T>(member: Member) -> (Row<T>.RowInformation) -> Void {
        return { [weak self] _ in
            self?.memberSelected(member: member)
        }
    }
    
    private func configureCountCell<T: DefaultTableViewCell>(index: UInt) -> (T, Row<T>.RowInformation) -> Void {
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
    
    private func createViewForFooterCell() -> FooterTableViewCell {
        let cell = FooterTableViewCell()
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 0, height: 0))
        label.text = "Custom view footer"
        label.sizeToFit()
        cell.contentView.addSubview(label)
        return cell
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

class HeaderTableViewCell: UITableViewCell { }
class FooterTableViewCell: UITableViewCell { }

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
