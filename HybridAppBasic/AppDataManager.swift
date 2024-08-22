//
//  AppDataManager.swift
//  HybridAppBasic
//
//  Created by LeeHoJun on 8/7/24.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreTelephony

// 각종 앱데이터 수집
final class AppDataManager {
    
    // 싱글턴 인스턴스
    static let shared = AppDataManager()
    
    private init() {
        // 초기화 코드가 필요한 경우 여기에 추가
    }
    
    //MARK: 앱 디스플레이 네임 정보
    func getAppDisplayName() -> String{
        if let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String{
            return name
        } else {
            return "네임없음"
        }
    }
    
    //MARK: 앱 현재 버전 정보
    func getAppCurrentVersion() -> String{
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    //MARK: OS 버전 정보
    func getOsCurrentVersion() -> String{
        return UIDevice.current.systemVersion
    }
        
    //MARK: 디바이스 명 정보
    func getDeviceName() -> String?{
        var modelName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"]
        if modelName != nil {
            return modelName
        }
        let device = UIDevice.current
        let selName = "_\("deviceInfo")ForKey:"
        let selector = NSSelectorFromString(selName)
        
        if device.responds(to: selector) { // [옵셔널 체크 실시]
            modelName = String(describing: device.perform(selector, with: "marketing-name").takeRetainedValue())
        }
        return modelName
    }
}
