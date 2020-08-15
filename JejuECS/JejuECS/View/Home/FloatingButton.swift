//
//  FloatingButton.swift
//  JejuECS
//
//  Created by 윤병일 on 2020/08/08.
//  Copyright © 2020 jwlee. All rights reserved.
//

import UIKit

class FloatingButton : UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.cornerRadius = 15
    backgroundColor = .lightGray
    tintColor = UIColor.black.withAlphaComponent(0.4)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
