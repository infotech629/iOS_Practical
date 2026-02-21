//
//  UIView+Ext.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
