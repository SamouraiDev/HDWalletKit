//
//  PublicKey.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public struct PublicKey {
    public let raw: Data
    public let chainCode: Data
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    public let spec: DerivationSpec
    
    private let privateKey: PrivateKey
    
    init(privateKey: PrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32, spec: DerivationSpec = .bip44) {
        self.raw = Crypto.generatePublicKey(data: privateKey.raw, compressed: true)
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
        self.privateKey = privateKey
        self.spec = spec
    }
    
    public var extended: String {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyVersion.bigEndian
        extendedPublicKeyData += depth.littleEndian
        extendedPublicKeyData += fingerprint.littleEndian
        extendedPublicKeyData += index.littleEndian
        extendedPublicKeyData += chainCode
        extendedPublicKeyData += raw
        let checksum = extendedPublicKeyData.doubleSHA256.prefix(4)
        return Base58.encode(extendedPublicKeyData + checksum)
    }
    
    public lazy var uncompressed: Data = {
        return Crypto.generatePublicKey(data: privateKey.raw, compressed: false)
    }()
    
    var addressProvider: AddressProvider {
        return AddressFactory.provider(network: network, publicKey: self)
    }
}
