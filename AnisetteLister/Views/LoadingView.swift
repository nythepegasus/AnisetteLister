//
//  LoadingView.swift
//  GetAniList
//
//  Created by ny on 10/27/24.
//

import SwiftUI

enum LoadingState {
    case loading
    case success
    case failure
}

@available(iOS 17.0, tvOS 17.0, *)
struct LoadingView: View {
    @State
    var currentState: LoadingState = .loading
    
    @State
    var text: String = ""
    
    var backgroundColor: Color {
        currentState == .loading ? Color.accent :
        currentState == .success ? Color.green : Color.red
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(backgroundColor)
            .onAppear {
                "Loading...".enumerated().forEach { index, character in
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                        text += String(character)
                    }
                }
                calcResult()
            }
            .onTapGesture {
                if currentState != .loading { currentState = .loading; calcResult() }
            }
            .onChange(of: currentState) {
                switch currentState {
                case .loading:
                    text = ""
                    "Loading...".enumerated().forEach { index, character in
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                            text += String(character)
                        }
                    }
                case .success:
                    text = "Success!"
                case .failure:
                    text = "Failure!"
                }

            }
    }
    
    func calcResult() {
        withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                if Int.random(in: 0...1) == 0 {
                    currentState = .success
                } else {
                    currentState = .failure
                }
            })
        }
    }
}

@available(iOS 17.0, tvOS 17.0, *)
#Preview {
    LoadingView()
}
