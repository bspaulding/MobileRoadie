import Foundation
import CoreData

class CoreDataStore: Observable {
  
  var storeName : String = "CoreDataStoreName";
  var storeFilename : String = "CoreDataStoreFilename";
  
  // From Base Class in Example
  
  lazy var applicationDocumentsDirectory: NSURL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "me.iascchen.MyTTT" in the application's documents Application Support directory.
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1] as NSURL
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.storeFilename)
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application's saved data."
    let options = [
      NSMigratePersistentStoresAutomaticallyOption: true,
      NSInferMappingModelAutomaticallyOption: true
    ]
    do {
      try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
    } catch var error1 as NSError {
      error = error1
      coordinator = nil
      // Report any error we got.
      let dict : [NSObject : AnyObject] = [
        NSLocalizedDescriptionKey: "Failed to initialize the application's saved data" as NSString,
        NSLocalizedFailureReasonErrorKey: failureReason as NSString,
//        NSUnderlyingErrorKey: error
      ]
      error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(error), \(error!.userInfo)")
      abort()
    } catch {
      fatalError()
    }
    
    return coordinator
    }()
  
  // From CoreDataHelper in Example
  
  override init(){
    super.init()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidSaveContext:", name: NSManagedObjectContextDidSaveNotification, object: nil)
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  lazy var managedObjectContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
  
  // Returns the background object context for the application.
  // You can use it to process bulk data update in background.
  // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
  
  lazy var backgroundContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
    backgroundContext.persistentStoreCoordinator = coordinator
    return backgroundContext
    }()
  
  
  // save NSManagedObjectContext
  func saveContext (context: NSManagedObjectContext, success:()->(), failure:(error:NSError)->()) {
    if context.hasChanges {
      do {
        try context.save();
        success();
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let error = error as NSError
        NSLog("Unresolved error \(error), \(error.userInfo)")
        failure(error: error)
      }
    } else {
      success()
    }
  }
  
  func saveContext (success:()->(), failure:(error:NSError)->()) {
    self.saveContext(self.backgroundContext!, success: success, failure: failure)
  }
  
  // call back function by saveContext, support multi-thread
  func contextDidSaveContext(notification: NSNotification) {
    let sender = notification.object as! NSManagedObjectContext
    if sender === self.managedObjectContext {
      NSLog("******** Saved main Context in this thread")
      self.backgroundContext!.performBlock {
        self.backgroundContext!.mergeChangesFromContextDidSaveNotification(notification)
      }
    } else if sender === self.backgroundContext {
      NSLog("******** Saved background Context in this thread")
      self.managedObjectContext!.performBlock {
        self.managedObjectContext!.mergeChangesFromContextDidSaveNotification(notification)
      }
    } else {
      NSLog("******** Saved Context in other thread")
      self.backgroundContext!.performBlock {
        self.backgroundContext!.mergeChangesFromContextDidSaveNotification(notification)
      }
      self.managedObjectContext!.performBlock {
        self.managedObjectContext!.mergeChangesFromContextDidSaveNotification(notification)
      }
    }
  }
}