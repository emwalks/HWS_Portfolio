//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by Emma Walker on 02/09/2023.
//

import SwiftUI

@main
struct PortfolioApp: App {
    // This means our app will create and own the data controller, ensuring it stays alive for the duration of our app’s runtime.
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // we need to send our data controller’s view context into the SwiftUI environment using a special key called .managedObjectContext. This is because every time SwiftUI wants to query Core Data it needs to know where to look for all the data, so this effectively connects Core Data to SwiftUI.
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
