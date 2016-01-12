import Foundation

class SharedFilesStore {
  func files() -> [String] {
    let manager = NSFileManager.defaultManager()
    do {
      let fileList : [String] = try manager.contentsOfDirectoryAtPath(documentsDirectory()) as [String]
      return fileList
    } catch {
      return []
    }
  }
  
  func audioFiles() -> [String] {
    return files().filter({filename in
      let filename : NSString = filename
      return filename.containsString(".m4a") ||
             filename.containsString(".wav") ||
             filename.containsString(".aif") ||
             filename.containsString(".caf")
    })
  }
  
  func midiFiles() -> [String] {
    return files().filter({filename in
      let filename : NSString = filename
      return filename.containsString(".mid")
    })
  }
  
  func urlForFile(filename:String) -> NSURL {
    let path = "\(documentsDirectory())/\(filename)"
    return NSURL.fileURLWithPath(path)
  }
  
  private func documentsDirectory() -> String {
    let paths : NSArray = NSSearchPathForDirectoriesInDomains(
      NSSearchPathDirectory.DocumentDirectory,
      NSSearchPathDomainMask.UserDomainMask,
      true
    )
    return paths.objectAtIndex(0) as! String
  }
}