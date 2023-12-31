//
//  DataController.swift
//  Portfolio
//
//  Created by Emma Walker on 02/09/2023.
//

import CoreData

// make it observable so a model view can observe the object and update as required
class DataController: ObservableObject {
    // Cloud kit allows local and remote data sync
    //  is responsible for loading and managing local data using Core Data, but also synchronizing that data with iCloud so that all a user’s devices get to share the same data for our app.
    let container: NSPersistentCloudKitContainer
    
    @Published var selectedFilter: Filter? = Filter.all
    
    // Set up SwiftUI preview with core data - hit and miss if it works!
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentCloudKitContainer(name: "Main")
        
        // When this is set to true, we’ll create our data entirely in memory rather than on disk, which means it will just disappear when the application ends – helpful for writing tests.
        if inMemory {
            // write this file to nowhere
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        // this is long term storage
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    func createSampleData() {
        // this is the pool of data loaded from disk right now
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(i)"
            
            for j in 1...10 {
                let resource = Resource(context: viewContext)
                resource.title = "Resource \(i)-\(j)"
                resource.content = "Description goes here"
                tag.addToResources(resource)
            }
        }
        //  tells Core Data to write all those new objects to the persistent storage. That might be in memory, in which case it won’t last long, but it might also be permanent storage, in which case it will last for as long as our app is installed, and will even sync up to iCloud if the user has an active iCloud account.
        try? viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    //  all Core Data classes (including the Resource and Tag classes that Xcode generated for us) inherit from a parent class called NSManagedObject.
    func delete(_ object: NSManagedObject) {
        // notify observers object will change
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    // batch delete - lots of obscure code
    /*
     This method needs to use a fetch request to find and delete all the issues we have, which takes three steps:

     Using a fetchRequest() method on Issue, which is automatically generated by Xcode. This tells Core Data to look for resources, without specifying any kind of filter.
     Wrap that fetch request in a batch delete request, which tells Core Data to delete all objects that match the request – i.e., all issues.
     Execute that batch delete request on our view context.
     */
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        // tell me what you deleted
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            // dictionary of things that have been deleted
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObject] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    // find and delete all Tags and Resources
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Resource.fetchRequest()
        delete(request2)
        
        save()
    }
}
