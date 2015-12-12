//
//  File.swift
//  SoySource
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

class SoySource: NSObject {
    internal var sections = [Section]()
    
    override init() {
        super.init()
    }
    
    convenience init(@noescape clousure: (SoySource -> Void)) {
        self.init()
        clousure(self)
    }
    
    func addSection(section: Section) -> Self {
        sections.append(section)
        return self
    }
    
    func createSection(@noescape clousure: (Section -> Void)) -> Self {
        let section = Section()
        clousure(section)
        return addSection(section)
    }
}

extension SoySource {
    func sectionWith(section: Int) -> Section {
        return sections[section]
    }
    
    func sectionWith(indexPath: NSIndexPath) -> Section {
        return sectionWith(indexPath.section)
    }
    
    func rowWith(section: Int, row: Int) -> RowType {
        return sections[section].rows[row]
    }
    
    func rowWith(indexPath: NSIndexPath) -> RowType {
        return rowWith(indexPath.section, row: indexPath.row)
    }
}

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
}

extension SoySource: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = rowWith(indexPath)
        if let height = row.heightFor(indexPath) {
            return height
        }
        return row.height
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowWith(indexPath).didSelect(indexPath)
    }
}

