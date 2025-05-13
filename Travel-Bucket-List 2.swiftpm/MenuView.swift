import SwiftUI

// Backyard model
struct Backyard: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let backgroundColor: Color
}

let sampleBackyards = [
    Backyard(name: "Sea Travel", imageName: "Sea3", backgroundColor: Color(red: 0.85, green: 0.97, blue: 0.96)),
    Backyard(name: "Mountain tourism", imageName: "Mountain", backgroundColor: Color(red: 0.8, green: 0.9, blue: 1.0)),
    Backyard(name: "Urban tourism", imageName: "Urban", backgroundColor: Color(red: 1.0, green: 0.9, blue: 0.95)),
    Backyard(name: "Rural tourism", imageName: "Rural", backgroundColor: Color(red: 0.85, green: 0.85, blue: 1.0))
]

// Account profile page view
struct AccountProfileView: View {
    let username: String
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var age = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with Home and Logout buttons
                HStack {
                    Text("Home")
                    Spacer()
                    Button("Logout") {
                        // Handle Logout Logic (you can add your actual logout functionality here)
                    }
                    .foregroundColor(.blue)
                }
                .padding()
                .background(Color.green.opacity(0.5))
                
                // Form Section for User Information
                Group {
                    LabeledTextField(label: "Email", text: $email)
                    LabeledTextField(label: "Phone", text: $phone)
                    LabeledTextField(label: "Address", text: $address)
                    LabeledTextField(label: "Age", text: $age)
                }
                .padding(.horizontal)
                
                // Cuisine Selection Section
                Text("Cuisine:")
                    .font(.headline)
                    .padding(.horizontal)
                CuisineSelectionView()
                
                // Places Selection Section
                Text("Places:")
                    .font(.headline)
                    .padding(.horizontal)
                PlaceSelectionView()
                
                // Update Button
                Button(action: {
                    // Handle update logic
                    print("Updated user details")
                }) {
                    Text("Update")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .navigationBarTitle("Account Profile", displayMode: .inline)
    }
}

// Custom TextField with Label
struct LabeledTextField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(label) :")
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

// Cuisine Selection View
struct CuisineSelectionView: View {
    @State private var selectedCuisines: Set<String> = []
    
    let cuisines = ["Thai", "Mexican", "Italian", "Indian", "Chinese", "French", "Spanish"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(cuisines, id: \.self) { cuisine in
                Toggle(cuisine, isOn: Binding(
                    get: { selectedCuisines.contains(cuisine) },
                    set: { isOn in
                        if isOn {
                            selectedCuisines.insert(cuisine)
                        } else {
                            selectedCuisines.remove(cuisine)
                        }
                    }
                ))
            }
        }
        .padding(.horizontal)
    }
}

// Places Selection View
struct PlaceSelectionView: View {
    @State private var selectedPlaces: Set<String> = []
    
    let places = ["Cafe", "Museum", "Beaches", "Parks", "Shopping Mall", "French", "Art Gallery", "Amusement Park"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(places, id: \.self) { place in
                Toggle(place, isOn: Binding(
                    get: { selectedPlaces.contains(place) },
                    set: { isOn in
                        if isOn {
                            selectedPlaces.insert(place)
                        } else {
                            selectedPlaces.remove(place)
                        }
                    }
                ))
            }
        }
        .padding(.horizontal)
    }
}

struct ContentView: View {
    @State private var showMap = false
    @State private var showBookPlan = false
    @State private var selectedTab = "Menu"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Title
                    Text("Travel Bucket")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top, 30)
                    
                    // Search Bar
                    TextField("Search", text: .constant(""))
                        .padding(10)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .padding([.horizontal, .top])
                    
                    // ScrollView of Cards
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(sampleBackyards) { backyard in
                                BackyardCardView(backyard: backyard)
                            }
                        }
                        .padding()
                    }
                    
                    // Spacer to push content up and leave space for tab bar
                    Spacer(minLength: 0)
                }
                
                // Tab bar overlay
                VStack {
                    Spacer()
                    TabViewBar(selectedTab: $selectedTab, showMap: $showMap, showBookPlan: $showBookPlan)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showMap) {
                GoogleMapsWebView(urlString: "https://www.google.com/maps/search/?api=1&query=tourist+spots+near+me")
            }
            // 👇 Hidden NavigationLink for Book Plan
            .background(
                NavigationLink(
                    destination: BookPlanView(),
                    isActive: $showBookPlan,
                    label: { EmptyView() }
                )
            )
        }
        .navigationViewStyle(StackNavigationViewStyle()) // for iPad/iPhone consistency
    }
}


