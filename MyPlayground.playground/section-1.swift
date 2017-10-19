// Playground - noun: a place where people can play

import UIKit

let apiKey="519888a010e7325f0ae0bf526d04ae82"

let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
let forecastURL = NSURL(string: "37.8267,-122.423", relativeToURL: baseURL)


