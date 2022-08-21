//
//  ForecastListViewModel.swift
//  WeatherApp
//
//  Created by Aniket Landge on 04/03/22.
//

import Foundation
import CoreLocation
import UIKit

//View Model for Forecast List View
class ForecastListViewModel: ObservableObject{
    struct AppError: Identifiable{
        let id = UUID().uuidString
        let errorString: String
    }
    
    @Published var forecasts: [ForecastViewModel] = []
    @Published var appError: AppError? = nil
    @Published var isLoading: Bool = false
    @Published var location: String = ""
    var system: Int = 0 {
        didSet{
            for i in 0..<forecasts.count{
                forecasts[i].system = system
            }
        }
    }
    
    func getWeatherForecast(){
        UIApplication.shared.hideKeyboard()
        self.isLoading = true
        let apiService = APIService.shared
        
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error as? CLError {
                switch error.code{
                    
                case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                    self.appError = AppError(errorString: NSLocalizedString("Unable to determine the location from this text", comment: ""))
                case .network:
                    self.appError = AppError(errorString: NSLocalizedString("You do not have to appear to have a network connection", comment: ""))
                default:
                    self.appError = AppError(errorString: error.localizedDescription)
                }
                self.isLoading = false
//                self.appError = AppError(errorString: error.localizedDescription)
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let long = placemarks?.first?.location?.coordinate.longitude {
                
                
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=current,minutely,hourly,alerts&appid=99e267023a3456455ef106477aa4d048", dateDecodingStrategy: .secondsSince1970)
                {(result: Result<Forecast, APIService.APIError>) in
                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.forecasts = forecast.daily.map{ ForecastViewModel(forecast: $0, system: self.system) }
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            self.isLoading = false
//                            self.appError = AppError(errorString: errorString)
                            print(errorString)
                        }
                        
                    }
                    
                }
            }
        }
        
    }
}
