import Foundation

class Util {
    
    static func dictToJson(data: [String:Any]) -> Data? {
        guard let json = try? JSONSerialization.data(withJSONObject: data as Any, options: []) else {
            return nil
        }
        return json
    }
    
    static func jsonToDict(data: Data) -> [String: Any]? {
        guard let diccionario = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        return diccionario
    }
    
}
