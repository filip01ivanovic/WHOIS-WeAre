//
//  DatabaseFunctions.swift
//  WHOIS WeAre
//
//  Created by Aleksa on 9/25/21.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import Foundation

class DatabaseFunctions
{
    class func addNewDomainSearch(url: String, dateSearched: Date, expiryDate: Date)
    {
        let dict:[String:Any] = ["url":url, "dateSearched":dateSearched, "expiryDate":expiryDate]
        var arrayOfSearches = UserDefaults.standard.array(forKey: "searchHistory") ?? [[String:Any]]()
        arrayOfSearches.append(dict)
        UserDefaults.standard.set(arrayOfSearches, forKey: "searchHistory")
    }
    class func getDomainSearchHistory() -> [[String:Any]]
    {
        let arrayOfSearches = UserDefaults.standard.array(forKey: "searchHistory") ?? [[String:Any]]()
        return arrayOfSearches as! [[String:Any]]
    }
    class func clearSearchHistory()
    {
        UserDefaults.standard.set([[String:Any]](), forKey: "searchHistory")
    }
    
    class func findDomainIdxInFavoriteDomains(url: String) -> Int
    {
        let allFavoriteDomains = UserDefaults.standard.array(forKey: "favoriteDomains") ?? [[String:Any]]()
        for i in 0..<allFavoriteDomains.count
        {
            let arrayUrl = (allFavoriteDomains[i] as! [String:Any])["url"] as! String
            if arrayUrl == url
            {
                return i
            }
        }
        return -1
    }
    
    class func addNewFavoriteDomain(url: String, expiryDate: Date)
    {
        let dict:[String:Any] = ["url":url,"expiryDate":expiryDate]
        var allFavoriteDomains = UserDefaults.standard.array(forKey: "favoriteDomains") ?? [[String:Any]]()
        let idx = findDomainIdxInFavoriteDomains(url: url)
        if idx == -1
        {
            allFavoriteDomains.append(dict)
            UserDefaults.standard.set(allFavoriteDomains, forKey: "favoriteDomains")
        }
        else
        {
            allFavoriteDomains.remove(at: idx)
            allFavoriteDomains.insert(dict, at: idx)
        }
    }
    class func getFavoriteDomains() -> [[String:Any]]
    {
        let arrayOfFavorites = UserDefaults.standard.array(forKey: "favoriteDomains") ?? [[String:Any]]()
        return arrayOfFavorites as! [[String:Any]]
    }
    class func deleteFavoriteDomain(url: String)
    {
        let idx = findDomainIdxInFavoriteDomains(url: url)
        if idx != -1
        {
            var allFavoriteDomains = UserDefaults.standard.array(forKey: "favoriteDomains") ?? [[String:Any]]()
            allFavoriteDomains.remove(at: idx)
            UserDefaults.standard.set(allFavoriteDomains, forKey: "favoriteDomains")
        }
    }
}
