//
//  WebViewController.swift
//  Calcudoku Collection App
//
//  Created by gsy on 2023/11/11.
//

import UIKit
import WebKit
import Scrape

class WebViewController: UIViewController {
    
    var code: String = ""
    var label: UILabel? = nil
    @IBOutlet weak var button: UIButton!
    var problem: [[[String]]]? = nil
    var answer: [[Int]]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let width = self.view.frame.width
        let height = self.view.frame.height
        button.frame = CGRect(x: width / 2 - 50, y: height / 2 + 50, width: 100, height: 50)
        button.setTitle("Start Game", for: .normal)
        button.isEnabled = false
        button.backgroundColor = UIColor.cyan
        
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        
        button.layer.cornerRadius = 10
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(button)
        
        label = UILabel(frame: CGRect(x: 0, y: height / 2 - 150, width: width, height: 50))
        label!.text = "Processing, please wait a moment."
        label!.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(label!)
        
        loadData()
    }
    
    func loadData() {
        let mainQueue = DispatchQueue.main
        mainQueue.async {
            let url = ScrapeParse(self.code)
            print(url)
            
            let serverHost = NWEndpoint.Host("127.0.0.1")
            let serverPort = NWEndpoint.Port(9999)
            
            let connection = NWConnection(host: serverHost, port: serverPort, using: .tcp)
            
            connection.stateUpdateHandler = {newState in
                switch newState{
                case .ready:
                    print("connection is ready!")
                    
                    let msg = self.code + "#" + url
                    let msgData = msg.data(using: .utf8)
                    
                    connection.send(content: msgData, completion: .contentProcessed({
                        error in
                        if let error = error{
                            print("send error: \(error)")
                            connection.cancel()
                        }else{
                            print("send message successfully! msg: \(msg)")
                            
                            connection.receive(minimumIncompleteLength: 1, maximumLength: 1024){ (data, context, isComplete, error) in
                                if let data = data{
                                    if let recievedMsg = String(data: data, encoding: .utf8){
                                        print("Recieved message: \(recievedMsg)")
                                        do{
                                            let obj = try JSONSerialization.jsonObject(with: data, options: [])
                                            
                                            if let obj = obj as? NSArray{
                                                if let pro = obj[0] as? [[[String]]]{
                                                    self.problem = pro
                                                }
                                                if let ans = obj[1] as? [[String]]{
                                                    self.answer = ans.map {array in
                                                        return array.map{str in
                                                            if let num = Int(str){
                                                                return num
                                                            }else{
                                                                return 0
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            self.label?.text = "Processing completed, tap below to start game."
                                            self.button.isEnabled = true
                                        }catch{
                                            print("Error when deserializing JSON: \(error)")
                                        }
                                    }
                                }
                                
                                connection.cancel()
                            }
                        }
                    }))
                case .failed(let error):
                    print("Connection failed with error: \(error)")
                    connection.cancel()
                case .cancelled:
                    print("Connection is cancelled")
                case .waiting(let error):
                    print("Connection is waiting: \(error)")
                default:
                    print(newState)
                    break
                }
            }
            
            connection.start(queue: .main)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier != "id1"{
            return
        }
        
        let d = segue.destination as! GameViewController
        let calcudoku = Calcudoku(n: problem!.count)
        calcudoku.load(ans: answer!, pro: problem!)
        d.calcudoku = calcudoku
    }
    
}
