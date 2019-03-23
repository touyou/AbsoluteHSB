//
//  CGFloat+String.swift
//  AbsoluteHSB
//
//  Created by 藤井陽介 on 2019/03/23.
//

import Foundation

extension CGFloat {
    init?<S>(_ text: S) where S : StringProtocol {
        guard let number = Double(text) else { return nil }
        self.init(number)
    }
}
