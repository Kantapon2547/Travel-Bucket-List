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
    var isCompleted: Bool = false
}

struct BookingDetailView: View {
    @Binding var booking: Booking
    @Binding var bookings: [Booking] // Added to delete booking from the list
    @Environment(\.dismiss) var dismiss // To dismiss the current view and go back
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 20)
                
                VStack(spacing: 20) {
                    Text(booking.isCompleted ? "Complete" : "Pending")
                        .font(.headline)
                        .foregroundColor(booking.isCompleted ? .green : .white)
                        .padding()
                        .background(booking.isCompleted ? Color.green.opacity(0.2) : Color.gray.opacity(0.4))
                        .cornerRadius(12)
                        .onTapGesture {
                            booking.isCompleted.toggle()
                        }
                    
                    Image(systemName: "airplane.circle.fill")
                        .font(.system(size: 90))
                        .foregroundColor(.white)
                    
                    detailRow("From:", booking.from)
                    detailRow("To:", booking.to)
                    detailRow("Date:", formatDate(booking.date))
                    detailRow("Return:", formatDate(booking.returnDate))
                    detailRow("Passenger(s):", booking.passengers)
                    detailRow("Age Range:", booking.ageRange)
                    
                    // Delete Button
                    Button(action: {
                        if let index = bookings.firstIndex(where: { $0.id == booking.id }) {
                            bookings.remove(at: index)
                        }
                        dismiss() // Go back to the previous screen
                    }) {
                        Text("Delete Booking")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 20)
                    }
                }
                .padding(30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.indigo)
                .cornerRadius(30)
                .padding(.horizontal, 16)
                
                Spacer(minLength: 20)
            }
        }
    }
    
    func detailRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


// MARK: - Book Plan View
struct BookPlanView: View {
    @State private var fromLocation = ""
    @State private var toLocation = ""
    @State private var travelDate = Date()
    @State private var returnDate = Date()
    @State private var passengers = ""
    @State private var ageRange = "Adult"
    @State private var bookings: [Booking] = []
    @State private var selectedBookingID: UUID?
    
    let ageOptions = ["Adult", "Kid"]
    
    var body: some View {
        NavigationStack {
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
                            ForEach(bookings.indices, id: \.self) { index in
                                let booking = bookings[index]
                                dealCard(
                                    date: formatDate(booking.date),
                                    route: "\(booking.from) ⇌ \(booking.to)",
                                    price: "\(booking.passengers) • \(booking.ageRange)"
                                )
                                .background(
                                    NavigationLink(
                                        destination: BookingDetailView(booking: $bookings[index], bookings: $bookings),
                                        isActive: Binding(
                                            get: { selectedBookingID == booking.id },
                                            set: { isActive in
                                                if !isActive {
                                                    selectedBookingID = nil
                                                }
                                            }
                                        )
                                    ) {
                                        EmptyView()
                                    }
                                        .hidden()
                                )
                                .onTapGesture {
                                    selectedBookingID = booking.id
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .background(Color.black.ignoresSafeArea())
        }
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
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    BookPlanView()
}


