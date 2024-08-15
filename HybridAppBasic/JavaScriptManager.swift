//
//  JavaScriptManager.swift
//  HybridAppBasic
//
//  Created by LeeHoJun on 8/14/24.
//

import WebKit

/*
 •    JavaScriptManager 싱글톤 클래스는 JavaScript 코드 실행을 관리하고 결과를 콜백으로 처리합니다.
 •    evaluateJavaScript 메소드를 사용하여 JavaScript 코드를 실행하고 결과를 콜백으로 전달받을 수 있습니다.
 •    JavaScript에서 postMessage를 사용하여 iOS로 데이터를 전송하면 userContentController 메소드가 이를 처리합니다.
 */

class JavaScriptManager: NSObject, WKScriptMessageHandler {
    static let shared = JavaScriptManager()
    
    private var webView: WKWebView?
    private var callback: ((Any?, Error?) -> Void)?
    
    private override init() {
        super.init()
        configureWebView()
    }
    
    private func configureWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
    }
    
    func evaluateJavaScript(script: String, callback: @escaping (Any?, Error?) -> Void) {
        self.callback = callback
        webView?.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                callback(nil, error)
            } else {
                callback(result, nil)
            }
        }
    }
    
    // JavaScript에서 호출될 때 실행되는 메소드
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            callback?(message.body, nil)
        }
    }
    
    /*
     // JavaScript 코드에서 iOS로 데이터를 전송하려면, window.webkit.messageHandlers.callbackHandler.postMessage(data)를 사용
     function yourJavaScriptFunction() {
         let data = { key: "value" };
         window.webkit.messageHandlers.callbackHandler.postMessage(data);
     }
     */
}