// Backyard card view
struct BackyardCardView: View {
    let backyard: Backyard
    
    var body: some View {
        NavigationLink(destination: TravelDetailView(backyard: backyard)) {
            ZStack(alignment: .topLeading) {
                backyard.backgroundColor
                    .cornerRadius(20)
                    .frame(height: 140)
                    .overlay(
                        HStack {
                            Image(backyard.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 140)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    )
                
                VStack(alignment: .leading) {
                    Text(backyard.name)
                        .font(.headline)
                        .padding(8)
                        .foregroundColor(.black)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .padding([.top, .leading])
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Image(systemName: "star")
                        .padding()
                    Image(systemName: "info.circle")
                        .padding()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)
        }
    }
}


// Tab bar view
struct TabViewBar: View {
    @Binding var selectedTab: String
    @Binding var showMap: Bool
    @Binding var showBookPlan: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                selectedTab = "Menu"
            }) {
                VStack {
                    Image(systemName: "house.fill")
                        .foregroundColor(selectedTab == "Menu" ? .blue : .gray)
                    Text("Menu").font(.caption)
                        .foregroundColor(selectedTab == "Menu" ? .blue : .gray)
                }
            }
            Spacer()
            Button(action: {
                selectedTab = "Place"
                showMap = true
            }) {
                VStack {
                    Image(systemName: "map.fill")
                        .foregroundColor(selectedTab == "Place" ? .blue : .gray)
                    Text("Place").font(.caption)
                        .foregroundColor(selectedTab == "Place" ? .blue : .gray)
                }
            }
            Spacer()
            Button(action: {
                selectedTab = "Book"
                showBookPlan = true
            }) {
                VStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(selectedTab == "Book" ? .blue : .gray)
                    Text("Book Plan").font(.caption)
                        .foregroundColor(selectedTab == "Book" ? .blue : .gray)
                }
            }
            Spacer()
            NavigationLink(destination: AccountProfileView(username: "JohnDoe")) {
                VStack {
                    Image(systemName: "person.circle")
                        .foregroundColor(selectedTab == "Account" ? .blue : .gray)
                    Text("Account").font(.caption)
                        .foregroundColor(selectedTab == "Account" ? .blue : .gray)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray5))
    }
}


struct TravelDetailView: View {
    let backyard: Backyard
    @State private var searchText = ""
    
    var filteredPlaces: [String] {
        let allPlaces = placesByCategory[backyard.name] ?? []
        return searchText.isEmpty ? allPlaces : allPlaces.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(backyard.name)
                .font(.largeTitle)
                .bold()
                .padding()
            
            TextField("Search places", text: $searchText)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            List(filteredPlaces, id: \.self) { place in
                NavigationLink(destination: PreFilledBookPlanView(from: "Myplace", to: place)) {
                    Text(place)
                }
            }
        }
        .navigationTitle(backyard.name)
    }
}

let placesByCategory: [String: [String]] = [
    "Sea Travel": ["Coral Island", "Phuket Beach", "Samet Island", "Similan"],
    "Mountain tourism": ["Doi Inthanon", "Chiang Dao", "Phu Chi Fa", "Khao Kho"],
    "Urban tourism": ["Bangkok", "Singapore", "Tokyo", "New York"],
    "Rural tourism": ["Pai Village", "Sukhothai", "Ubon Retreat", "Nan Fields"]
]
