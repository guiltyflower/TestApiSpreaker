//
//  ContentView.swift
//  TestApiSpreaker
//
//  Created by Giovanni Fioretto on 10/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var show: SpreakerShow?
    
    var body: some View {
        VStack {
            
            if let showImageUrl = show?.imageOriginalUrl, let url = URL(string: showImageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
            }
            
            // Mostra il titolo dello show
            Text(show?.title ?? "Qui il titolo dello show")
                .font(.title)
                .padding()
            
            // Mostra la descrizione dello show
            Text(show?.description ?? "Descrizione dello show")
                .padding()
        }
        .onAppear {
            Task {
                do {
                    show = try await getShow()
                } catch {
                    print("Error fetching show data: \(error)")
                }
            }
        }
        .padding()
    }
    
    func getShow() async throws -> SpreakerShow {
        let endpoint = "https://api.spreaker.com/v2/shows/1693919"
        
        // Testa l'URL per vedere se è valido
        guard let url = URL(string: endpoint) else {
            throw PPError.invalidURL
        }
        
        // Prova ad ottenere i dati dall'URL
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Verifica la risposta
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PPError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let spreakerResponse = try decoder.decode(SpreakerResponse.self, from: data)
            return spreakerResponse.response.show
        } catch {
            throw PPError.invalidData
        }
    }
}

#Preview {
    ContentView()
}


// Risposta completa dell'API di Spreaker
struct SpreakerResponse: Codable {
    let response: SpreakerShowData
}

// Contenitore dei dati dello show
struct SpreakerShowData: Codable {
    let show: SpreakerShow
}

// Modello dello show
struct SpreakerShow: Codable {
    let title: String
    let imageOriginalUrl: String
    let description: String
}

// Enum per gestire gli errori
enum PPError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
