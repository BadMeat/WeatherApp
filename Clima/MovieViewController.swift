//
//  MovieViewController.swift
//  Clima
//
//  Created by ogya 1 on 23/02/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MovieViewController: UIViewController {

    let URL : String = "https://newsapi.org/v2/top-headlines"
    let COUNTRY = "id"
    let APIKEY = "6fc7f8811570490fbed93e74108c0bfd"
    
    @IBOutlet weak var newsDes: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    var dataReceive : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTitle.text = dataReceive
        // Do any additional setup after loading the view.
        getData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getData(){
        let params : [String:String] = ["country":COUNTRY,"apiKey":APIKEY]
        Alamofire.request(URL,method : .get, parameters : params).responseJSON {
            response in
            if response.result.isSuccess{
                let json = JSON(response.result.value!)
                self.fetchData(json: json)
            }else{
                print("Gagal load data")
            }
        }
    }
    
    func fetchData(json : JSON){
        let title = (json["articles"][0]["title"]).stringValue
        let content = (json["articles"][0]["description"]).stringValue
        updateUI(title: title, des: content)
    }
    
    func updateUI(title : String, des : String){
        newsTitle.text = title
        newsDes.text = des
        
    }

}
