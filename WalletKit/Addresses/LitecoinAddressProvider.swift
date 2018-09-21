//
//  LitecoinAddressProvider.swift
//  WalletKit
//
//  Created by Dominique Stranz on 20.09.2018.
//  Copyright © 2018 Coinpaprika. All rights reserved.
//

import Foundation

public class LitecoinAddressProvider: AddressProvider {
    let network: Network
    let publicKey: PublicKey
    
    required public init(network: Network, publicKey: PublicKey) {
        self.network = network
        self.publicKey = publicKey
    }
    
    private var publicKeyHash: UInt8 {
        switch network {
        case .main:
            return 0x30
        case .test:
            return 0x6f
        }
    }
    
    public var address: String? {
        switch publicKey.spec {
        case .bip44:
            return addressBIP44
        default:
            return nil
        }
    }
    
    private var addressBIP44: String {
        let prefix = Data([publicKeyHash])
        let payload = RIPEMD160.hash(publicKey.raw.sha256())
        let checksum = (prefix + payload).doubleSHA256.prefix(4)
        return Base58.encode(prefix + payload + checksum)
    }
}
