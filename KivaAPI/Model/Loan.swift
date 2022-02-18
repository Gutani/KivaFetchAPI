//
//  Loan.swift
//  KivaAPI
//
//  Created by Gustavo Malheiros on 17/02/22.
//

import Foundation

struct Loan: Identifiable, Codable {
    var id = UUID()
    let name:String
    let country:String
    let use:String
    let amount:Int
    
    
    init(name:String, country:String, use:String, amount:Int) {
        self.name = name
        self.country = country
        self.use = use
        self.amount = amount
    }
    
    enum CodingKeys:String, CodingKey {
        case name
        case country = "location"
        case use
        case amount = "loan_amount"
    }
    
    enum LocationKeys:String, CodingKey {
        case country
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        let location = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
        country = try location.decode(String.self, forKey: .country)
        use = try values.decode(String.self, forKey: .use)
        amount = try values.decode(Int.self, forKey: .amount)
    }

}

