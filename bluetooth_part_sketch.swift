


//in AppDelegate.swift



class AppDelegate: UIResponder, UIApplicationDelegate, CBCentralManagerDelegate {

  var centralManager : CBCentralManager?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    

    // ...

    // what's the logic for when to do the scanning and such?
    
    centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "centralManager"])

    return true

  }






  //MARK: CBCentralManagerDelegate
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
      
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
      <#code#>
  }
  
  func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
      <#code#>
  }
  
  func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
      <#code#>
  }
  
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
      <#code#>
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
      <#code#>
  }
  
  func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
      <#code#>
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
      <#code#>
  }








