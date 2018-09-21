//
//  Network.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public enum Coin {
    case bitcoin
    case litecoin
//    case nem
    case ethereum
    case ethereumClassic
//    case monero
//    case zcash
//    case lisk
//    case bitcoinCash
}

public enum Network {
    case main(Coin)
    case test(Coin)
    
    public var coin: Coin {
        switch self {
        case .main(let coin), .test(let coin):
            return coin
        }
    }

    public var privateKeyVersion: UInt32 {
        switch self {
        case .main:
            return 0x0488ADE4
        case .test:
            return 0x04358394
        }
    }
    
    public var publicKeyVersion: UInt32 {
        switch self {
        case .main:
            return 0x0488B21E
        case .test:
            return 0x043587CF
        }
    }
    
    // https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    public var coinType: UInt32 {
        switch self {
        case .main(let coin):
            switch coin {
            case .bitcoin:
                return 0
            case .litecoin:
                return 2
//            case .nem:
//                return 43
            case .ethereum:
                return 60
            case .ethereumClassic:
                return 61
//            case .monero:
//                return 128
//            case .zcash:
//                return 133
//            case .lisk:
//                return 134
//            case .bitcoinCash:
//                return 145
            }
            
        case .test:
            return 1
        }
    }

}
