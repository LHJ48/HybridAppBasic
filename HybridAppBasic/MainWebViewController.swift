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
        webViewInit()
        javaScriptCommunication()
    }
    
    func DeviceInfoTest() {
        let deviceInfo = AppDataManager.shared

        print("앱 디스플레이 정보 : \(deviceInfo.getAppDisplayName())")
        print("앱 현재 정보 : \(deviceInfo.getAppCurrentVersion())")
        print("앱 os 정보 : \(deviceInfo.getOsCurrentVersion())")
        print("앱 디바이스 정보 : \(deviceInfo.getDeviceName()!)")
    }
    
    // 초기 화면 설정
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
    
    func webViewInit(){
        webView.uiDelegate = self
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache],
                                                modifiedSince: Date(timeIntervalSince1970: 0)) {
        }
        
        webView.allowsBackForwardNavigationGestures = true
        
        if let url = URL(string: Constants().webviewURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func javaScriptCommunication() {
        JavaScriptManager.shared.evaluateJavaScript(script: "yourJavaScriptFunction()") { result, error in
            if let error = error {
                print("JavaScript execution failed: \(error)")
            } else if let result = result {
                print("JavaScript execution succeeded: \(result)")
            }
        }
    }

}

extension MainWebViewController: WKUIDelegate{
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default) { (action) in
            completionHandler(false)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            if let text = alert.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
