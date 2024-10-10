//
//  TranslateApi.swift
//  Translate App
//
//  Created by R95 on 07/10/24.
//

import UIKit

struct Translate: Codable {
    let trans: Trans
}

// MARK: - Trans
struct Trans: Codable {
    let title: String
}

struct Language: Codable {
    let code, language: String
}

var options = [Language]()
var translate: Translate?
