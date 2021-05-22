//
//  ViewController.swift
//  wiki
//
//  Created by Mac11 on 22/05/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var textfieldbuscar: UITextField!
    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let urlWikipedia = URL(string: "wikipedia.png")
        webview.load(URLRequest(url: urlWikipedia!))
        
    }

    @IBAction func buscarButton(_ sender: UIButton) {
        textfieldbuscar.resignFirstResponder()
        guard let buscar = textfieldbuscar.text else { return
            
        }
        buscarWikipedia(palabras: buscar)
    }
    func buscarWikipedia(palabras: String){
        if let urlAPI = URL(string: "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(palabras)"){
            let peticion = URLRequest(url: urlAPI)
            let tarea = URLSession.shared.dataTask(with: peticion) { (datos, respuesta, errr) in
                if errr != nil {
                    print(errr?.localizedDescription)
                }else{
                    do{
                        let objJson = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject //as! JSONSerialization.ReadingOptions)
                     
                        let querySubJson = objJson["query"] as! [String: Any]
                            
                        let pagesSubJson = querySubJson["pages"] as! [String: Any]
                        
                        let pageId = pagesSubJson.keys
                        
                        let llaveExtracto = pageId.first!
                        
                       if pageId.first == "-1" {
                            DispatchQueue.main.async {
                                self.webview.loadHTMLString("<h1>no se encontro la palabra. </h1>", baseURL: nil)
                            }
                       }
                        
                        let idSubJson = pagesSubJson[llaveExtracto] as! [String: Any]
                        
                        if let extracto = idSubJson["extract"] as? String {
                       print(extracto)
                  DispatchQueue.main.async {
                            self.webview.loadHTMLString(extracto ?? "<H1> 0 Resultaddos </H1>", baseURL: nil)
                        }
                       }
                       print("el json es: \(objJson)")
                       }catch{
                        print("error al procesar el JSON \(String(describing: errr?.localizedDescription))")
                    }
                }
            }
            tarea.resume()
        }
    }
}

