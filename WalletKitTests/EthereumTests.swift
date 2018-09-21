//
//  EthereumTests.swift
//  WalletKitTests
//
//  Created by Dominique Stranz on 21.09.2018.
//  Copyright © 2018 Coinpaprika. All rights reserved.
//

import XCTest
import CryptoSwift
@testable import WalletKit

class EthereumTests: XCTestCase {
    func testMainNetAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .main(.ethereum))
        
        let firstAddress = wallet.generateAddress(at: 0)
        XCTAssertEqual(firstAddress, "0x83f1caadabeec2945b73087f803d404f054cc2b7")
        
        let secondAddress = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddress, "0xb3c3d923cfc4d551b38db8a86bba42b623d063ce")
        
        let thirdAddress = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddress, "0x82e35b34cfbeb9704e51eb17f8263d919786e66a")
        
        let forthAddress = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddress, "0xcf1d652dab65ea4f10990fd2d2e59cd7cbeb315a")
    }
}
