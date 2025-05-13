import SwiftUI

// MARK: - Booking Model
struct Booking: Identifiable {
    let id = UUID()
    let date: Date
    let returnDate: Date
    let from: String
    let to: String
    let passengers: String
    let ageRange: String
}

struct BookPlanView: View {
    @State private var fromLocation = ""
    @State private var toLocation = ""
    @State private var travelDate = Date()
    @State private var returnDate = Date()
    @State private var passengers = ""
    @State private var ageRange = "Adult"
    @State private var bookings: [Booking] = [] // Store saved bookings
    
    let ageOptions = ["Adult", "Kid"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Book Your Plan")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    HStack {
                        bookingTextField(title: "From", text: $fromLocation)
                        bookingTextField(title: "To", text: $toLocation)
                    }
                    
                    HStack {
                        bookingTextField(title: "Passenger", text: $passengers)
                        bookingPicker(title: "Age Range", selection: $ageRange, options: ageOptions)
                    }
                    
                    HStack {
                        bookingDatePicker(title: "Date", date: $travelDate)
                        bookingDatePicker(title: "Return", date: $returnDate)
                    }
                    
                    Button(action: {
                        let newBooking = Booking(
                            date: travelDate,
                            returnDate: returnDate,
                            from: fromLocation,
                            to: toLocation,
                            passengers: passengers,
                            ageRange: ageRange
                        )
                        bookings.append(newBooking)
                        
                        // Optional: Clear inputs after saving
                        fromLocation = ""
                        toLocation = ""
                        passengers = ""
                        ageRange = "Adult"
                        travelDate = Date()
                        returnDate = Date()
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.gray)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                Text("Get upto 50% off\non your first flight booking.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.blue)
                
                HStack {
                    Text("Saved Bookings")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(bookings) { booking in
                            dealCard(
                                date: formatDate(booking.date),
                                route: "\(booking.from) ⇌ \(booking.to)",
                                price: "\(booking.passengers) • \(booking.ageRange)"
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom)
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    // MARK: - Subviews
    func bookingTextField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField("Enter \(title.lowercased())", text: text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }
    
    func bookingDatePicker(title: String, date: Binding<Date>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            DatePicker("", selection: date, displayedComponents: .date)
                .labelsHidden()
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }
    
    func bookingPicker(title: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Picker("", selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }
    
    func dealCard(date: String, route: String, price: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "airplane.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(date)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
            Text(route)
                .font(.headline)
                .foregroundColor(.white)
            Text(price)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
        .frame(width: 160, height: 160)
        .background(Color.indigo)
        .cornerRadius(15)
    }
    
    // MARK: - Helpers
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    BookPlanView()
}


