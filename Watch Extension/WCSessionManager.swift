import WatchConnectivity

// Note that the WCSessionDelegate must be an NSObject
// So no, you cannot use the nice Swift struct here!
class WCSessionManager: Observable, WCSessionDelegate {
  var context : [String : AnyObject] = ["performances" : []]
  
  // Instantiate the Singleton
  static let sharedManager = WCSessionManager()
  private override init() {
    super.init()
  }
  
  // Keep a reference for the session,
  // which will be used later for sending / receiving data
  private let session = WCSession.defaultSession()
  
  // Activate Session
  // This needs to be called to activate the session before first use!
  func startSession() {
    session.delegate = self
    session.activateSession()
  }
  
  func session(session: WCSession, didReceiveApplicationContext context: [String : AnyObject]) {
    self.context = context
    self.emitChange()
  }
  
  func updateContext() {
    print("updateContext")
    session.sendMessage(["type": "fetch-performances"],
      replyHandler: { context in
        self.context = context
        self.emitChange()
      },
      errorHandler: { error in
      }
    )
  }
}