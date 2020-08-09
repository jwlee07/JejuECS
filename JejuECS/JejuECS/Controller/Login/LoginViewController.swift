//
//  LoginViewController.swift
//  JejuECS
//
//  Created by 이진욱 on 2020/08/07.
//  Copyright © 2020 jwlee. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import Alamofire
import AuthenticationServices
import GoogleSignIn
import KakaoOpenSDK
import NaverThirdPartyLogin

class LoginViewController: UIViewController {
  // MARK: - Property
  
  private let loginView = LoginView()
  
  private let authorizationAppleIDButton = ASAuthorizationAppleIDButton()
  private let googleLoginButton = GIDSignInButton()
  private let kakaoLoginButton = KOLoginButton()
  private let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
  private let naverLoginButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("naver 로그인", for: .normal)
    btn.titleLabel?.textAlignment = .center
    btn.backgroundColor = .systemGreen
    return btn
  }()
  
  private let signUpView = UIView()
  
  private let signUpLabel: UILabel = {
    let lb = UILabel()
    lb.text = "혹시, 제주ECS가 처음이신가요? "
    lb.textColor = .systemGray
    lb.font = UIFont(name: "AppleSDGothicNeo-regular", size: 20)
    return lb
  }()
  
  private let signUpButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("회원가입", for: .normal)
    btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 20)
    return btn
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    setConstraints()
    setAuthorizationAppleIDButton()
    setGoogleLogin()
    setKakaoLoginButton()
    setNaverLoginButton()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  // MARK: - Setup Layout
  
  private func setUI() {
    [loginView,
     authorizationAppleIDButton,
     googleLoginButton,
     kakaoLoginButton,
     naverLoginButton,
     signUpView].forEach {
      view.addSubview($0)
    }
    
    [signUpLabel,
     signUpButton].forEach {
      signUpView.addSubview($0)
    }
  }
  
  private func setConstraints() {
    
    let padding: CGFloat = 150
    let margin: CGFloat = 25
    let loginViewHeight: CGFloat = 200
    
    
    let snsloginViewHeight: CGFloat = 50
    let snsPadding: CGFloat = 250
    let snsToSnsPadding: CGFloat = 8
    
    let signUpViewHeight: CGFloat = 16
    let signUpPadding: CGFloat = 20
    let signUpMargin: CGFloat = 45
    
    [loginView,
     authorizationAppleIDButton,
     googleLoginButton,
     kakaoLoginButton,
     naverLoginButton].forEach {
      $0.snp.makeConstraints {
        $0.leading.equalTo(margin)
        $0.trailing.equalTo(-margin)
      }
    }
    
    loginView.snp.makeConstraints {
      $0.top.equalTo(padding)
      $0.height.equalTo(loginViewHeight)
    }
    
    authorizationAppleIDButton.snp.makeConstraints {
      $0.top.equalTo(loginView.snp.bottom).offset(snsPadding)
      $0.height.equalTo(snsloginViewHeight)
    }
    
    googleLoginButton.snp.makeConstraints {
      $0.top.equalTo(authorizationAppleIDButton.snp.bottom).offset(snsToSnsPadding)
      $0.height.equalTo(snsloginViewHeight)
    }
    
    kakaoLoginButton.snp.makeConstraints {
      $0.top.equalTo(googleLoginButton.snp.bottom).offset(snsToSnsPadding)
      $0.height.equalTo(snsloginViewHeight)
    }
    
    naverLoginButton.snp.makeConstraints {
      $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(snsToSnsPadding)
      $0.height.equalTo(snsloginViewHeight)
    }
    
    signUpView.snp.makeConstraints {
      $0.leading.equalTo(signUpMargin)
      $0.trailing.equalTo(-signUpMargin)
      $0.top.equalTo(naverLoginButton.snp.bottom).offset(signUpPadding)
      $0.height.equalTo(signUpViewHeight)
    }
    
    signUpLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.top.equalTo(signUpView.snp.top)
    }
    
    signUpButton.snp.makeConstraints {
      $0.leading.equalTo(signUpLabel.snp.trailing)
      $0.centerY.equalTo(signUpLabel.snp.centerY)
    }
  }
  
  // MARK: - Set AuthorizationAppleIDButton
  
  private func setAuthorizationAppleIDButton() {
    authorizationAppleIDButton.addTarget(self, action: #selector(didTabAppleButton), for: .touchUpInside)
  }
  
  @objc private func didTabAppleButton(_ sender: ASAuthorizationAppleIDButton) {
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = [.fullName, .email]
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
  
  // MARK: - Set GoogleLoginButton
  
  private func setGoogleLogin() {
    GIDSignIn.sharedInstance()?.presentingViewController = self
    GIDSignIn.sharedInstance().signIn()
  }
  
  // MARK: - Set KakaoLoginButton
  
  private func setKakaoLoginButton() {
    kakaoLoginButton.addTarget(self, action: #selector(didTapKakaoButton), for: .touchUpInside)
  }
  
  @objc private func didTapKakaoButton(_ sender: Any) {
    guard let session = KOSession.shared() else { return }
    
    if session.isOpen() {
      session.close()
    }
    
    session.open { (error) in
      if error != nil || !session.isOpen() { return }
      KOSessionTask.userMeTask(completion: { (error, user) in
        if let error = error {
          print ("kakao error : ", error.localizedDescription)
        }
        //        guard let user = user,
        //          let email = user.account?.email,
        //          let nickname = user.nickname else { return }
        
        //      let mainVC = MainViewController()
        //      mainVC.emailLabel.text = email
        //      mainVC.nicnameLabel.text = nickname
        
        //      self.present(mainVC, animated: false, completion: nil)
      })
    }
  }
  
  
  // MARK: - Set NaverLoginButton
  
  private func setNaverLoginButton() {
    naverLoginButton.addTarget(self, action: #selector(didTapNaverButton), for: .touchUpInside)
  }
  
  @objc private func didTapNaverButton(_ sender: UIButton) {
    naverLoginInstance?.delegate = self
    naverLoginInstance?.requestThirdPartyLogin()
  }
}

// MARK: - ASAuthorizationControllerDelegate

extension LoginViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      let userIdentifier = appleIDCredential.user
      //      let userFirstName = appleIDCredential.fullName?.givenName
      //      let userLastName = appleIDCredential.fullName?.familyName
      //      let userEmail = appleIDCredential.email
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      appleIDProvider.getCredentialState(
      forUserID: userIdentifier) { ( credentialState, error) in
        switch credentialState {
        case .authorized:
          break
        case .revoked:
          break
        case .notFound:
          break
        default:
          break
        }
      }
    }
  }
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print ("error.localizedDescription : ", error.localizedDescription)
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return view.window!
  }
}

// MARK: - NaverThirdPartyLoginConnectionDelegate

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
  
  // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
  func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) { }
  
  // 로그인에 성공했을 경우 호출
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("[Success] : Success Naver Login")
    
  }
  
  // 접근 토큰 갱신
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    
  }
  
  // 로그아웃 할 경우 호출(토큰 삭제)
  func oauth20ConnectionDidFinishDeleteToken() {
    naverLoginInstance?.requestDeleteToken()
  }
  
  // 모든 Error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    print("[Error] :", error.localizedDescription)
  }
}
