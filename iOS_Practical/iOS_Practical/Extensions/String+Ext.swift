//
//  String+Ext.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import UIKit

extension String {
    func needsTruncation(font: UIFont, width: CGFloat, maxLines: Int) -> Bool {
        let text = self as NSString
        let rect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let boundingRect = text.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let lineHeight = font.lineHeight
        let maxHeight = lineHeight * CGFloat(maxLines)
        return boundingRect.height > maxHeight
    }
}
