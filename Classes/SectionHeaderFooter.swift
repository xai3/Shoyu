//
//  SectionHeaderFooter.swift
//  Shoyu
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

open class SectionHeaderFooter<Type: UIView>: SectionHeaderFooterType {
    public typealias SectionHeaderFooterInformation = (headerFooter: SectionHeaderFooter<Type>, tableView: UITableView, section: Int)
    
    public init() { }
    
    public init(closure: ((SectionHeaderFooter<Type>) -> Void)) {
        closure(self)
    }
    
    fileprivate var _reuseIdentifier: String?
    open var reuseIdentifier: String? {
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
    
    open var height: CGFloat?
    open var title: String?
    
    open var configureView: ((Type, SectionHeaderFooterInformation) -> Void)?
    open var heightFor: ((SectionHeaderFooterInformation) -> CGFloat?)?
    open var titleFor: ((SectionHeaderFooterInformation) -> String?)?
    open var createView: ((SectionHeaderFooterInformation) -> Type?)?
}

extension SectionHeaderFooter: SectionHeaderFooterDelegateType {
    func configureView(_ tableView: UITableView, view: UIView, section: Int) {
        guard let genericView = view as? Type else {
            fatalError()
        }
        configureView?(genericView, (self, tableView, section))
    }
    
    func heightFor(_ tableView: UITableView, section: Int) -> CGFloat? {
        return heightFor?((self, tableView, section)) ?? height
    }
    
    func titleFor(_ tableView: UITableView, section: Int) -> String? {
        return titleFor?((self, tableView, section)) ?? title
    }
    
    func viewFor(_ tableView: UITableView, section: Int) -> UIView? {
        return createView?((self, tableView, section))
    }
}
