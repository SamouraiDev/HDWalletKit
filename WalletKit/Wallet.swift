//
//  Wallet.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public enum DerivationSpec {
    case bip44
    case bip49
    case bip84
}

public final class Wallet {
    public let privateKey: PrivateKey
    public let publicKey: PublicKey
    public let network: Network
    public let spec: DerivationSpec
    
    public init(seed: Data, network: Network, spec: DerivationSpec = .bip44) {
        self.network = network
        self.spec = spec
        
        privateKey = PrivateKey(seed: seed, network: network, spec: spec)
        publicKey = privateKey.publicKey
    }
    
    private var purpose: UInt32 {
        switch spec {
        case .bip44:
            return 44
        case .bip49:
            return 49
        case .bip84:
            return 84
        }
    }
    
    private var receivePrivateKey: PrivateKey {
        let purpose = privateKey.derived(at: self.purpose, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        let receive = account.derived(at: 0)
        return receive
    }
    
    private var changePrivateKey: PrivateKey {
        let purpose = privateKey.derived(at: self.purpose, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        let change = account.derived(at: 1)
        return change
    }

    public func privateKey(at index: UInt32) -> PrivateKey {
        return receivePrivateKey.derived(at: index)
    }
    
    public func publicKey(at index: UInt32) -> PublicKey {
        return receivePrivateKey.derived(at: index).publicKey
    }
    
    public func addressProvider(at index: UInt32) -> AddressProvider {
        return receivePrivateKey.derived(at: index).publicKey.addressProvider
    }
    
    public func generateAddress(at index: UInt32) -> String? {
        return receivePrivateKey.derived(at: index).publicKey.addressProvider.address
    }
}
