//
//  Source.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class Source: NSObject {
    internal var sections = [SectionType]()
    
    public override init() {
        super.init()
    }
    
    public convenience init(@noescape closure: (Source -> Void)) {
        self.init()
        closure(self)
    }
    
    var didMoveRow: ((NSIndexPath, NSIndexPath) -> Void)?
    
    public func addSection(section: SectionType) -> Self {
        sections.append(section)
        return self
    }
    
    public func addSections(sections: [SectionType]) -> Self {
        self.sections.appendContentsOf(sections)
        return self
    }
    
    public func createSection<H, F>(@noescape closure: (Section<H, F> -> Void)) -> Self {
        return addSection(Section<H, F>() { closure($0) })
    }
    
    public func createSections<H, F, E>(elements: [E], @noescape closure: ((E, Section<H, F>) -> Void)) -> Self {
        return addSections(
            elements.map { element -> Section<H, F> in
                return Section<H, F>() { closure(element, $0) }
                }.map { $0 as SectionType }
        )
    }
    
    public func createSections<H, F>(count: UInt, @noescape closure: ((UInt, Section<H, F>) -> Void)) -> Self {
        return createSections([UInt](0..<count), closure: closure)
    }
    
}

public extension Source {
    public func sectionFor(section: Int) -> SectionType {
        return sections[section]
    }
    
    public func sectionFor(indexPath: NSIndexPath) -> SectionType {
        return sectionFor(indexPath.section)
    }
    
    public func moveRow(sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath) {
        let row = sectionFor(sourceIndexPath).removeRow(sourceIndexPath.row)
        sectionFor(destinationIndexPath).insertRow(row, index: destinationIndexPath.row)
    }
}

// MARK: - Table view data source

extension Source: UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionFor(section).rowCount
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = sectionFor(indexPath).rowFor(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(row.reuseIdentifier, forIndexPath: indexPath)
        if let delegate = row as? RowDelegateType {
            delegate.configureCell(tableView, cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = sectionFor(section).header else {
            return nil
        }
        return sectionHeaderFooterViewFor(header, tableView: tableView, section: section)
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = sectionFor(section).footer else {
            return nil
        }
        return sectionHeaderFooterViewFor(footer, tableView: tableView, section: section)
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let header = sectionFor(section).header else {
            return nil
        }
        return sectionHeaderFooterTitleFor(header, tableView: tableView, section: section)
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let footer = sectionFor(section).footer else {
            return nil
        }
        return sectionHeaderFooterTitleFor(footer, tableView: tableView, section: section)
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let delegate = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType {
            return delegate.canEdit(tableView, indexPath: indexPath)
        }
        return false
    }
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let delegate = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType {
            return delegate.canMove(tableView, indexPath: indexPath)
        }
        return false
    }
    
    public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        guard let delegate = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType else {
            return .None
        }
        return delegate.canRemove(tableView, indexPath: indexPath) ? .Delete : .None
    }
    
    public func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let delegate = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType else {
            return false
        }
        return delegate.canRemove(tableView, indexPath: indexPath) ? true : false
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let delegate = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType else {
            return
        }
        
        switch editingStyle {
        case .Delete:
            sectionFor(indexPath).removeRow(indexPath.row)
            let animation = delegate.willRemove(tableView, indexPath: indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: animation)
            delegate.didRemove(tableView, indexPath: indexPath)
        default:
            break
        }
    }
}

// MARK: - Table view delegate

extension Source: UITableViewDelegate {
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = sectionFor(indexPath).rowFor(indexPath)
        if let delegate = row as? RowDelegateType,
            let height = delegate.heightFor(tableView, indexPath: indexPath) {
                return height
        }
        return tableView.rowHeight
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = sectionFor(section).header else {
            return 0
        }
        return sectionHeaderFooterHeightFor(header, tableView: tableView, section: section) ?? tableView.sectionHeaderHeight
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footer = sectionFor(section).footer else {
            return 0
        }
        return sectionHeaderFooterHeightFor(footer, tableView: tableView, section: section) ?? tableView.sectionFooterHeight
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType
        row?.didSelect(tableView, indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let row = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType
        row?.didDeselect(tableView, indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let row = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType
        row?.willDisplayCell(tableView, cell: cell, indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let row = sectionFor(indexPath).rowFor(indexPath) as? RowDelegateType
        row?.didEndDisplayCell(tableView, cell: cell, indexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        moveRow(sourceIndexPath, destinationIndexPath: destinationIndexPath)
        didMoveRow?(sourceIndexPath, destinationIndexPath)
    }
    
    public func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        guard let row = sectionFor(sourceIndexPath).rowFor(sourceIndexPath) as? RowDelegateType else {
            return sourceIndexPath
        }
        return row.canMoveTo(tableView, indexPath: sourceIndexPath, destinationIndexPath: proposedDestinationIndexPath) ? proposedDestinationIndexPath : sourceIndexPath
    }
}

// MARK: Private method

extension Source {
    private func sectionHeaderFooterViewFor(headerFooter: SectionHeaderFooterType, tableView: UITableView, section: Int) -> UIView? {
        // Dequeue
        if let identifier = headerFooter.reuseIdentifier,
            let view = dequeueReusableView(tableView, identifier: identifier) {
                if let delegate = headerFooter as? SectionHeaderFooterDelegateType {
                    delegate.configureView(tableView, view: view, section: section)
                }
                return view
        }
        
        // Create view
        if let delegate = headerFooter as? SectionHeaderFooterDelegateType,
            let view = delegate.viewFor(tableView, section: section) {
                delegate.configureView(tableView, view: view, section: section)
                return view
        }
        return nil
    }
    
    private func sectionHeaderFooterTitleFor(headerFooter: SectionHeaderFooterType, tableView: UITableView, section: Int) -> String? {
        if let delegate = headerFooter as? SectionHeaderFooterDelegateType,
            let title = delegate.titleFor(tableView, section: section) {
                return title
        }
        return nil
    }
    
    private func dequeueReusableView(tableView: UITableView, identifier: String) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) {
            return view
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            return cell.contentView
        }
        return nil
    }
    
    private func sectionHeaderFooterHeightFor(headerFooter: SectionHeaderFooterType, tableView: UITableView, section: Int) -> CGFloat? {
        if let delegate = headerFooter as? SectionHeaderFooterDelegateType,
            let height = delegate.heightFor(tableView, section: section) {
                return height
        }
        return nil
    }
}

