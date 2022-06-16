//
//  IntroVC.swift
//  TodayApp
//
//  Created by 오승훈 on 2022/06/16.
//

import UIKit

class IntroVC: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(1)
        AppManager.shared.appContainerr = self
        AppManager.shared.showApp()
    }
}
