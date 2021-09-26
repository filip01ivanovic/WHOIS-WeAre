//
//  LookupCore.swift
//  WHOIS WeAre
//
//  Created by Aleksa on 9/25/21.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}

class LookupCore
{
    class func getAfterOccurence(text: String, pattern: String) -> String
    {
        if pattern.count > text.count
        {
            return ""
        }
        var idx = -1
        for i in 0..<(text.count-pattern.count+1)
        {
            if text.substring(with: i..<i+pattern.count) == pattern
            {
                idx = i
            }
        }
        if idx == -1
        {
            return ""
        }
        return text.substring(with: idx+pattern.count..<text.count)
    }
    
    class func whois(url: String, whoisAdr: String) -> [String]
    {
        //https://dumbfounded-workloa.000webhostapp.com/?domain=google.rs&whoisurl=whois.rnids.rs
        let myURLString = "https://dumbfounded-workloa.000webhostapp.com/?domain=\(url)&whoisurl=\(whoisAdr)".encodeUrl
        //print(myURLString)
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return [String]()
        }
        let myHTMLString: String!
        do {
            myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            //print("HTML : \(myHTMLString!)")
        } catch let error {
            print("Error: \(error)")
            return [String]()
        }
        
        let result = myHTMLString!
        
        let arr = result.components(separatedBy: "\n")
        for val in arr{
            print("->",val,"<-")
        }
        
