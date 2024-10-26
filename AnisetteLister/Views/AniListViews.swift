//
//  AniListViews.swift
//  GetAniList
//
//  Created by ny on 10/26/24.
//

import SwiftUI
import CryptoKit

extension AnisetteServer {
    var view: some View {
        Button(action: {
            print("\(name) tapped!")
        }) {
            VStack(alignment: .leading) {
                Text(name)
                    .foregroundStyle(.white)
                    .font(.headline)
                Text(address)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    AnisetteServer.DV.view
        .padding(.all, 20)
        .background(
            Capsule()
                .fill(Color.accent)
        )
}

enum ServerStatus: String, Codable, CaseIterable {
    case online
    case offline
    case unknown
}

extension AnisetteServerList {
    @MainActor
    var listView: some View {
        List {
                Section {
                    ForEach(self.servers) { server in
                        server.view
                            .padding(.all, 0.8)
                            .listRowBackground(
                                Capsule()
                                    .fill(Color.accentColor)
                            )
                    }
                } header: {
                    VStack(alignment: .leading) {
                        Text("Anisette Servers")
                            .font(.title)
                            .foregroundStyle(.accent)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
#if !os(tvOS) && !os(watchOS) && !os(macOS)
            .listRowSpacing(1)
#endif
    }
    
    @MainActor
    var view: some View {
        if #available(iOS 16.0, *) {
            return listView
            #if !os(tvOS)
                .scrollContentBackground(.hidden)
            #endif
        } else {
            return listView
        }
    }
    
    func getServerStatus(server: String) -> ServerStatus? {
        
        
        return .unknown
    }
    
    init(_ url: URL) async {
        do {
            let data = try await urlSession.data(from: url).0
            print("Received \(data.count)")
            if let base = URL(string: "https://\(url.host!)/") {
                print("Getting hash.. at \(base.appendingPathComponent("h"))")
                let hash = await getHash(base.appendingPathComponent("h")).trimmingCharacters(in: .whitespacesAndNewlines)
                let computedHash = Insecure.SHA1.hash(data: data)
                let computedHashString = computedHash.compactMap { String(format: "%02x", $0) }.joined()
                print("Hashes match: \(computedHashString) == \(hash)")
                print("Hashes match: \(computedHashString == hash)")
                if computedHashString != hash {
                    self = .init(servers: [AnisetteServer(name: "Invalid Hash :(", address: "https://ani.sidestore.io")])
                } else {
                    self = try JSONDecoder().decode(AnisetteServerList.self, from: data)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getHash(_ url: URL) async -> String {
        var hash: String = ""
        
        do {
            if let h = String(data: try await urlSession.data(from: url).0, encoding: .utf8) {
                hash = h
            }
        } catch {
            print(error)
        }
        
        return hash
    }
}

#Preview {
    AnisetteServerList.DV.view
}
