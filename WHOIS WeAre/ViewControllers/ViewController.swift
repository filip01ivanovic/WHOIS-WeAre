//
//  ViewController.swift
//  WHOIS WeAre
//
//  Created by Filip Ivanovic on 25/09/2021.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

/*
 plava zelena lime
 #212121
 #0D7377
 #32E0C4
 #EEEEEE
 
 plava crvena
 082032
 2C394B
 334756
 FF4C29
 */

import UIKit

class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        }*/
        let date = Date()
        /*
        DatabaseFunctions.addNewFavoriteDomain(url: "aleksamm23.rs", expiryDate: date)
        DatabaseFunctions.addNewFavoriteDomain(url: "aleksamm33.rs", expiryDate: date)
        DatabaseFunctions.addNewFavoriteDomain(url: "aleksamm43.rs", expiryDate: date)
        DatabaseFunctions.addNewFavoriteDomain(url: "aleksa32mm.rs", expiryDate: date)
        DatabaseFunctions.addNewFavoriteDomain(url: "zaleksa32mm.rs", expiryDate: date)
        DatabaseFunctions.addNewFavoriteDomain(url: "aaaleksa32mm.rs", expiryDate: date)
         */
        /*
        let arr = DatabaseFunctions.getFavoriteDomains() as! [[String:Any]]
        for v in arr
        {
            print(v["url"] as! String)
        }*/
        requestPermission()
        //sendNotification(dueDate: "")
    }
    
    func requestPermission()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
 
    @IBAction func didTapButton(){

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func didTapButtonOptions(){

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func didTapButtonFavorites(){

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func didTapButtonHistory(){

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: false, completion: nil)
        
    }

}

