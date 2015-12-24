//
//  SectionHeaderFooter.swift
//  Shoyu
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class SectionHeaderFooter<Type: UIView>: SectionHeaderFooterType {
    public typealias SectionHeaderFooterEventType = (headerFooter: SectionHeaderFooter<Type>, tableView: UITableView, section: Int)
    public typealias SectionHeaderFooterViewEventType = (headerFooter: SectionHeaderFooter<Type>, tableView: UITableView, view: Type, section: Int)
    
    public init() { }
    
    public init(@noescape closure: (SectionHeaderFooter<Type> -> Void)) {
        closure(self)
    }
    
    private var _reuseIdentifier: String?
    public var reuseIdentifier: String? {
        set {
            _reuseIdentifier = newValue
        }
        get {
            if let identifier = _reuseIdentifier {
                return identifier
            }
            if let identifier = Type() as? ReuseIdentifierType {
                return identifier.identifier
            }
            return nil
        }
    }
    
    public var height: CGFloat?
    public var title: String?
    
    public var configureView: (SectionHeaderFooterViewEventType -> Void)?
    public var heightFor: (SectionHeaderFooterEventType -> CGFloat?)?
    public var titleFor: (SectionHeaderFooterEventType -> String?)?
    public var createView: (SectionHeaderFooterEventType -> Type?)?
}

extension SectionHeaderFooter: SectionHeaderFooterDelegateType {
    func configureView(tableView: UITableView, view: UIView, section: Int) {
        guard let genericView = view as? Type else {
            fatalError()
        }
        configureView?((self, tableView, genericView, section))
    }
    
    func heightFor(tableView: UITableView, section: Int) -> CGFloat? {
        return heightFor?((self, tableView, section)) ?? height
    }
    
    func titleFor(tableView: UITableView, section: Int) -> String? {
        return titleFor?((self, tableView, section)) ?? title
    }
    
    func viewFor(tableView: UITableView, section: Int) -> UIView? {
        return createView?((self, tableView, section))
    }
}
