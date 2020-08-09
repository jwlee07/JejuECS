//
//  MyPageViewController.swift
//  JejuECS
//
//  Created by 윤병일 on 2020/08/07.
//  Copyright © 2020 jwlee. All rights reserved.
//

import UIKit

class MyPageViewController : UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .link
    setNavi()
  }
  
  private func setNavi() {
    navigationController?.navigationBar.isHidden = true
  }
}
