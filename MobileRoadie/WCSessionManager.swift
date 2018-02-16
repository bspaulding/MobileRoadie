import WatchConnectivity

// Note that the WCSessionDelegate must be an NSObject
// So no, you cannot use the nice Swift struct here!
class WCSessionManager: NSObject, WCSessionDelegate {
  
  // Instantiate the Singleton
  static let sharedManager = WCSessionManager()
  private override init() {
    super.init()
  }
  
  // Keep a reference for the session,
  // which will be used later for sending / receiving data
  private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
  
  private var validSession: WCSession? {
    if let session = session where session.paired && session.watchAppInstalled {
      return session
    }
    
    return nil
  }
  
  // Activate Session
  // This needs to be called to activate the session before first use!
  func startSession() {
    session?.delegate = self
    session?.activateSession()
  }
  
  func updateApplicationContext(applicationContext: [String : AnyObject]) {
    if let session = validSession {
      do {
        try session.updateApplicationContext(applicationContext)
      } catch let error {
        //        throw error
        print(error)
      }
    }
  }
  
  func session(session: WCSession,
    didReceiveMessage message: [String : AnyObject],
    replyHandler: ([String : AnyObject]) -> Void) {
      if (message["type"] as? String == "fetch-performances") {
        let performances = PerformanceStore().performances().map({ performance in
          return [
            "id": performance.id!,
            "name": performance.name
          ]
        })
        
        replyHandler([
          "performances": performances
        ])
      }
  }
}