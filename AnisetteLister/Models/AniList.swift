//
//  AniList.swift
//  GetAniList
//
//  Created by ny on 10/26/24.
//

import Foundation

import SwiftUI

import Defaultable
import DefaultableFoundation
import NYDecodable
import NYDecodableErrorLoggers

public struct AnisetteServer: Codable, Hashable, Identifiable, Defaultable, NYErrorLogger {
    public static var DV: AnisetteServer { .init(name: "SideStore", address: "https://ani.sidestore.io") }
    
    public var id: UUID = .init()
    var name: String
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case name, address
    }
    
    public static func handleError(_ result: Result<Data?, Error>, _ data: Data? = nil) {
        switch result {
        case .success: return
        case .failure(let error):
            print(error.localizedDescription)
            print(error)
            if let data {
                print(String(data: data, encoding: .utf8)~)
            }
        }
    }
}


public struct AnisetteServerList: Codable, Hashable, Identifiable, Defaultable, NYErrorLogger {
    public static var DV: AnisetteServerList { .init(servers: Array(repeating: .DV, count: 10)) }
    
    public var id: UUID = .init()
    var servers: [AnisetteServer] = []
    
    enum CodingKeys: String, CodingKey {
        case servers
    }
    
    var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        return URLSession(configuration: config)
    }()

    init(servers: [AnisetteServer] = []) {
        self.servers = servers
    }

    public static func handleError(_ result: Result<Data?, Error>, _ data: Data? = nil) {
        switch result {
        case .success: return
        case .failure(let error):
            print(error.localizedDescription)
            print(error)
            if let data {
                print(String(data: data, encoding: .utf8)~)
            }
        }
    }
}

