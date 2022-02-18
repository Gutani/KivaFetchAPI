//
//  ContentView.swift
//  KivaAPI
//
//  Created by Gustavo Malheiros on 16/02/22.
//

import SwiftUI
import BottomSheet

public enum BottomSheetPositions: CGFloat, CaseIterable {
    case middle = 0.4, bottom = 0.1
}

struct ContentView: View {
    @ObservedObject var loanStore = LoanStore()
    @State private var filterEnabled = false
    @State private var maximumLoanAmount = 5000.0
    
    @State var amount: Double = 5000.0
    var minAmount = 0.0
    var maxAmount = 5000.0
    
    
    @State var bottomSheetPosition: BottomSheetPositions = .middle
    
    var body: some View {
        NavigationView {
            
            ZStack {
                List{
                    ForEach(loanStore.loans) { loan in
                        LoanCellView(loan: loan)
                    }
                }.refreshable {
                    self.loanStore.fetchLoans()
                }
                .listStyle(.plain)
                .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition , options: [.background(AnyView(Color.gray.opacity(0.9))), .noBottomPosition, .cornerRadius(30)] ,headerContent: {
                    VStack {
                        Text("Filter the value you want to show").bold().font(.title2)                                    .foregroundColor(.white)

                        Divider()
                        Text("Showing loan amount below $ \(Int(amount))")
                            .font(.system(.headline, design: .rounded))
                            .padding()
                            .foregroundColor(.white)

                    }
                    
                    
                }) {
                    
                    if bottomSheetPosition == .middle {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Slider(value: $amount, in: minAmount...maxAmount, step: 100)
                                    .accentColor(Color(red: 0.28, green: 0.28, blue: 0.53))
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("\(Int(minAmount))")
                                    .font(.system(.footnote, design: .rounded))
                                Spacer()
                                Text("\(Int(maxAmount))")
                                    .font(.system(.footnote, design: .rounded))
                            }.foregroundColor(.white)

                            
                            Button {
                                self.loanStore.filterLoans(amount: Int(amount))
                            } label: {
                                Text("filter".uppercased())
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color(red: 0.28, green: 0.28, blue: 0.53))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.horizontal)
                        .transition(.opacity)
                        .foregroundColor(.white)
                    }
                    
                    
                }
                
                
                
            }
            .navigationTitle("Kiva API Fetch").navigationBarTitleDisplayMode(.inline).foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.53))
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.loanStore.fetchLoans()
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
