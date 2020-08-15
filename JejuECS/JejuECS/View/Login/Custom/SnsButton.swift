//
//  SnsButton.swift
//  JejuECS
//
//  Created by 이진욱 on 2020/08/09.
//  Copyright © 2020 jwlee. All rights reserved.
//

import UIKit

class SnsButton: UIButton {
  
  // MARK: - Init View
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - Setup Layout
  
  private func setUI() {
    layer.cornerRadius = 10
    backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
    setTitleColor(UIColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1), for: .normal)
    titleLabel?.font = UIFont(name: "AppleSDGothicNeo-regular", size: 15)
  }
}
