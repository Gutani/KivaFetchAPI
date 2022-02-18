//
//  LoanStore.swift
//  KivaAPI
//
//  Created by Gustavo Malheiros on 17/02/22.
//

import Foundation
import Combine


class LoanStore: Decodable, ObservableObject{
    @Published var loans:[Loan] = []
    
    private var cachedLoans:[Loan] = []
    
    private var kivaURL = "https://api.kivaws.org/v1/loans/newest.json"
    
    enum CodingKeys: CodingKey {
        case loans
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        loans = try values.decode([Loan].self, forKey: .loans)
    }
    
    init(){
        
    }
    
    func fetchLoans() {
        guard let loanURL = URL(string: kivaURL) else  {
            return
        }
        
        let request = URLRequest(url: loanURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.loans = self.parseJsonData(data: data)
                    self.cachedLoans = self.loans
                }
            }
        }
        task.resume()
    }
    
    func parseJsonData(data: Data) -> [Loan] {
        do {
            let loanStore = try JSONDecoder().decode(LoanStore.self, from: data)
            self.loans = loanStore.loans
            
            
        }catch {
            print(error)
        }
        
        return loans
    }
    
    func filterLoans(amount: Int ) {
        self.loans = self.cachedLoans.filter { $0.amount < amount}
    }
}
