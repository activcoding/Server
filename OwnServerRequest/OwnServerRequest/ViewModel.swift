//
//  ViewModel.swift
//  OwnServerRequest
//
//  Created by Tommy Ludwig on 04.04.23.
//

import Foundation

struct ViewModel: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var age: String = ""
    var email: String = ""
    
    init() {}
    
    enum CodingKeys: CodingKey {
        case name
        case age
        case email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(String.self, forKey: .age)
        email = try container.decode(String.self, forKey: .email)
    }
    
    static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
        lhs.name == rhs.name && lhs.age == rhs.age && lhs.email == rhs.email
    }
    
}
