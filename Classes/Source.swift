//
//  Source.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

class Source: NSObject {
    internal var sections = [SectionType]()
    
    override init() {
        super.init()
    }
    
    convenience init(@noescape clousure: (Source -> Void)) {
        self.init()
        clousure(self)
    }
    
    func addSection(section: SectionType) -> Self {
        sections.append(section)
        return self
    }
    
    func addSections(sections: [SectionType]) -> Self {
        self.sections.appendContentsOf(sections)
        return self
    }
    
    func createSection<H, F>(@noescape clousure: (Section<H, F> -> Void)) -> Self {
        return addSection(Section<H, F>() { clousure($0) })
    }
    
    func createSections<H, F, E>(elements: [E], @noescape clousure: ((E, Section<H, F>) -> Void)) -> Self {
        return addSections(
            elements.map { element -> Section<H, F> in
                return Section<H, F>() { clousure(element, $0) }
                }.map { $0 as SectionType }
        )
    }
    
    func createSections<H, F>(count: UInt, @noescape clousure: ((UInt, Section<H, F>) -> Void)) -> Self {
        return createSections([UInt](0..<count), clousure: clousure)
    }
    
}

extension Source {
    func sectionFor(section: Int) -> SectionType {
        return sections[section]
    }
    
    func sectionFor(indexPath: NSIndexPath) -> SectionType {
        return sectionFor(indexPath.section)
    }
}

// MARK: - Table view data source

extension Source: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionFor(section).rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = sectionFor(indexPath).rowFor(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(row.reuseIdentifier, forIndexPath: indexPath)
        row.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sec = sectionFor(section)
        
        // Create view
        if let view = sec.header?.viewFor(section) {
            sec.header?.configureView(view, section: section)
            return view
        }
        
        // Dequeue
        if let identifier = sec.header?.reuseIdentifier,
            let view = dequeueReusableView(tableView, identifier: identifier) {
                sec.header?.configureView(view, section: section)
                return view
        }
        return nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sec = sectionFor(section)
        
        // Create view
        if let view = sec.footer?.viewFor(section) {
            sec.footer?.configureView(view, section: section)
            return view
        }
        
        // Dequeue
        if let identifier = sec.footer?.reuseIdentifier,
            let view = dequeueReusableView(tableView, identifier: identifier) {
                sec.footer?.configureView(view, section: section)
                return view
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
}

// MARK: - Table view delegate

extension Source: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = sectionFor(indexPath).rowFor(indexPath)
        return row.heightFor(indexPath) ?? row.height ?? tableView.rowHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sec = sectionFor(section)
        return sec.header?.heightFor(section) ?? sec.header?.height ?? tableView.sectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sec = sectionFor(section)
        return sec.footer?.heightFor(section) ?? sec.footer?.height ?? tableView.sectionFooterHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sectionFor(indexPath).rowFor(indexPath).didSelect(indexPath)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        sectionFor(indexPath).rowFor(indexPath).didDeselect(indexPath)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        sectionFor(indexPath).rowFor(indexPath).willDisplayCell(cell, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        sectionFor(indexPath).rowFor(indexPath).didEndDisplayCell(cell, indexPath: indexPath)
    }
}

