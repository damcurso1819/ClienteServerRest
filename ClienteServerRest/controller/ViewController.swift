import UIKit

class ViewController: UIViewController, OnResponse {
    
    class InternaGetCategoriaOne: OnResponse {
        func onData(data: Data) {
            print("categoria")
            do {
                let decoder = JSONDecoder()
                let categoria = try decoder.decode(Categoria.self, from: data)
                print(categoria)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        func onDataError(message: String) {
            print("error categoria")
        }
    }
    
    class InternaGetCategoriaAll: OnResponse {
        func onData(data: Data) {
            print("categorias")
            do {
                let decoder = JSONDecoder()
                let categorias = try decoder.decode([Categoria].self, from: data)
                print(categorias)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        func onDataError(message: String) {
            print("error categorias")
        }
    }
    
    @IBAction func requestData(_ sender: UIButton) {
        guard let cliente = RestClient(service: "factura/7", response: self) else {
            return
        }
        cliente.request()
        /*self.uso()
        print(NSHomeDirectory())
        //usando el delegado self
        guard let cliente = RestClient(service: "categoria", response: self) else {
            return
        }
        cliente.request()
        //usando el delegado la clase interna 1: All
        let respuestaAll = InternaGetCategoriaAll()
        guard let cliente2 = RestClient(service: "categoria", response: respuestaAll) else {
            return
        }
        cliente2.request()
        //usando el delegado la clase interna 2: One
        let respuestaOne = InternaGetCategoriaOne()
        guard let cliente3 = RestClient(service: "categoria/1", response: respuestaOne) else {
            return
        }
        cliente3.request()
        let urlImagen = "https://catfootwear.com.mx/media/catalog/product/2/1/217208100036_ctdaltonme_nubuckcafe_022.jpg"
        if let url = URL(string: urlImagen) {
            let cola = DispatchQueue(label: "bajar.imagen",
                                     qos: .default,
                                     attributes: .concurrent)
            cola.async {
                if let data = try? Data(contentsOf: url),
                    let imagen = UIImage(data: data) {
                    DispatchQueue.main.async {
                        //self.ivImagen.image = img
                        print (imagen.accessibilityIdentifier ?? "valor no existe")
                        self.save(data: data, name: "imagen")
                    }
                    
                }
            }
        }*/
    }
    
    func read(name: String) -> UIImage {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        let imagePath = paths[0].appendingPathComponent(name)
        return UIImage(contentsOfFile: imagePath.path)!
    }
    
    func save(data: Data, name: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths.description)
        let imagePath = paths[0].appendingPathComponent(name)
        print(imagePath.absoluteString)
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            do {
                let getImage = UIImage(data: data)
                try getImage!.jpegData(compressionQuality:0.3)?.write(to: imagePath)
            }
            catch {
                return
            }
        }
    }
    
    @IBAction func addData(_ sender: UIButton) {
        //usando el delegado clausura
        guard let cliente = RestClient(service: "categoria",
                                       method: "post",
                                       data: ["nombre" : "nuevo"],
                                       response: {(d:Data?, u:URLResponse?, e:Error?) in
                print("fin")
            }
        ) else {
            print("error del cliente")
            return
        }
        cliente.request();
    }
    
    func onData(data: Data) {
        print(data)
        do {
            let decoder = JSONDecoder()
            let categorias = try decoder.decode([Categoria].self, from: data)
            //let categorias = try decoder.decode(Categoria.self, from: data)
            print(categorias)
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    
    func onDataError(message: String) {
        print(message)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //(Int, Int) -> Int
    func suma(op1: Int, op2:Int) -> Int {
        return op1 + op2
    }
    //(Int, Int) -> Int
    func producto(op1: Int, op2:Int) -> Int {
        return op1 * op2
    }
    
    //(Int, Int, (Int, Int) -> Int) -> Int
    func ejecutaFuncion(op1: Int, op2: Int, f: (Int, Int) -> Int) -> Int {
        return f(op1, op2)
    }
    
    func uso() {
        print("Suma: ", ejecutaFuncion(op1: 4, op2: 5, f: suma))
        
        print("Producto: ", ejecutaFuncion(op1: 4, op2: 5, f: producto))
        
        //closure
        print("Op: ", ejecutaFuncion(op1: 4, op2: 5, f: { (o1:Int, o2: Int) -> Int  in
            let r = o1 + o2
            return r * 2
        }))
        
        //trailing closure
        print("Op:", ejecutaFuncion(op1: 4, op2: 5) { o1, o2 in
            let r = o1 + o2
            return r * 2
        })
    }

}
