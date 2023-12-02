//
//  ContentView.swift
//  Coworks App
//
//  Created by Shaina Patel on 11/26/23.
//

import SwiftUI

struct Machine: Identifiable, Equatable {
    let id = UUID()
    let name: String

    // Implement the == operator for the Equatable protocol
    static func ==(lhs: Machine, rhs: Machine) -> Bool {
        return lhs.id == rhs.id
    }
}


class MachineViewModel: ObservableObject {
    @Published var machines: [Machine] = [
        Machine(name: "Industrial Embroidery"),
        Machine(name: "Laser Cutter"),
        Machine(name: "Desktop Embroider"),
        Machine(name: "Vinyl Cutter"),
        Machine(name: "ShopBot"),
        Machine(name: "Electronics")
    ]
}

class BookingViewModel: ObservableObject {
    @Published var selectedDate = Date()
}





struct HomePageView: View {
    // Example image names (replace with your actual image names or references)
    let imageNames = ["beam", "Image", "b", "b 1"]

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Welcome to the BeAM Makerspace")
                    .font(.largeTitle)
                    .foregroundColor(Color.blue)
                    .padding(.top)  // Add padding at the top only
                
                // Horizontal ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {  // Adjust the spacing as needed
                        ForEach(imageNames, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()  // Fill the frame while maintaining the aspect ratio
                                .frame(width: 300, height: 200) // Define a fixed width for each image
                                .clipped()  // Clip the images to the bounds of the frame
                                .cornerRadius(10)  // Optional: if you want rounded corners
                                .padding(.vertical)  // Add padding to top and bottom if needed
                        }
                    }
                }
                .frame(height: 220)

                NavigationLink(destination: MachineSelectionView()) {
                    Text("Book an Appointment")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                }
                .padding()

                NavigationLink(destination: TrainingSelectionView()) {
                    Text("Schedule a Training Session")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                }
                .padding()

                Spacer()
            }
            .navigationBarTitle("BEAM Makerspace", displayMode: .inline)
            .navigationBarItems(trailing: Image(systemName: "person.crop.circle"))
        }
    }
}


struct ProfileView: View {
    var body: some View {
        GeometryReader { geometry in
            Image("p") // Replace with your actual image name
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .ignoresSafeArea() // This will make the image extend into the safe area
        }
        .navigationBarTitle("Profile", displayMode: .inline)
    }
}


struct MoreInfoView: View {
    var body: some View {
        Text("More Information about BeAM Makerspace")
    }
}

struct MainView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(1)

            MoreInfoView()
                .tabItem {
                    Label("More Info", systemImage: "info.circle.fill")
                }
                .tag(2)
        }
    }
}


struct MachineSelectionView: View {
    @StateObject var viewModel = MachineViewModel()
    @State private var selectedMachine: Machine?

    var body: some View {
        List(viewModel.machines) { machine in
            Button(machine.name) {
                selectedMachine = machine
            }
            .buttonStyle(BlueButtonStyle())
            .background(
                NavigationLink(
                    "",
                    destination: AppointmentBookingView(machineName: machine.name),
                    isActive: .constant(selectedMachine == machine)
                ).hidden()
            )
        }
        .navigationBarTitle("Select a Machine")
    }
}

struct AppointmentBookingView: View {
    var machineName: String
    @StateObject var bookingViewModel = BookingViewModel()
    @State private var showConfirmation = false // New state to control navigation

    var body: some View {
        Form {
            Section(header: Text("Machine").foregroundColor(Color.blue)) {
                Text(machineName)
                    .foregroundColor(Color.blue.opacity(0.7))
            }

            Section(header: Text("Select Date & Time").foregroundColor(Color.blue)) {
                DatePicker("Date & Time", selection: $bookingViewModel.selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(Color.blue)
            }

            Section {
                Button("Book Appointment") {
                    self.showConfirmation = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue)
                    .cornerRadius(40)
                    .background(
                        NavigationLink(
                            "",
                            destination: ConfirmationView(machineName: machineName, selectedDate: bookingViewModel.selectedDate),
                            isActive: $showConfirmation
                        )
                        .hidden() // Hide the NavigationLink itself, only use it for navigation
                    )
                }
            }
            .navigationBarTitle("Book Appointment")
    }
}
struct ConfirmationView: View {
    let machineName: String
    let selectedDate: Date

    var body: some View {
        VStack {
            Text("Your Appointment is Confirmed")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            Text("Machine: \(machineName)")
            Text("Date & Time: \(selectedDate.formatted())")
            // Add more details as needed
        }
    }
}


struct TrainingSelectionView: View {
    let trainingSessions = ["BeAM 101", "ShopBot Training", "Wood Shop Training", "Industrial Embroidery Training"]
    @State private var selectedTraining: String?

    var body: some View {
        List(trainingSessions, id: \.self) { session in
            Button(session) {
                selectedTraining = session
            }
            .buttonStyle(BlueButtonStyle())
            .background(
                NavigationLink(
                    "",
                    destination: TrainingTimeSelectionView(trainingName: session),
                    isActive: .constant(selectedTraining == session)
                ).hidden()
            )
        }
        .navigationBarTitle("Select Training")
    }
}


struct TrainingTimeSelectionView: View {
    var trainingName: String
    let times = ["9:00 AM", "1:00 PM", "5:00 PM"]

    var body: some View {
        List {
            ForEach(times, id: \.self) { time in
                Button(action: {
                    // Handle booking the selected time
                }) {
                    HStack {
                        Text(time)
                        Spacer()
                        Image(systemName: "calendar.badge.plus")
                    }
                }
                .buttonStyle(BlueButtonStyle())
            }
        }
        .navigationBarTitle("\(trainingName) Times")
    }
}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
