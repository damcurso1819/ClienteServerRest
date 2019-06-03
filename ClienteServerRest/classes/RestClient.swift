import Foundation

class RestClient {

    let urlApi: String = "https://curso1819-izvdamdaw.c9users.io/comanda/proyecto/"
    var clausura: ((Data?, URLResponse?, Error?) -> Void)?
    var respuesta: OnResponse?
    var urlPeticion: URLRequest

    init?(service: String, _ method: String = "GET") {
        guard let url = URL(string: self.urlApi + service) else {
            return nil
        }
        self.respuesta = nil
        self.urlPeticion = URLRequest(url: url)
        self.urlPeticion.httpMethod = method
        self.urlPeticion.addValue("application/json", forHTTPHeaderField: "Accept")
        self.urlPeticion.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.urlPeticion.timeoutInterval = 10.0;
    }

    convenience init?(service: String, response: OnResponse?,
          _ method: String = "GET", _ data : [String:Any] = [:]) {
        self.init(service: service, method)
        self.respuesta = response
        if method != "GET" && data.count > 0 {
            guard let json = Util.dictToJson(data: data) else {
                return nil
            }
            self.urlPeticion.httpBody = json
        }
    }

    convenience init?(service:String, method: String, data : [String:Any], response: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.init(service: service, response: nil, method, data);
        self.clausura = response
    }

    convenience init?(service:String, method: String, response: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.init(service: service, response: nil, method);
        self.clausura = response
    }
    
    func request() {
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        let task = sesion.dataTask(with: self.urlPeticion, completionHandler: self.callBack)
        task.resume()
    }
    
    private func callBack(_ data: Data?, _ respuesta: URLResponse?, _ error: Error?) {
        DispatchQueue.main.async {
            if self.respuesta != nil {
                /* la respuesta se procesa con el objeto de la interfaz */
                guard error == nil else {
                    self.respuesta!.onDataError(message: "error http")
                    return
                }
                guard let datos = data else {
                    self.respuesta!.onDataError(message: "error data")
                    return
                }
                if let r = String(data: data!, encoding: .utf8) {
                    print(r)
                }
                self.respuesta!.onData(data: datos)
            } else if self.clausura != nil {
                /* la respuesta se procesa con la clausura */
                if let r = String(data: data!, encoding: .utf8) {
                    print(r)
                }
                self.clausura!(data, respuesta, error)
            } else {
                if let r = String(data: data!, encoding: .utf8) {
                    print(r)
                }
            }
        }
    }
}
