//
//  ContentView.swift
//  OwnServerRequest
//
//  Created by Tommy Ludwig on 04.04.23.
//

import SwiftUI
import SwiftJWT

struct ContentView: View {
    @State var data: [ViewModel] = []
    @State var tokenForSending: String = ""
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(data, id: \.self) { item in
                        Text(item.name)
                    }
                }
                
                Text(tokenForSending)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await getData()
                        }
                    } label: {
                        Text("Get Data")
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        Task {
                            try await getToken()
                        }
                    } label: {
                        Text("Get Token")
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
            }
        }
    }
    
    func getToken() async throws {
//        let url = URL(string: "http://localhost:3000/token")!
        let url = URL(string: "http://0.0.0.0:3000/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["message": "test test"]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else { return }
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error as Any)
                return
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: ", responseString)
                self.tokenForSending = responseString
            }
        }.resume()
    }
    
    func getData() async {
        // generate JWT
        let key = "testKEY"
        let header = Header(typ: "JWT")
        let claims = MyClaims(iss: "Tom", sub: "Data", exp: Date(timeIntervalSinceNow: 360000), appId: "appId", admin: true)
        var jwt = JWT(header: header, claims: claims)
        
        guard let keyData = key.data(using: .utf8) else {
            fatalError("Could not convert key to data")
        }
            
        let signedJWT = try? jwt.sign(using: .hs256(key: keyData))
//        let url = URL(string: "http://localhost:3000/protected")!
        let url = URL(string: "http://0.0.0.0:3000/protected")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(String(describing: tokenForSending))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let result = try decoder.decode([ViewModel].self, from: data)
            DispatchQueue.main.async {
                self.data = result
            }
            
        } catch {
            print("An error occured while fetching the data: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
