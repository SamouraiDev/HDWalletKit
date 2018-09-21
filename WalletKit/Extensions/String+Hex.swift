//
//  String+Hex.swift
//  WalletKit
//
//  Created by Dominique Stranz on 21.09.2018.
//  Copyright © 2018 Coinpaprika. All rights reserved.
//

import Foundation

extension String {
    func hasHexPrefix() -> Bool {
        return hasPrefix("0x")
    }

    func stripHexPrefix() -> String {
        if hasPrefix("0x") {
            return String(dropFirst(2))
        }
        
        return self
    }

    func addHexPrefix() -> String {
        if !hasPrefix("0x") {
            return "0x" + self
        }
        
        return self
    }
}
