//
//  SearchViewController.swift
//  WHOIS WeAre
//
//  Created by Filip Ivanovic on 25/09/2021.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchTextView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var summaryWhoIsLabel: UILabel!
    @IBOutlet weak var summaryDnsLabel: UILabel!
    @IBOutlet weak var searchResult: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var alarmButton: UIButton!
    
    //var cameFrom
    var urlToSearchFromHistory = ""
    
    var lastQueryUrl = ""
    var lastQueryExpireDate: Date!
    /*
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 */
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        if lastQueryUrl == ""
        {
            return
        }
        DatabaseFunctions.addNewFavoriteDomain(url: lastQueryUrl, expiryDate: lastQueryExpireDate)
        var message: String!
        var title: String!
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            message = "Uspešno dodato u omiljene"
            title = ""
        }
        else {
            message = "Успешно додато у омиљене"
            title = ""
        }
        let alert = Notifications.Alert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
    var placeholderText = ""
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.userInterfaceStyle == .dark {
            searchLabel.textColor = UIColor.white
            searchTextView.backgroundColor = UIColor.white
            searchTextField.textColor = UIColor.black
            searchTextField.backgroundColor = UIColor.white
            searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            searchResult.textColor = UIColor.white
        }
        else {
            searchLabel.textColor = UIColor.black
            searchTextView.backgroundColor = UIColor.systemGray3
            searchTextField.textColor = UIColor.black
            searchTextField.backgroundColor = UIColor.systemGray3
            searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes:[NSAttributedString.Key.foregroundColor: UIColor.systemGray6])
            searchResult.textColor = UIColor.black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //LookupCore.whois(url: "mg.edu.rs", whoisAdr: "whois.rnids.rs")
        //LookupCore.nserverLookup(url: "mg.edu.rs")
        /*
        let arr = LookupCore.allAboutDomain(url: "facebook.com")
        print("<--------------------------------------------------->")
        for v in arr
        {
            print(v)
        }
        */
        
        /*
         searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 3
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.backgroundColor = UIColor.red
         */
        searchTextField.borderStyle = .none
        /*
        searchTextView.layer.shadowRadius = 10
        searchTextView.layer.shadowColor = UIColor.black.cgColor
        searchTextView.layer.shadowOpacity = 1
        */
        if urlToSearchFromHistory != ""
        {
            searchTextField.text = urlToSearchFromHistory
            didTapButtonSearch()
            urlToSearchFromHistory = ""
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            searchLabel.text = "Pretraga"
            placeholderText = "Pretražite"
        }
        else {
            searchLabel.text = "Претрага"
            placeholderText = "Претражите"
        }
        
        if self.traitCollection.userInterfaceStyle == .dark {
            searchLabel.textColor = UIColor.white
            searchTextView.backgroundColor = UIColor.white
            searchTextField.textColor = UIColor.black
            searchTextField.backgroundColor = UIColor.white
            searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            searchResult.textColor = UIColor.white
        }
        else {
            searchLabel.textColor = UIColor.black
            searchTextView.backgroundColor = UIColor.systemGray3
            searchTextField.textColor = UIColor.black
            searchTextField.backgroundColor = UIColor.systemGray3
            searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes:[NSAttributedString.Key.foregroundColor: UIColor.systemGray6])
            searchResult.textColor = UIColor.black
        }
    }
    
    @IBAction func didTapButtonBack() {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: false, completion: nil)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func didTapButtonSearch() {
        let domain = searchTextField.text
        
        if domain != nil
        {
            var arr = LookupCore.allAboutDomain(url: domain ?? "facebook.com")
            //print("<--------------------------------------------------->")
            var result = ""
            for v in arr
            {
                if v == "\n" || v == ""
                {
                    continue
                }
                result += v + "\n"
            }
            if result.count < 4 || result.substring(with: 0..<8) == "No match" || result.substring(with: 0..<7) == "nserver" || result.substring(with: 0..<10) == "No entries"
            {
                searchResult.text = "Nothing found!"
                lastQueryUrl = ""
                favoriteButton.isHidden = true
                favoriteButton.isUserInteractionEnabled = false
                alarmButton.isHidden = true
                alarmButton.isUserInteractionEnabled = false
                return
            }
            /*
            let ipAddress = LookupCore.getDomainIP(url: domain!)
            if ipAddress != nil
            {
                result = "IP: \(ipAddress!)\n" + result
                let countryCode = LookupCore.getCountryCode(ipAddress: ipAddress!)
                if countryCode != ""
                {
                    print(countryCode)
                    print(LookupCore.flag(country: countryCode))
                }
            }*/
            
            var ipAddress = ""
            for v in arr{
                let ip = LookupCore.getAfterOccurence(text: v, pattern: "IP: ")
                if ip != ""
                {
                    ip.replacingOccurrences(of: "\n", with: "")
                    ipAddress = ip
                    break
                }
            }
            if ipAddress != ""
            {
                let countryCode = LookupCore.getCountryCode(ipAddress: ipAddress)
                //print(LookupCore.flag(country: countryCode))
                let flag = LookupCore.flag(country: countryCode)
                arr[0] = arr[0] + "(\(flag))"
            }
            
            result = ""
            for v in arr
            {
                if v == "\n" || v == ""
                {
                    continue
                }
                result += v + "\n"
            }
            
            searchResult.text = result
            let date = LookupCore.getExpiryDate(array: arr, suffix: LookupCore.getAfterOccurence(text: domain!, pattern: ".")) ?? Date()
            DatabaseFunctions.addNewDomainSearch(url: domain!, dateSearched: Date(), expiryDate: date)
            lastQueryUrl = domain!
            lastQueryExpireDate = date
            favoriteButton.isHidden = false
            favoriteButton.isUserInteractionEnabled = true
            alarmButton.isHidden = false
            alarmButton.isUserInteractionEnabled = true
            //Notifications.sendNotification(expiryDate: date, url: domain!, daysBefore: 3)
            
            /*
            //print(LookupCore.getExpiryDate(array: arr, suffix: LookupCore.getAfterOccurence(text: domain!, pattern: ".")) ?? Date())
            let requestedComponents: Set<Calendar.Component> = [
                .year,
                .month,
                .day,
                .hour,
                .minute,
                .second
            ]
            let calendar = Calendar.current
            let dateTimeComponents = calendar.dateComponents(requestedComponents, from: dt)
            print(dateTimeComponents.day,dateTimeComponents.month,dateTimeComponents.year)
             */
            
        }
        dismissKeyboard()
    }
    
    @IBAction func indexChanged(_ sender : Any) {
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            searchLabel.text = "Pretraga"
            searchTextField.placeholder = "Pretražite"
        }
        else {
            searchLabel.text = "Претрага"
            searchTextField.placeholder = "Претражите"
        }
    }
    @IBAction func setExpiryAlarm(_ sender: Any) {
        if lastQueryUrl == ""
        {
            var message: String!
            var title: String!
            if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
                message = "Nevalidna pretraga"
                title = "Greška"
            }
            else {
                message = "Невалидна претрага"
                title = "Грешка"
            }
            let alert = Notifications.Alert(title: title, message: message)
            self.present(alert, animated: true, completion: nil)
            return
        }
        Notifications.sendNotification(expiryDate: lastQueryExpireDate, url: lastQueryUrl, daysBefore: 1)
        var message: String!
        var title: String!
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            message = "Uspešno dodat alarm, stići će Vam notifikacija dan pre isteka domena"
            title = ""
        }
        else {
            message = "Успешно додат аларм, стићи ће Вам нотификација дан пре истека домена"
            title = ""
        }
        let alert = Notifications.Alert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
        DatabaseFunctions.addNewFavoriteDomain(url: lastQueryUrl, expiryDate: lastQueryExpireDate)
    }
}
