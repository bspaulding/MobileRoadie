import CoreData

class PerformanceStore : CoreDataStore {
  let entityName = "Performance"
  
  override init() {
    super.init()
    
    storeName = "PerformanceStore"
    storeFilename = "PerformanceStore"
  }
  
  func performances() -> [Performance] {
    let request = NSFetchRequest(entityName: entityName)
    if let context = managedObjectContext {
      do {
        let fetchResult = try context.executeFetchRequest(request) as! [NSManagedObject]
        return fetchResult.map(unwrap)
      } catch {
        let error = error as NSError
        print("Could not fetch \(error), \(error.userInfo)")
      }
    } else {
      print("No context to fetch from");
    }
    
    return [];
  }
  
  func create(performance:Performance) {
    let context = managedObjectContext!
    let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext:context)
    
    let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
    wrap(performance, object)
    
    saveContext(context,
      success: {
        performance.id = object.objectID
        self.emitChange()
      },
      failure: {error in
        print("create failed")
      }
    )
  }
  
  func update(performance:Performance) {
    if let object = findObject(performance) {
      wrap(performance, object)

      saveContext(managedObjectContext!,
        success: {
          self.emitChange()
        },
        failure: {error in
          print("update failed")
        }
      )
    } else {
      print("[PerformanceStore#update] Tried to update a performance that hadn't been persisted yet.")
    }
  }

  func find(performance:Performance) -> Performance? {
    let context = managedObjectContext!
    do {
      let object = try context.existingObjectWithID(performance.id as! NSManagedObjectID)
      return unwrap(object)
    } catch {
      print("Uncaught exception")
      return nil
    }
  }
  
  private func findObject(performance:Performance) -> NSManagedObject? {
    let context = managedObjectContext!
    do {
      return try context.existingObjectWithID(performance.id as! NSManagedObjectID)
    } catch {
      print("Uncaught exception")
      return nil
    }
  }
  
  private var wrap : (Performance, NSManagedObject) -> (NSManagedObject) = {performance, object in
    object.setValue(performance.name, forKey: "name")
    object.setValue(performance.originalMidiFileName, forKey: "originalMidiFileName")
    object.setValue(performance.originalAudioFileName, forKey: "originalAudioFileName")

    return object
  }
  
  private var unwrap : (NSManagedObject) -> (Performance) = {object in
    let performance = Performance(
      id: object.objectID,
      name: object.valueForKey("name") as! String,
      originalMidiFileName: object.valueForKey("originalMidiFileName") as! String,
      originalAudioFileName: object.valueForKey("originalAudioFileName") as! String
    )
    
    return performance
  }

  let stubs = [
    Performance(
      id: "1",
      name: "Blessed Assurance",
      originalMidiFileName: "Blessed Assurance (Axe PCs).mid",
      originalAudioFileName: "Blessed Assurance (Performance Track).m4a"
    ),
    Performance(
      id: "2",
      name: "How Great Thou Art",
      originalMidiFileName: "How Great Thou Art (Axe PCs).mid",
      originalAudioFileName: "How Great Thou Art (Performance Track).m4a"
    )
  ]
  
  // Singleton Pattern
  
  class var sharedInstance: PerformanceStore {
    struct Static {
      static var instance: PerformanceStore?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      Static.instance = PerformanceStore()
    }
    
    return Static.instance!
  }
}