//
//  AppDelegate.swift
//  SSL-Pinning-Demo
//
//  Created by Dmitry Beloborodov on 11/03/2017.
//  Copyright © 2017 Dmitry Beloborodov. All rights reserved.
//

import UIKit
import TrustKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let trustKitConfig = [
            kTSKSwizzleNetworkDelegates: true,
            kTSKPinnedDomains: [
                "bank.lv": [
                    kTSKIncludeSubdomains : true,
                    kTSKEnforcePinning : true,
                    kTSKPublicKeyAlgorithms: [kTSKAlgorithmRsa2048],
                    kTSKPublicKeyHashes: [
                        "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=",
                        "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX="
                    ],]]] as [String : Any]

        TrustKit.initialize(withConfiguration: trustKitConfig)        
        return true
    }
}

