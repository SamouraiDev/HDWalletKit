//
//  BitcoinTests.swift
//  WalletKitTests
//
//  Created by Dominique Stranz on 21.09.2018.
//  Copyright © 2018 Coinpaprika. All rights reserved.
//

import XCTest
import CryptoSwift
@testable import WalletKit

class BitcoinTests: XCTestCase {
    
    func testMainnetChildKeyDerivation() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let network = Network.main(.bitcoin)
        let privateKey = PrivateKey(seed: seed, network: network)
        
        XCTAssertEqual(
            privateKey.extended,
            "xprv9s21ZrQH143K2XojduRLQnU8D8K59KSBoMuQKGx8dW3NBitFDMkYGiJPwZdanjZonM7eXvcEbxwuGf3RdkCyyXjsbHSkwtLnJcsZ9US42Gd"
        )
        
        // BIP44 key derivation
        // m/44'
        let purpose = privateKey.derived(at: 44, hardens: true)
        
        // m/44'/0'
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        
        // m/44'/0'/0'
        let account = coinType.derived(at: 0, hardens: true)
        
        // m/44'/0'/0'/0
        let change = account.derived(at: 0)
        
        XCTAssertEqual(
            change.extended,
            "xprvA2QWrMvVn11Cnc8Wv5XH22Phaz1eLLYUtUVCJxjRu3eSbPZk3WphdkqGBnAKiKtg3bxkL48zbf9C8jJKtbDhB4kTJuNfv3KZVRjxseHNNWk"
        )
        
        XCTAssertEqual(
            change.publicKey.extended,
            "xpub6FPsFsTPcNZW16Cz274HPALS91r8joGLFhQo7M93TPBRUBttb48xBZ9k34oiG29Bvqfry9QyXPsGXSRE1kjut92Dgik1w6Whm1GU4F122n8"
        )
        
        // m/44'/0'/0'/0
        let firstPrivateKey = change.derived(at: 0)
        XCTAssertEqual(
            firstPrivateKey.publicKey.addressProvider.address,
            "128BCBZndgrPXzEgF4QbVR3jnQGwzRtEz5"
        )
        
        XCTAssertEqual(
            firstPrivateKey.publicKey.raw.toHexString(),
            "03ce9b978595558053580d557ff40f9f99a4f1a7609c25268863ee64de7e4abbda"
        )
    }
    
    func testTestnetChildKeyDerivation() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let network = Network.test(.bitcoin)
        let privateKey = PrivateKey(seed: seed, network: network)
        
        XCTAssertEqual(
            privateKey.extended,
            "tprv8ZgxMBicQKsPdM3GJUGqaS67XFjHNqUC8upXBhNb7UXqyKdLCj6HnTfqrjoEo6x89neRY2DzmKXhjWbAkxYvnb1U7vf4cF4qDicyb7Y2mNa"
        )
        
        // BIP44 key derivation
        // m/44'
        let purpose = privateKey.derived(at: 44, hardens: true)
        
        // m/44'/0'
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        
        // m/44'/0'/0'
        let account = coinType.derived(at: 0, hardens: true)
        
        // m/44'/0'/0'/0
        let change = account.derived(at: 0)
        
        XCTAssertEqual(
            change.extended,
            "tprv8hJrzKEmbFfBx44tsRe1wHh25i5QGztsawJGmxeqryPwdXdKrgxMgJUWn35dY2nrYmomRWWL7Y9wJrA6EvKJ27BfQTX1tWzZVxAXrR2pLLn"
        )
        
        XCTAssertEqual(
            change.publicKey.extended,
            "tpubDDzu8jH1jdLrqX6gm5JcLhM8ejbLSL5nAEu44Uh9HFCLU1t6V5mwro6NxAXCfR2jUJ9vkYkUazKXQSU7WAaA9cbEkxdWmbLxHQnWqLyQ6uR"
        )
        
        // m/44'/0'/0'/0
        let firstPrivateKey = change.derived(at: 0)
        XCTAssertEqual(
            firstPrivateKey.publicKey.addressProvider.address,
            "mq1VMMXiZKLdY2WLeaqocJxXijhEFoQu3X"
        )
        
        XCTAssertEqual(
            firstPrivateKey.publicKey.raw.toHexString(),
            "037e63dc23f0f6ecb0b2ab8a649f0e2966e9c6ceb10f901e0e0b712cfed2f78449"
        )
    }
    
    func testMainNetAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .main(.bitcoin))
        
        let firstAddress = wallet.generateAddress(at: 0)
        XCTAssertEqual(firstAddress, "128BCBZndgrPXzEgF4QbVR3jnQGwzRtEz5")
        
        let secondAddress = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddress, "1E7NvpF3u87rbpfYxt3HDmpFasPiU2JhMp")
        
        let thirdAddress = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddress, "12KtZ5SXaQGT2iL89VoFQMuuutPUwXmqdL")
        
        let forthAddress = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddress, "1NPN2MZ2iKK4a1Bav8D4MHYVG6mTetV8xb")
        
    }
    
    func testTestNetAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .test(.bitcoin))
        
        let firstAddress = wallet.generateAddress(at: 0)
        XCTAssertEqual(firstAddress, "mq1VMMXiZKLdY2WLeaqocJxXijhEFoQu3X")
        
        let secondAddress = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddress, "mu7gEKi6LWdWTMdEpux3v79huagEZFMJBN")
        
        let thirdAddress = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddress, "mhDiBvv9fo4pUrDiC4wLS1gS8x9EBuvagg")
        
        let forthAddress = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddress, "mqwDZupDkKsaLsEEDAC9yKtQW6AFTsNeCh")
        
    }
    
    func testMainNetBIP49AddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .main(.bitcoin), spec: .bip49)
        
        let firstAddressP2SH = wallet.generateAddress(at: 0)
        XCTAssertEqual(firstAddressP2SH, "32K5SuFrxTYMGjGRFStmdU1bPTrQ2GhsnV")
        
        let secondAddressP2SH = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddressP2SH, "3FQTSxzUrxnApYTu5Wtt99sqrvtodPyKcV")
        
        let thirdAddressP2SH = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddressP2SH, "34uY5KLosSPpuTkzsvfBwPBjav4u2n6GTh")
        
        let forthAddressP2SH = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddressP2SH, "357mLUhA6CTzBTkJMVSiw2rQBUwJibRCSp")
        
    }
    
    func testMainNetBIP84AddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .main(.bitcoin), spec: .bip84)
        
        let firstAddressBech32 = wallet.generateAddress(at: 0)
        XCTAssertEqual(firstAddressBech32, "bc1qdsdxmlnu5phmwaw9fy88vm57n552l9ztcg4rev")
        
        let secondAddressBech32 = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddressBech32, "bc1qn8e93hk0gdmwwq7xhmqy7k7pza8gunlftgyltp")
        
        let thirdAddressBech32 = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddressBech32, "bc1qtm5rsf56v5u2v39jd7800av4aumrs2dva8cxfd")
        
        let forthAddressBech32 = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddressBech32, "bc1qntew983t8y752fn0tpex3dc5pu8ae2du6d8ghv")
    }
    
}
