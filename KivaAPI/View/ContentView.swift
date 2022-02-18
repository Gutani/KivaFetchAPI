//
//  ContentView.swift
//  KivaAPI
//
//  Created by Gustavo Malheiros on 16/02/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var loanStore = LoanStore()
    @State private var filterEnabled = false
    @State private var maximumLoanAmount = 10000.0
    
    var body: some View {
        NavigationView {
            if filterEnabled {
                LoanFilterView(amount: $maximumLoanAmount).transition(.opacity)
            }
            List{
                ForEach(loanStore.loans) { loan in
                    LoanCellView(loan: loan)
                }
            }
            .listStyle(.plain)
            .onAppear {
                self.loanStore.fetchLoans()
            }
            .navigationTitle("Kiva API Fetch")
        }
        .toolbar {
            Button {
                withAnimation(.linear) {
                    filterEnabled.toggle()
                    loanStore.filterLoans(amount: Int(maximumLoanAmount))
                }
            } label: {
                Text("Filter").foregroundColor(.primary).font(.subheadline)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
