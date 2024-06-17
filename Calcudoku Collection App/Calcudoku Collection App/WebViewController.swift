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

    let webView = WKWebView()
    var code:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view = webView
        loadURL()
        
    }
    
    func loadURL() {
        if let url = URL(string: ScrapeParse(code)) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
