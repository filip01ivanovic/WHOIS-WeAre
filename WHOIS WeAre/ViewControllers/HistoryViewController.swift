//
//  HistoryViewController.swift
//  WHOIS WeAre
//
//  Created by Filip Ivanovic on 25/09/2021.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var scrollDummyView: UIView!
    
    @IBAction func didTapButtonBack(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: false, completion: nil)
    }
    /*@IBAction func didTapButtonBack(){

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
        
    }*/
    
    @objc func performSearch(_ sender: UITapGestureRecognizer)
    {
        let view = sender.view as! SearchQueryCard
        let url = view.url!
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.urlToSearchFromHistory = url
        self.present(newViewController, animated: false, completion: nil)
    }
    
    func loadHistory()
    {
        let searchHistoryArray:[[String:Any]] = DatabaseFunctions.getDomainSearchHistory().reversed()
        if searchHistoryArray.count == 0
        {
            print("Empty history!")
        }
        else
        {
            var historyScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: scrollDummyView.frame.width, height: scrollDummyView.frame.height))
            scrollDummyView.addSubview(historyScrollView)
            var prev_y = CGFloat(0)
            for search in searchHistoryArray
            {
                let historyEntry = SearchQueryCard(x: 0, y: prev_y + 20, width: scrollDummyView.frame.width, height: 80.0, urlLabel_horizontalMargin: 20, search: search)
                prev_y = historyEntry.frame.maxY
                historyScrollView.addSubview(historyEntry)
                
                let tapg = UITapGestureRecognizer(target: self, action: #selector(performSearch(_:)))
                historyEntry.isUserInteractionEnabled = true
                historyEntry.addGestureRecognizer(tapg)
            }
            historyScrollView.contentSize = CGSize(width: scrollDummyView.frame.width, height: prev_y)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.userInterfaceStyle == .dark {
            historyLabel.textColor = UIColor.white
        }
        else {
            historyLabel.textColor = UIColor.black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadHistory()
        
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            historyLabel.text = "Istorija"
        }
        else {
            historyLabel.text = "Историја"
        }
        
        if self.traitCollection.userInterfaceStyle == .dark {
            historyLabel.textColor = UIColor.white
        }
        else {
            historyLabel.textColor = UIColor.black
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        loadHistory()
    }
    
    @IBAction func indexChanged(_ sender : Any) {
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            historyLabel.text = "Istorija"
        }
        else {
            historyLabel.text = "Историја"
        }
    }
}
