//
//  LoginView.swift
//  JejuECS
//
//  Created by 이진욱 on 2020/08/07.
//  Copyright © 2020 jwlee. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {
  // MARK: - Property
  
  let idTextfield: UITextField = {
    let tf = UITextField()
    tf.borderStyle = .none
    tf.placeholder = "아이디 또는 이메일"
    return tf
  }()
  
  let pwTextfield: UITextField = {
    let tf = UITextField()
    tf.borderStyle = .none
    tf.placeholder = "비밀번호"
    return tf
  }()
  
  let idTextfieldSubView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray
    return view
  }()
  
  let pwTextfieldSubView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray
    return view
  }()
  
  let loginButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("로그인", for: .normal)
    btn.setTitleColor(.black, for: .normal)
    btn.backgroundColor = .systemGray
    btn.layer.cornerRadius = 10
    btn.clipsToBounds = true
    return btn
  }()
  
  let idSearchButton: UIButton = {
    let btn = UIButton()
    btn.setTitleColor(.black, for: .normal)
    btn.setTitle("아이디 찾기", for: .normal)
    return btn
  }()
  
  let pwSearchButton: UIButton = {
    let btn = UIButton()
    btn.setTitleColor(.black, for: .normal)
    btn.setTitle("비밀번호 찾기", for: .normal)
    return btn
  }()
  
  let idPwSearchSubView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray
    return view
  }()
  
  // MARK: - Init View
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - Setup Layout
  
  private func setUI() {
    [idTextfield, pwTextfield, idTextfieldSubView, pwTextfieldSubView, loginButton, idSearchButton, pwSearchButton, idPwSearchSubView].forEach {
      self.addSubview($0)
    }
  }
  
  private func setConstraints() {
    
    let loginHeight: CGFloat = 60
    let padding: CGFloat = 25
    
    let subViewWidth: CGFloat = 2
    let subViewHeight: CGFloat = 1
    let idPwSubViewHeight: CGFloat = 15
    let subViewPadding: CGFloat = 10
    
    [idTextfield, pwTextfield, loginButton].forEach {
      $0.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.height.equalTo(loginHeight)
      }
    }
    idTextfield.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
    }
    idTextfieldSubView.snp.makeConstraints {
      $0.top.equalTo(idTextfield.snp.bottom).offset(-subViewPadding)
      $0.leading.trailing.equalTo(idTextfield)
      $0.height.equalTo(subViewHeight)
    }
    pwTextfield.snp.makeConstraints {
      $0.top.equalTo(idTextfield.snp.bottom).offset(padding)
    }
    pwTextfieldSubView.snp.makeConstraints {
      $0.top.equalTo(pwTextfield.snp.bottom).offset(-subViewPadding)
      $0.leading.trailing.equalTo(pwTextfield)
      $0.height.equalTo(subViewHeight)
    }
    loginButton.snp.makeConstraints {
      $0.top.equalTo(pwTextfield.snp.bottom).offset(padding)
    }
    idPwSearchSubView.snp.makeConstraints {
      $0.top.equalTo(loginButton.snp.bottom).offset(padding)
      $0.bottom.equalTo(idSearchButton.snp.bottom)
      $0.centerX.equalTo(self)
      $0.width.equalTo(subViewWidth)
      $0.height.equalTo(idPwSubViewHeight)
    }
    idSearchButton.snp.makeConstraints {
      $0.top.equalTo(loginButton.snp.bottom).offset(padding)
      $0.trailing.equalTo(idPwSearchSubView.snp.leading).offset(-padding)
    }
    pwSearchButton.snp.makeConstraints {
      $0.top.equalTo(loginButton.snp.bottom).offset(padding)
      $0.bottom.equalTo(idSearchButton.snp.bottom)
      $0.leading.equalTo(idPwSearchSubView.snp.trailing).offset(padding)
    }
  }
}
