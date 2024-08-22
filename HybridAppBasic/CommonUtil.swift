//
//  CommonUtil.swift
//  HybridAppBasic
//
//  Created by LeeHoJun on 8/14/24.
//

import UIKit
import Photos
import AVFoundation
import CoreMotion
import UserNotifications
import LocalAuthentication
import CommonCrypto

final class CommonUtil {
    
    // 싱글턴 인스턴스
    static let shared = CommonUtil()
    
    private init() {
        // 초기화 코드가 필요한 경우 여기에 추가
    }
    
    // 암호 및 생체인증 등록 여부확인
    func checkLockOrBiometricAuth() {
        let context = LAContext()
        var error: NSError?
        
        // 암호 등록 상태
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            print("암호 등록 상태")
        } else {
            print("암호 미등록 상태 또는 사용 불가 상태")
        }
        
        // 암호 및 생체인증 등록 상태
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            print("암호 및 생체인증 등록 상태")
        } else {
            print("암호 또는 생체인증 미등록 상태 or 생체인증 사용 불가 상태")
        }
    }
    
    // Set localStorage
    func setLocalStorage(message: String) -> String {
        let jsString = "localStorage.setItem('message', '\(message)')"
        print("set localStorage 성공")
        return jsString
    }
    
    // Get localStorage
    func getLocalStorage(message: String) -> String {
        let jsString = "localStorage.getItem('\(message)')"
        print("get localStorage 성공")
        return jsString
    }
    
    // Remove localStorage
    func removeLocalStorage(message: String) -> String {
        let jsString = "localStorage.removeItem('\(message)')"
        print("remove localStorage 성공")
        return jsString
    }
    
    // Clear all localStorage
    func clearLocalStorage() -> String {
        let clearString = "localStorage.clear()"
        print("clear localStorage 성공")
        return clearString
    }
    
    // 외부 사파리 브라우저 호출
    func goToSafariBrowser(urlStr: String) {
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    print("실행된 url : \(url)")
                } else {
                    print("사파리 브라우저를 실행하지 못 하였습니다.")
                }
            }
        }
    }
    
    // 클립보드에 복사하기
    func copyToClipboard(copyString: String) {
        UIPasteboard.general.string = copyString
        print("클립보드에 복사하기")
    }
    
    // 클립보드에서 값 가져오기
    func pasteFromClipboard() -> String? {
        print("클립보드에서 가져오기")
        return UIPasteboard.general.string
    }
    
    // 전화 걸기
    func phoneCall(telNum: String) {
        let telNumStr = "tel://\(telNum)"
        if let url = URL(string: telNumStr), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            print("전화번호 URL : \(telNumStr)")
        } else {
            print("전화걸기 실패")
        }
    }
    
    // 환경설정 열기
    func goToPreferences() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    print("설정 화면 열기 성공")
                } else {
                    print("설정 화면 열기 실패")
                }
            }
        }
    }
    
    // 사진 권한 체크
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            print("사진 권한 허용")
        case .denied, .restricted:
            print("사진 권한 거절")
        case .notDetermined:
            print("사진 권한 미결정")
        default:
            print("권한 오류")
        }
    }
    
    // 마이크 권한 체크
    func checkMicPermission() {
        let status = AVAudioSession.sharedInstance().recordPermission
        switch status {
        case .granted:
            print("마이크 권한 허용")
        case .denied:
            print("마이크 권한 거절")
        case .undetermined:
            print("마이크 권한 미결정")
        default:
            print("권한 오류")
        }
    }
    
    // 모션 권한 체크
    func checkMotionPermission() {
        let status = CMMotionActivityManager.authorizationStatus()
        switch status {
        case .authorized:
            print("모션 권한 허용")
        case .restricted, .denied:
            print("모션 권한 거절")
        case .notDetermined:
            print("모션 권한 미결정")
        default:
            print("권한 오류")
        }
    }
    
    // 푸시 권한 체크
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("푸시 권한 허용")
            case .denied:
                print("푸시 권한 거부")
            case .notDetermined:
                print("푸시 권한 미결정")
            default:
                print("권한 오류")
            }
        }
    }
    
    // 이미지 변환 및 저장
    // EncodeDataStr로 받은 경우
    func storeImageFromEncdata(strEncodeData: String) {
        if let decodeData = Data(base64Encoded: strEncodeData) {
            if let img = UIImage(data: decodeData) {
                UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("error: \(error.localizedDescription)")
        } else {
            print("이미지 저장 완료")
        }
    }
    
    // SHA256 암호화
    static func encryptSHA256(input: String) -> String {
        guard let data = input.data(using: .utf8) else { return "" }
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
