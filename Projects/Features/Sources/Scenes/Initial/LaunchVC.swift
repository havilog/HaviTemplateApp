//
//  LaunchVC.swift
//  Features
//
//  Created by 홍경표 on 2021/07/01.
//  Copyright © 2021 softbay. All rights reserved.
//

import UIKit
import Logger

public final class LaunchVC: UIViewController {
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Logger.debug("\(self) deinit")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
//            let hasAgreed: Bool = UserDefaults.standard.bool(forKey: "hasAgreed")
            let hasAgreed: Bool = true // 이미 약관동의 했다고 가정
            if hasAgreed == true {
                // 메인 화면
                self?.goMain()
            } else {
                // 약관동의 화면
                // self?.goIntro()
            }
        }
    }
    
    private func goMain() {
        let mainVC = MainVC()
        window.rootViewController = mainVC
    }
}
