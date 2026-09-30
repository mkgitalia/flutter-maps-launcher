import Flutter
import UIKit
import MapKit
import Foundation

@objc(MapsLauncherPlugin)
public class MapsLauncherPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "maps_launcher", binaryMessenger: registrar.messenger())
    let instance = MapsLauncherPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        
    case "launchQuery":
      guard let args = call.arguments as? [String: Any],
            let query = args["query"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Query mancante o formato non valido", details: nil))
          return
      }
      launchQuery(query: query, result: result)
        
    case "launchCoordinates":
      guard let args = call.arguments as? [String: Any],
            let latitude = args["latitude"] as? Double,
            let longitude = args["longitude"] as? Double else {
          result(FlutterError(code: "INVALID_ARGS", message: "Coordinate mancanti o formato non valido", details: nil))
          return
      }
      // Il pacchetto Dart originale supporta anche un titolo opzionale per il pin
      let title = args["title"] as? String
      launchCoordinates(latitude: latitude, longitude: longitude, title: title, result: result)
        
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
  // MARK: - Metodi privati
    
  private func launchQuery(query: String, result: @escaping FlutterResult) {
      // Codifica la query per gestire spazi e caratteri speciali (es. "Roma, Italia")
      guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "http://maps.apple.com/?q=\(encodedQuery)") else {
          result(FlutterError(code: "URL_ERROR", message: "Impossibile formattare l'URL per la query", details: nil))
          return
      }
      
      UIApplication.shared.open(url, options: [:]) { success in
          result(success)
      }
  }
    
  private func launchCoordinates(latitude: Double, longitude: Double, title: String?, result: @escaping FlutterResult) {
      var urlString = "http://maps.apple.com/?ll=\(latitude),\(longitude)"
      
      // Se viene passato un titolo per il pin, lo aggiungiamo come parametro di ricerca ('q')
      if let title = title, !title.isEmpty, 
         let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
          urlString += "&q=\(encodedTitle)"
      }
      
      guard let url = URL(string: urlString) else {
          result(FlutterError(code: "URL_ERROR", message: "Impossibile formattare l'URL per le coordinate", details: nil))
          return
      }
      
      UIApplication.shared.open(url, options: [:]) { success in
          result(success)
      }
  }
}