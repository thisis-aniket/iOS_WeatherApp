//
//  ContentView.swift
//  WeatherApp
//
//  Created by Aniket Landge on 23/02/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    //    @State var location = ""
    //    @State var forecast: Forecast? = nil
    //    let dateFormatter = DateFormatter()
    //    init(){
    //       dateFormatter.dateFormat = "E, MMM, d"
    //    }
    
    @StateObject private var forecastListVM = ForecastListViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Picker(selection: $forecastListVM.system, label: Text("System")) {
                        Text("°C").tag(0)
                        Text("°F").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical)
                    .frame(width: 100)
                    
                    HStack {
                        TextField("Enter Location", text: $forecastListVM.location, onCommit: {
                            forecastListVM.getWeatherForecast()
                        })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                Button (action: {
                                    forecastListVM.location = ""
                                }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        
                                })
                                    .padding(.horizontal),
                                alignment: .trailing
                            )
                        
                        Button  {
                            forecastListVM.getWeatherForecast()
                        } label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title)
                        }
                    }
                    //                if let forecast = forecast {
                    List(forecastListVM.forecasts, id: \.day){ day in
                        VStack(alignment: .leading){
                            Text(day.day)
                                .font(.title3)
                                .bold()
                            HStack(alignment: .top){
                                WebImage(url: day.weatherIconURL)
                                    .resizable()
                                    .placeholder{
                                        Image(systemName: "hourglass")
                                    }
                                    .scaledToFit()
                                    .frame(width: 75)
                                VStack(alignment: .leading){
                                    Text(day.overView)
                                        .font(.title2)
                                    HStack {
                                        Text(day.high)
                                        Text(day.low)
                                    }
                                    HStack {
                                        Text(day.clouds)
                                        Text(day.pop)
                                    }
                                    Text(day.humidity)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    //                }else{
                    //                    Spacer()
                    //                }
                }
                .padding(.horizontal)
                .navigationTitle("Weather App")
                .alert(item: $forecastListVM.appError) { appAlert in
                    Alert(title: Text("Error"),
                          message: Text("""
                                \(appAlert.errorString),
                                Try again later!
                            """)
                    )
                }
            }
            if forecastListVM.isLoading {
                ZStack{
                    Color(.white)
                        .opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView("Fetching Weather forecast")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                        )
                        .shadow(radius: 10)
                }
            }
        }
        
    }
    
    //    func getWeatherForecast(for location: String){
    //        let apiService = APIService.shared
    ////        let dateFormatter = DateFormatter()
    ////        dateFormatter.dateFormat = "E, MMM, d"
    //
    //        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
    //            if let error = error {
    //                print(error.localizedDescription)
    //            }
    //            if let lat = placemarks?.first?.location?.coordinate.latitude,
    //               let long = placemarks?.first?.location?.coordinate.longitude {
    //
    //
    //                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=current,minutely,hourly,alerts&appid=99e267023a3456455ef106477aa4d048", dateDecodingStrategy: .secondsSince1970)
    //                {(result: Result<Forecast, APIService.APIError>) in
    //                    switch result {
    //                    case .success(let forecast):
    //                        self.forecast = forecast
    //
    //                    case .failure(let apiError):
    //                        switch apiError {
    //                        case .error(let errorString):
    //                            print(errorString)
    //                        }
    //
    //                    }
    //
    //                }
    //            }
    //
    //        }
    //
    //    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
