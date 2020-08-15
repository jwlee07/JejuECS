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
  
  private let authorizationAppleIDButton: SnsButton = {
    let btn = SnsButton()
    btn.setImage(UIImage(named: "apple_logo"), for: .normal)
    btn.setTitle(" Apple로 로그인", for: .normal)
    return btn
  }()
  
  private let googleLoginButton: SnsButton = {
    let btn = SnsButton()
    btn.setImage(UIImage(named: "google_logo"), for: .normal)
    btn.setTitle(" Google로 로그인", for: .normal)
    btn.addTarget(self, action: #selector(setGoogleLogin), for: .touchUpInside)
    return btn
  }()
  
  private let kakaoLoginButton: SnsButton = {
    let btn = SnsButton()
    btn.setImage(UIImage(named: "kakao_logo"), for: .normal)
    btn.setTitle(" 카카오로 로그인", for: .normal)
    return btn
  }()
  
  private let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
  private let naverLoginButton: SnsButton = {
    let btn = SnsButton()
    btn.setImage(UIImage(named: "naver_logo"), for: .normal)
    btn.setTitle(" 네이버로 로그인", for: .normal)
    return btn
  }()
  
  private let signUpView = UIView()
  
  private let signUpLabel: UILabel = {
    let lb = UILabel()
    lb.text = "혹시, 제주ECS가 처음이신가요? "
    lb.textColor = .systemGray
    lb.font = UIFont(name: "AppleSDGothicNeo-regular", size: 15)
    return lb
  }()
  
  private let signUpButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("회원가입", for: .normal)
    btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 15)
    return btn
  }()
  
  var loginFirebaseDB = Firestore.firestore()
  
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
    loginView.delegate = self
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
    
    let padding: CGFloat = 100
    let margin: CGFloat = 25
    let loginViewHeight: CGFloat = 150
    
    
    let snsloginViewHeight: CGFloat = 40
    let snsToSnsPadding: CGFloat = 8
    
    let signUpViewHeight: CGFloat = 16
    let signUpPadding: CGFloat = 20
    let signUpMargin: CGFloat = 70
    
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
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(padding)
      $0.height.equalTo(loginViewHeight)
    }
    
    googleLoginButton.snp.makeConstraints {
      $0.bottom.equalTo(naverLoginButton.snp.top).offset(-snsToSnsPadding)
      $0.height.equalTo(snsloginViewHeight)
    }
    
    naverLoginButton.snp.makeConstraints {
      $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-snsToSnsPadding)
      $0.height.equalTo(snsloginViewHeight)
    }
    
    kakaoLoginButton.snp.makeConstraints {
      $0.bottom.equalTo(authorizationAppleIDButton.snp.top).offset(-snsToSnsPadding)
      $0.height.equalTo(snsloginViewHeight)
    }
    
    authorizationAppleIDButton.snp.makeConstraints {
      $0.bottom.equalTo(signUpView.snp.top).offset(-signUpPadding)
      $0.height.equalTo(snsloginViewHeight)
    }
    
    signUpView.snp.makeConstraints {
      $0.leading.equalTo(signUpMargin)
      $0.trailing.equalTo(-signUpMargin)
      $0.height.equalTo(signUpViewHeight)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-signUpPadding)
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
  
  @objc private func setGoogleLogin() {
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
      let loginDB = Firestore.firestore()
      KOSessionTask.userMeTask(completion: { (error, user) in
        if let error = error {
          print ("kakao error : ", error.localizedDescription)
        }
        guard let user = user,
          let kakaoEmail = user.account?.email else { return }
//          let nickname = user.nickname else { return }
        
        var ref: DocumentReference? = nil
        ref = loginDB.collection("kakaoLogin").addDocument(data: [
          "email" : kakaoEmail
//          "nickName" : nickname
        ]) { err in
          if let err = err {
            print("Error adding document: \(err.localizedDescription)")
          } else {
            print("Document added with ID: \(ref!.documentID)")
          }
        }
        
        
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
// MARK: - Login Delegate

extension LoginViewController: LoginViewDelegate {
  func loginData(id: String, pw: String) {
    let loginDB = Firestore.firestore()
    var ref: DocumentReference? = nil
    ref = loginDB.collection("userCheck").addDocument(data: [
      id: pw
    ]) { err in
      if let err = err {
        print("Error adding document: \(err.localizedDescription)")
      } else {
        print("Document added with ID: \(ref!.documentID)")
      }
    }
  }
}
