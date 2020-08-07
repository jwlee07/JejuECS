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
import AuthenticationServices
import GoogleSignIn

class LoginViewController: UIViewController {
  // MARK: - Property
  
  private let loginView = LoginView()
  
  private let authorizationAppleIDButton = ASAuthorizationAppleIDButton()
  private let googleLoginButton = GIDSignInButton()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    setConstraints()
    setAuthorizationAppleIDButton()
    setGoogleLogin()
  }
  
  // MARK: - Setup Layout
  
  private func setUI() {
    [loginView, authorizationAppleIDButton, googleLoginButton].forEach {
      view.addSubview($0)
    }
  }
  
  private func setConstraints() {
    
    let padding: CGFloat = 150
    let margin: CGFloat = 18
    let loginViewHeight: CGFloat = 200
    
    
    let snsloginViewHeight: CGFloat = 60
    let snsPadding: CGFloat = 250
    let snsToSnsPadding: CGFloat = 8
    
    [loginView, authorizationAppleIDButton, googleLoginButton].forEach {
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
      $0.height.equalTo(80)
    }
  }
  
  // MARK: - Set authorizationAppleIDButton
  
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

