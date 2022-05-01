//
//  Extentions.swift
//  cyberTekAdmin
//
//  Created by Dave Bulner on 2022-04-29.
//


import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

