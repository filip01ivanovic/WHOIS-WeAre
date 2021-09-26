//
//  OptionsViewController.swift
//  WHOIS WeAre
//
//  Created by Filip Ivanovic on 25/09/2021.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var deleteHistoryLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.userInterfaceStyle == .dark {
            optionsLabel.textColor = UIColor.white
            deleteHistoryLabel.textColor = UIColor.white
        }
        else {
            optionsLabel.textColor = UIColor.black
            deleteHistoryLabel.textColor = UIColor.black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "alphabet")
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
        
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            optionsLabel.text = "Podešavanja"
        }
        else {
            optionsLabel.text = "Подешавања"
        }
        
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            deleteHistoryLabel.text = "Obriši istoriju"
        }
        else {
            deleteHistoryLabel.text = "Обриши историју"
        }
        
        if self.traitCollection.userInterfaceStyle == .dark {
            optionsLabel.textColor = UIColor.white
            deleteHistoryLabel.textColor = UIColor.white
        }
        else {
            optionsLabel.textColor = UIColor.black
            deleteHistoryLabel.textColor = UIColor.black
        }
        
    }
    
    
    @IBAction func didTapButtonBack(){

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @IBAction func indexChanged(_ sender : Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(0, forKey: "alphabet")
        case 1:
            UserDefaults.standard.set(1, forKey: "alphabet")
        default:
            break;
        }
        
        //print(UserDefaults.standard.integer(forKey: "alphabet"))
        
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            optionsLabel.text = "Podešavanja"
        }
        else {
            optionsLabel.text = "Подешавања"
        }
        
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            deleteHistoryLabel.text = "Obriši istoriju"
        }
        else {
            deleteHistoryLabel.text = "Обриши историју"
        }
        
        
        
    }
    @IBAction func deleteHistory(_ sender: Any) {
        DatabaseFunctions.clearSearchHistory()
    }
}
