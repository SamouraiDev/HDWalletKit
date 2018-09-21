//
//  EthereumAddressProvider.swift
//  WalletKit
//
//  Created by Dominique Stranz on 20.09.2018.
//  Copyright © 2018 Coinpaprika. All rights reserved.
//
//  Based on https://github.com/BANKEX/web3swift

import Foundation

class EthereumAddressProvider: AddressProvider {
    let network: Network
    var publicKey: PublicKey
    
    required public init(network: Network, publicKey: PublicKey) {
        self.network = network
        self.publicKey = publicKey
    }
    
    var address: String? {
        guard case .bip44 = publicKey.spec else {
            return nil
        }
        
        guard let addressData = publicToAddressData(publicKey.uncompressed) else {
            return nil
        }
        
        return addressDataToString(addressData)
    }
    
    /// Converts address data (20 bytes) to the 0x prefixed hex string. Does not perform checksumming.
    private func addressDataToString(_ addressData: Data) -> String? {
        guard addressData.count == 20 else {return nil}
        return addressData.toHexString().addHexPrefix().lowercased()
    }
    
    /// Convert a public key to the corresponding EthereumAddress. Accepts public keys in non-compressed (65 bytes)
    /// or raw concat(X,Y) (64 bytes) format.
    ///
    /// Returns 20 bytes of address data.
    private func publicToAddressData(_ publicKey: Data) -> Data? {
        var stipped = publicKey
        if (stipped.count == 65) {
            if (stipped[0] != 4) {
                return nil
            }
            stipped = stipped[1...64]
        }
        if (stipped.count != 64) {
            return nil
        }
        let sha3 = stipped.sha3(.keccak256)
        let addressData = sha3[12...31]
        return addressData
    }
}


