//
//  SectionHeaderFooter.swift
//  SoySource
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

protocol SectionHeaderFooterType {
    var identifier: String { get }
    var height: CGFloat? { get set }
    var title: String? { get set }
    
    func configureView(view: UIView, section: Int)
    func heightFor(section: Int) -> CGFloat?
}

class SectionHeaderFooter<Type: UIView>: SectionHeaderFooterType {
    init() { }
    
    init(@noescape clousure: (SectionHeaderFooter<Type> -> Void)) {
        clousure(self)
    }
    
    var identifier: String {
        // TODO: Imp
        return "Header"
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
