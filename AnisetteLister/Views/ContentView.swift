//
//  ContentView.swift
//  GetAniList
//
//  Created by ny on 10/26/24.
//

import SwiftUI

import Defaultable

struct ContentView: View {
    @State
    var serverList: AnisetteServerList = AnisetteServerList()
    
    @AppStorage("anisetteURL")
    var url: String = "https://s.nythepegas.us/servers.json"
    
    var body: some View {
        VStack {
            TextField("URL", text: $url)
                .onSubmit { Task { await fetchServers() } }
                .padding()
            serverList.view
                .onAppear { Task { await fetchServers() } }
        }
        .background(Color.accent.opacity(0.7))
    }
    
    func fetchServers() async {
        print("Fetching server list from \(url)")
        serverList = await AnisetteServerList(URL(string: url)~)
    }
}

#Preview {
    ContentView()
}
