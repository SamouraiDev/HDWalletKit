//
//  EthereumClassicTests.swift
//  WalletKitTests
//
//  Created by Dominique Stranz on 21.09.2018.
//  Copyright © 2018 Coinpaprika. All rights reserved.
//

import XCTest
import CryptoSwift
@testable import WalletKit

class EthereumClassicTests: XCTestCase {
    func testMainNetAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .main(.ethereumClassic))
        
        let firstAddress = wallet.generateAddress(at: 0)
        XCTAssertEqual(firstAddress, "0x78624d389ba8e77e238496d4a75d7d18a7c388df")
        
        let secondAddress = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddress, "0x14ae2385f28b5900d5fa788d0ccc024028454a57")
        
        let thirdAddress = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddress, "0xe59a9d7a70171839ad567dcc0c6de0234495f62f")
        
        let forthAddress = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddress, "0x8b466182a1e8a22b62c465deca9458562134fbdf")
    }
}