        return arr
        /*
        let leftside = "Data validation:<br />"
        let rightside = "Registrar:"
        guard let leftrange = myHTMLString.range(of: leftside) else{
            print("Greska")
            return
        }
        guard let rightrange = myHTMLString.range(of: rightside) else{
            print("Greska")
            return
        }
        let range = leftrange.upperBound..<rightrange.lowerBound
        let result = myHTMLString[range].trimmingCharacters(in: .whitespacesAndNewlines)
        print("RESULT:")
        print(result)
         */
    }
    class func nserverLookup(url: String) -> [String]
    {
        let myURLString = "https://www.iana.org/whois?q=\(url)".encodeUrl
        print(myURLString)
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return [String]()
        }
        let myHTMLString: String!
        do {
            myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            print("HTML : \(myHTMLString!)")
        } catch let error {
            print("Error: \(error)")
            return [String]()
        }
        let res = myHTMLString!
        
        
        //% IANA WHOIS server\n% for more information on IANA, visit http://www.iana.org\n% This query returned 1 object
        //source:
        
        let leftside = "<pre>"//"\n\nnserver:"
        let rightside = "</pre>"//"\nds-rdata:"
        guard let leftrange = res.range(of: leftside) else{
            print("Greska")
            return [String]()
        }
        guard let rightrange = res.range(of: rightside) else{
            print("Greska")
            return [String]()
        }
        let range = leftrange.upperBound..<rightrange.lowerBound
        let result = res[range]//.trimmingCharacters(in: .whitespacesAndNewlines)
        //print("RESULT:")
        //print(result)
        //print("---------------------------------------------------------")
        let temp_arr = result.components(separatedBy: "\n")
        /*
        var arr = result.components(separatedBy: "\n")
        arr[0] = "nserver:" + arr[0]
        for val in arr{
            print("->",val,"<-")
        }*/
        var arr = [String]()
        //nserver = 7
        for val in temp_arr
        {
            if val.count < 7
            {
                continue
            }
            if val.substring(with: 0..<7) == "nserver"
            {
                arr.append(val)
            }
        }
        return arr

    }
    
    class func allAboutDomain(url: String) -> [String]
    {
        let dom = getAfterOccurence(text: url, pattern: ".")
        let whoisAdr: String!
        switch(dom){
        case "rs", "срб":
            whoisAdr = "whois.rnids.rs"
        case "ru", "рф":
            whoisAdr = "whois.tcinet.ru"
        case "mk", "мкд":
            whoisAdr = "whois.marnet.mk"
        case "org", "орг":
            whoisAdr = "whois.publicinterestregistry.net"
        case "com":
            whoisAdr = "whois.verisign-grs.com"
        case "net":
            whoisAdr = "whois.verisign-grs.com"
        case "uk":
            whoisAdr = "whois.nic.uk"
        case "se":
            whoisAdr = "whois.iis.se"
        default:
            whoisAdr = ""
        }
        if(whoisAdr == ""){return [String]()}
        let whoisData = whois(url: url, whoisAdr: whoisAdr)
        let nserverData = nserverLookup(url: url)
        return whoisData+nserverData
    }
    class func getExpiryDate(array: [String], suffix: String) -> Date?
    {
        //Expiration date: za .rs i .srb
        //expire: za .mkd i .mk
        //paid till za .ru
        switch suffix {
        case "rs", "срб":
            let pattern = "Expiration date:"
            for v in array
            {
                if v.count < pattern.count
                {
                    continue
                }
                if v.substring(with: 0..<pattern.count) == pattern
                {
                    let formated = v.substring(from: pattern.count).trimmingCharacters(in: .whitespaces)
                    /*
                    let day = formated.substring(with: 0..<2)
                    let month = formated.substring(with: 3..<5)
                    let year = formated.substring(with: 6..<10)
                    let hour = formated.substring(with: 11..<13)
                    let minute = formated.substring(with: 14..<16)
                    let seconds = formated.substring(with: 17..<19)
                     */
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                    return dateFormatter.date(from: formated)
                }
            }
        case "mk", "мкд":
            let pattern = "expire:"
            for v in array
            {
                if v.count < pattern.count
                {
                    continue
                }
                if v.substring(with: 0..<pattern.count) == pattern
                {
                    let formated = v.substring(from: pattern.count).trimmingCharacters(in: .whitespaces)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    return dateFormatter.date(from: formated)
                }
            }
        case "ru", "рф":
            let pattern = "paid-till:"
            for v in array
            {
                if v.count < pattern.count
                {
                    continue
                }
                if v.substring(with: 0..<pattern.count) == pattern
                {
                    let formated = v.substring(from: pattern.count).trimmingCharacters(in: .whitespaces)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    return dateFormatter.date(from: formated)
                }
            }
        case "org", "орг":
            let pattern = "Registry Expiry Date:"
            for v in array
            {
                if v.count < pattern.count
                {
                    continue
                }
                if v.substring(with: 0..<pattern.count) == pattern
                {
                    let formated = v.substring(from: pattern.count).trimmingCharacters(in: .whitespaces)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    return dateFormatter.date(from: formated)
                }
            }
        case "com":
            let pattern = "Registry Expiry Date:"
            for v in array
            {
                if v.count < pattern.count
                {
                    continue
                }
                if v.substring(with: 0..<pattern.count) == pattern
                {
                    let formated = v.substring(from: pattern.count).trimmingCharacters(in: .whitespaces)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    return dateFormatter.date(from: formated)
                }
            }
        case "net":
            let pattern = "Registry Expiry Date:"
            for v in array
            {
                if v.count < pattern.count
                {
                    continue
                }
                if v.substring(with: 0..<pattern.count) == pattern
                {
                    let formated = v.substring(from: pattern.count).trimmingCharacters(in: .whitespaces)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    return dateFormatter.date(from: formated)
                }
            }
        case "uk":
            let pattern = "Expiry date:"
            for v in array
            {
                if v.count < pattern.count
                {
                    continue
                }
                if v.substring(with: 0..<pattern.count) == pattern
                {
                    let formated = v.substring(from: pattern.count).trimmingCharacters(in: .whitespaces)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MMM-yyyy"
                    return dateFormatter.date(from: formated)
                }
            }
        case "se":
            let pattern = "expires:"
            for v in array
            {
                if v.count < pattern.count
                {
                    continue
                }
                if v.substring(with: 0..<pattern.count) == pattern
                {
                    let formated = v.substring(from: pattern.count).trimmingCharacters(in: .whitespaces)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    return dateFormatter.date(from: formated)
                }
            }
        default:
            break
        }
        return nil
    }
    class func getDomainIP(url: String) -> String?
    {
        let host = CFHostCreateWithName(nil, url as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let numAddress = String(cString: hostname)
                //print(numAddress)
                return numAddress
            }
        }
        return nil
    }
    class func fetchData(ipAddress: String, completion: @escaping ([String:Any]?, Error?) -> Void) {
        let url = URL(string: "https://freegeoip.app/json/\(ipAddress)")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    class func getCountryCode(ipAddress: String) -> String
    {
        /*
        fetchData(ipAddress: ipAddress) { (dict, error) in
            let countryCode = dict!["country_code"] as! String
            print(countryCode)
        }*/
        let myURLString = "https://freegeoip.app/json/\(ipAddress)"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return ""
        }
        var myHTMLString: String!
        do {
            myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            //print("HTML : \(myHTMLString!)")
        } catch let error {
            print("Error: \(error)")
            return ""
        }
        var str = myHTMLString!
        str = str.replacingOccurrences(of: "{", with: "")
        str = str.replacingOccurrences(of: "}", with: "")
        let arr = str.components(separatedBy: ",")
        //print(arr)
        for v in arr
        {
            var ccode = getAfterOccurence(text: v, pattern: "country_code\":\"")
            if ccode != ""
            {
                ccode = ccode.replacingOccurrences(of: "\"", with: "")
                return ccode
            }
        }
        return ""
    }
    class func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
