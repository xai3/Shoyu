//
//  SectionHeaderFooter.swift
//  SoySource
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

protocol SectionHeaderFooterType {
    var reuseIdentifier: String? { get }
    var height: CGFloat? { get set }
    var title: String? { get set }
    
    func configureView(view: UIView, section: Int)
    func heightFor(section: Int) -> CGFloat?
    func viewFor(section: Int) -> UIView?
}

class SectionHeaderFooter<Type: UIView>: SectionHeaderFooterType {
    init() { }
    
    init(@noescape clousure: (SectionHeaderFooter<Type> -> Void)) {
        clousure(self)
    }
    
    private var _reuseIdentifier: String?
    var reuseIdentifier: String? {
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
    
    var height: CGFloat?
    var title: String?
    
    var configureView: ((Type, Int) -> Void)?
    var configureHeight: (Int -> CGFloat?)?
    
    func configureView(view: UIView, section: Int) {
        guard let genericView = view as? Type else {
            fatalError()
        }
        configureView?(genericView, section)
    }
    
    func heightFor(section: Int) -> CGFloat? {
        return configureHeight?(section) ?? height
    }
}
