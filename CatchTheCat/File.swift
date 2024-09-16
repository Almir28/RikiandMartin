//
//  File.swift
//  CatchTheCat
//
//  Created by Almir Khialov on 14.09.2024.
//

import Foundation

extension Bundle {
    private static var bundleKey: UInt8 = 0

    static func setLanguage(_ language: String) {
        objc_setAssociatedObject(Bundle.main, &bundleKey, language, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        Bundle.swizzleBundleMethods()
    }

    private static func swizzleBundleMethods() {
        guard let originalMethod = class_getClassMethod(Bundle.self, #selector(getter: Bundle.bundlePath)),
              let swizzledMethod = class_getClassMethod(Bundle.self, #selector(Bundle.swizzledBundlePath)) else {
            return
        }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    @objc private func swizzledBundlePath() -> String {
        if let language = objc_getAssociatedObject(Bundle.main, &Bundle.bundleKey) as? String {
            return "\(originalBundlePath())\(language)/"
        }
        return originalBundlePath()
    }

    @objc private func originalBundlePath() -> String {
        return bundlePath
    }
}
