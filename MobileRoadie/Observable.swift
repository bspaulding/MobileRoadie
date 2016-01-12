import Foundation

class Observable : NSObject { // I wish this was a mixin! Gah!
  var listeners : [() -> ()] = []

  func register(callback:()->()) {
    listeners.append(callback)
  }
  
  func emitChange() {
    for listener in listeners {
      listener()
    }
  }
}