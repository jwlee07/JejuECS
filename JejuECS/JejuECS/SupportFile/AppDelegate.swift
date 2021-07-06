//
//  AppDelegate.swift
//  JejuECS
//
//  Created by 이진욱 on 2020/08/03.
//  Copyright © 2020 jwlee. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import KakaoOpenSDK
import NaverThirdPartyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // FireBase
    FirebaseApp.configure()
    
    // Google
    GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance()?.delegate = self
    
    // Naver
    let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    // 네이버 앱으로 활성화
    instance?.isNaverAppOauthEnable = true
    // Safari로 인증
    instance?.isInAppOauthEnable = true
    // 인증 화면은 아이폰의 세로에서만 가능
    instance?.isOnlyPortraitSupportedInIphone()
    
    // 네이버 아이디로 로그인 설정
    // 애플리케이션을 등록할 때 입력한 URL Scheme
    instance?.serviceUrlScheme = kServiceAppUrlScheme
    // 애플리케이션 등록 후 발급받은 클라이언트 아이디
    instance?.consumerKey = kConsumerKey
    // 애플리케이션 등록 후 발급받은 클라이언트 시크릿
    instance?.consumerSecret = kConsumerSecret
    // 애플리케이션 이름
    instance?.appName = kServiceAppName
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = LoginViewController()
    window?.backgroundColor = .systemBackground
    return true
  }
  
  // MARK: - Kakao Google Naver Login
  @available(iOS 9.0, *)
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
    
    if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
      return KOSession.handleOpen(url)
    }
    return GIDSignIn.sharedInstance().handle(url)
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    
    if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
      return KOSession.handleOpen(url)
    }
    return false
  }
  
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    print ("didDisconnectWith error : ", error.localizedDescription)
  }
}

// MARK: - GIDSignInDelegate

extension AppDelegate: GIDSignInDelegate {
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if let error = error {
      print (error.localizedDescription)
      return
    }
    
    guard let authentication = user.authentication else { return }
  }
}

