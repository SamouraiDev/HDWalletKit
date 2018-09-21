//
//  LitecoinTests.swift
//  WalletKitTests
//
//  Created by Dominique Stranz on 21.09.2018.
//  Copyright © 2018 Coinpaprika. All rights reserved.
//

import XCTest
import CryptoSwift
@testable import WalletKit

class LitecoinTests: XCTestCase {
    func testMainNetAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .main(.litecoin))
        
        let firstAddress = wallet.generateAddress(at: 0)
        XCTAssertEqual(firstAddress, "LV8fThzQw45HT6bCgs1yfvLNzv4aFvjJt1")
        
        let secondAddress = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddress, "Lg7bkp36nPJdqoYAfpmR1UUdXgSq9iCxBX")
        
        let thirdAddress = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddress, "LRajgVNRke9ttvrnncpH52iNAbCFdSxq2b")
        
        let forthAddress = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddress, "LcZoNSHLQc1XGjMLy6PdqE8PtphMbRPCQ3")
    }
}
