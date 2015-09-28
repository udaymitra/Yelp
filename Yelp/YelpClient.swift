//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    class var sharedInstance : YelpClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        }
        return Static.instance!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, completion: (YelpResponse?, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, completion: completion)
    }
    
    func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, location: CLLocationCoordinate2D, radius: Double?, offset: Int = 0, limit: Int = 20, completion: (YelpResponse?, NSError!) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api

        var parameters: [String : AnyObject] = ["term": term, "ll": "\(location.latitude),\(location.longitude)"]

        if sort != nil {
            parameters["sort"] = sort!.rawValue
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joinWithSeparator(",")
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals!
        }
        
        if radius != nil {
            parameters["radius_filter"] = radius!
        }
        
        parameters["limit"] = limit
        
        parameters["offset"] = offset
        
        return self.GET("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let dictionaries = response["businesses"] as? [NSDictionary]
            if dictionaries != nil {
                let businesses = Business.businesses(array: dictionaries!)
                
                let region = response["region"] as! NSDictionary
                let center = region["center"] as! NSDictionary
                let centerLat = center["latitude"] as! Double
                let centerLng = center["longitude"] as! Double
                let span = region["span"] as! NSDictionary
                let latSpanDelta = span["latitude_delta"] as! Double
                let lngSpanDelta = span["longitude_delta"] as! Double
                
                let yelpResponse = YelpResponse(businesses: businesses, centerLat: centerLat, centerLng: centerLng, spanLatitudeDelta: latSpanDelta, spanLongitudeDelta: lngSpanDelta)

                completion(yelpResponse, nil)
            }
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })
    }
    
    func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: (YelpResponse?, NSError!) -> Void) -> AFHTTPRequestOperation {
        // Default the location to San Francisco
        let location = CLLocationCoordinate2D(latitude: 37.785771, longitude: -122.406165)
        
        return searchWithTerm(term, sort: sort, categories: categories, deals: deals, location: location, radius: nil, completion: completion)
    }
}
