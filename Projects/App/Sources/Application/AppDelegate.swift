//
//  AppDelegate.swift
//  iOSTemplateApp
//
//  Created by 한상진 on 2021/06/22.
//

import UIKit
import Features

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        designateWindowsRootVC()
        return true
    }
    
}

extension AppDelegate {
    /// Window의 초기 뷰컨 설정
    private func designateWindowsRootVC() {
        // window 초기화 및 설정
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        // LaunchVC에서 앱 초기에 설정해줘야 할 부분 설정
        let launchVC = LaunchVC(window: window)
        window.rootViewController = launchVC
        window.makeKeyAndVisible()
    }
}
