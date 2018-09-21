//
//  BitcoinAddressProvider.swift
//  WalletKit
//
//  Created by Dominique Stranz on 20.09.2018.
//  Copyright © 2018 Coinpaprika. All rights reserved.
//

import Foundation

public class BitcoinAddressProvider: AddressProvider {
    let network: Network
    let publicKey: PublicKey
    
    required public init(network: Network, publicKey: PublicKey) {
        self.network = network
        self.publicKey = publicKey
    }
    
    private var publicKeyHash: UInt8 {
        switch network {
        case .main:
            return 0x00
        case .test:
            return 0x6f
        }
    }
    
    private var scriptHash: UInt8 {
        switch network {
        case .main:
            return 0x05
        case .test:
            return 0xc4
        }
    }
    
    private var bech32: String {
        switch network {
        case .main:
            return "bc"
        case .test:
            return "tb"
        }
    }
    
    // NOTE: https://github.com/bitcoin/bips/blob/master/bip-0013.mediawiki
    public var address: String? {
        switch publicKey.spec {
        case .bip44:
            return addressBIP44
        case .bip49:
            return addressBIP49
        case .bip84:
            return addressBIP84
        }
    }
    
    private var redeemScript: Data    {
        var redeem = Data([0x00, 0x14])
        redeem.append(RIPEMD160.hash(publicKey.raw.sha256()))
        return redeem
    }
    
    private var outputScript: Data    {
        var script = Data([0xa9, 0x14])
        script.append(RIPEMD160.hash(redeemScript.sha256()))
        script.append(Data([0x87]))
        return script
    }
    
    private var addressBIP44: String {
        let prefix = Data([publicKeyHash])
        let payload = RIPEMD160.hash(publicKey.raw.sha256())
        let checksum = (prefix + payload).doubleSHA256.prefix(4)
        return Base58.encode(prefix + payload + checksum)
    }
    
    private var addressBIP49: String {
        let prefix = Data([scriptHash])
        let payload = RIPEMD160.hash(redeemScript.sha256())
        let checksum = (prefix + payload).doubleSHA256.prefix(4)
        return Base58.encode(prefix + payload + checksum)
    }
    
    private var addressBIP84: String {
        let addrCoder = SegwitAddrCoder()
        var address : String
        do  {
            address = try addrCoder.encode(hrp: bech32, version: 0x00, program: RIPEMD160.hash(publicKey.raw.sha256()))
        }
        catch {
            address = "";
        }
        
        return address
    }
}
