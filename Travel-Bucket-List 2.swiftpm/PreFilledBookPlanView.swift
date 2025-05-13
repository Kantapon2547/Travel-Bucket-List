import SwiftUI

struct PreFilledBookPlanView: View {
    let from: String
    let to: String
    
    @State private var date = Date()
    @State private var returnDate = Date()
    @State private var passengerCount = 1
    @State private var selectedClass = "Economy"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Book Your Plan")
                    .font(.largeTitle)
                    .bold()
                
                Group {
                    HStack {
                        Text("From:")
                        Spacer()
                        Text(from)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("To:")
                        Spacer()
                        Text(to)
                            .foregroundColor(.gray)
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Return", selection: $returnDate, displayedComponents: .date)
                    
                    Stepper("Passenger: \(passengerCount)", value: $passengerCount, in: 1...10)
                    
                    Picker("Class", selection: $selectedClass) {
                        Text("Economy").tag("Economy")
                        Text("Business").tag("Business")
                        Text("First Class").tag("First Class")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Button(action: {
                    // Perform booking logic here
                }) {
                    Text("Book Now")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Book Plan")
    }
}
