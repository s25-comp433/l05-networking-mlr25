//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Result: Codable, Identifiable {
    var team: String
    var id: Int
    var score: Score
    var date: String
    var opponent: String
    var isHomeGame: Bool
    
    struct Score: Codable {
        var opponent: Int
        var unc: Int
    }
}

struct ContentView: View {
    @State private var results = [Result]()

    var body: some View {
        NavigationView {
            List(results) { item in
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("UNC vs \(item.opponent)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                        Text("\(item.team)")
                            .foregroundStyle(.secondary)
                        Text("Date: \(item.date)")
                            .foregroundStyle(.secondary)
                        Text("Location: \(item.isHomeGame ? "Home" : "Away")")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(item.score.unc) - \(item.score.opponent)")
                        .font(.title3)
                }
            }
            .navigationTitle("UNC Basketball Games")
        }
        .task {
            await loadData()
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                DispatchQueue.main.async {
                    results = decodedResponse
                }
            }
        } catch {
            print("Invalid data")
        }
    }
}


#Preview {
    ContentView()
}
