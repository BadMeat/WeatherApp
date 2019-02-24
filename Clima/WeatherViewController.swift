//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate{
    
    
    let locationManger = CLLocationManager()
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    
    //TODO: Declare instance variables here
    let weatherModel = WeatherDataModel()
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:Set up the location manager here.
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeather(url : String, params : [String : String]){
        Alamofire.request(url, method : .get, parameters : params).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success pak")
                let json : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: json)
            }else{
                print("Gagal pak")
            }
        }
    }
    
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON){
        if let temp = json["main"]["temp"].double{
            let city = json["name"].stringValue
            let condition = json["weather"][0]["id"].intValue
            weatherModel.temperatur = Int(temp - 273.15)
            weatherModel.city = city
            weatherModel.condition = condition
            weatherModel.weatherIconName = weatherModel.updateWeatherIcon(condition: condition)
            updateUIWithWeatherData()
        }else{
            cityLabel.text = "Location Unavailable"
        }
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
   
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData(){
        cityLabel.text = weatherModel.city
        temperatureLabel.text = "\(weatherModel.temperatur)"
        weatherIcon.image = UIImage(named : weatherModel.weatherIconName)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            locationManger.delegate = nil
            let lat = "\(location.coordinate.latitude)"
            let lon = "\(location.coordinate.longitude)"
            let params : [String : String] = ["lat":lat,"lon":lon,"APPID":APP_ID]
            getWeather(url: WEATHER_URL, params: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    func getCity(cityName: String) {
        print("City Name = \(cityName)")
        let params : [String : String] = ["q":cityName,"appid":APP_ID]
        getWeather(url: WEATHER_URL, params: params)
    }
    
    //Write the userEnteredANewCityName Delegate method here:
    
    
    
    //Write the PrepareForSegue Method here
    
    
    @IBAction func gotoMovie(_ sender: Any) {
        print("Masuk sini dong")
        performSegue(withIdentifier: "gotoMovie", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoMovie"{
            let desti = segue.destination as! MovieViewController
            desti.dataReceive = "Heloo homan"
        }
        if segue.identifier == "changeCityName"{
            let delegate = segue.destination as! ChangeCityViewController
            delegate.delegate = self
        }
    }
    
}


