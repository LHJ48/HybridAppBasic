//
//  MainWebViewController.swift
//  HybridAppBasic
//
//  Created by LeeHoJun on 8/7/24.
//

import UIKit
import WebKit

class MainWebViewController: BaseViewController {

    var webView: WKWebView!
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DeviceInfoTest()
        setupViews()
    }
    
    func DeviceInfoTest(){
        let deviceInfo = AppDataManager.shared

        print("앱 디스플레이 정보 : \(deviceInfo.getAppDisplayName())")
        print("앱 현재 정보 : \(deviceInfo.getAppCurrentVersion())")
        print("앱 os 정보 : \(deviceInfo.getOsCurrentVersion())")
        print("앱 디바이스 정보 : \(deviceInfo.getDeviceName()!)")
    }
    
    // 초기 설정 함수
    func setupViews() {
        // UIView 생성 및 설정
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // WKWebView 생성 및 설정
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(webView)
        
        // UIView 제약 조건 설정 (화면 전체에 마진 없이)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // WKWebView 제약 조건 설정 (UIView 안에서)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: containerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }

}

