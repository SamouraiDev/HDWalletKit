//
//  AddressFactory.swift
//  WalletKit
//
//  Created by Dominique Stranz on 20.09.2018.
//  Copyright © 2018 Coinpaprika. All rights reserved.
//

import Foundation

class AddressFactory {
    static func provider(network: Network, publicKey: PublicKey) -> AddressProvider {
        switch network.coin {
        case .bitcoin:
            return BitcoinAddressProvider(network: network, publicKey: publicKey)
        case .litecoin:
            return LitecoinAddressProvider(network: network, publicKey: publicKey)
        case .ethereum, .ethereumClassic:
            return EthereumAddressProvider(network: network, publicKey: publicKey)
        }
        
    }
}

public protocol AddressProvider {
    init(network: Network, publicKey: PublicKey)
    var address: String? { get }
}

