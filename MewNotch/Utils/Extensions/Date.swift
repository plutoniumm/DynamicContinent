//
//  Date.swift
//  MewNotch
//
//  Created by Monu Kumar on 05/03/2025.
//

import Foundation

extension Date {
    func formatted(
        format: String = "yyyy-MM-dd HH:mm:ss"
    ) -> String {
        return DateUtils.shared.getFormattedDate(
            self,
            format: format
        )
    }
}
