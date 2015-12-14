//
//  File.swift
//  SoySource
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

class SoySource: NSObject {
    internal var sections = [SectionType]()
    
    override init() {
        super.init()
    }
    
    convenience init(@noescape clousure: (SoySource -> Void)) {
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

extension SoySource {
    func sectionWith(section: Int) -> SectionType {
        return sections[section]
    }
    
    func sectionWith(indexPath: NSIndexPath) -> SectionType {
        return sectionWith(indexPath.section)
    }
    
    func rowWith(section: Int, row: Int) -> RowType {
        return sections[section].rows[row]
    }
    
    func rowWith(indexPath: NSIndexPath) -> RowType {
        return rowWith(indexPath.section, row: indexPath.row)
    }
}

// MARK: - Table view data source

extension SoySource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionWith(section).rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = rowWith(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier, forIndexPath: indexPath)
        row.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sec = sectionWith(section)
        guard let identifier = sec.header?.identifier,
            let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) else {
            return nil
        }
        sec.configureHeader(view, section: section)
        return view
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sec = sectionWith(section)
        guard let identifier = sec.footer?.identifier,
            let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) else {
            return nil
        }
        sec.configureFooter(view, section: section)
        return view
    }
}

// MARK: - Table view delegate

extension SoySource: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = rowWith(indexPath)
        return row.height ?? 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sec = sectionWith(section)
        return sec.heightForHeader(section) ?? 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sec = sectionWith(section)
        return sec.heightForFooter(section) ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowWith(indexPath).didSelect(indexPath)
    }
}

