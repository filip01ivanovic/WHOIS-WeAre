//
//  FavoritesViewController.swift
//  WHOIS WeAre
//
//  Created by Filip Ivanovic on 25/09/2021.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var dummyScrollView: UIView!
    
    @objc func removeFavorite(_ sender: UIButton)
    {
        let superview = sender.superview as! SearchQueryCard
        let url = superview.url!
        DatabaseFunctions.deleteFavoriteDomain(url: url)
        favoritesScrollView.removeFromSuperview()
        loadFavorites()
    }
    
    var favoritesScrollView: UIScrollView!
    
    func loadFavorites()
    {
        let searchHistoryArray:[[String:Any]] = DatabaseFunctions.getFavoriteDomains()
        if searchHistoryArray.count == 0
        {
            print("Empty history!")
        }
        else
        {
            favoritesScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: dummyScrollView.frame.width, height: dummyScrollView.frame.height))
            dummyScrollView.addSubview(favoritesScrollView)
            var prev_y = CGFloat(0)
            for _search in searchHistoryArray
            {
                var search = _search
                search["dateSearched"] = nil
                let favoriteEntry = SearchQueryCard(x: 0, y: prev_y+20, width: dummyScrollView.frame.width, height: 80.0, urlLabel_horizontalMargin: 20, search: search)
                favoritesScrollView.addSubview(favoriteEntry)
                prev_y = favoriteEntry.frame.maxY
                
                let favoriteStar_horizontalMargin = CGFloat(10)
                let favoriteStar_width = CGFloat(40)
                let favoriteStar_height = favoriteStar_width
                let favoriteStar = UIButton(frame: CGRect(x: favoriteEntry.frame.width - favoriteStar_width - favoriteStar_horizontalMargin, y: favoriteEntry.frame.height/2 - favoriteStar_height/2, width: favoriteStar_width, height: favoriteStar_height))
                //let starUIImage = UIImage(systemName: "3237420.png")
                let starUIImage = UIImage(named: "blueStar.png")
                favoriteStar.setBackgroundImage(starUIImage, for: .normal)
                favoriteEntry.addSubview(favoriteStar)
                favoriteStar.addTarget(self, action: #selector(removeFavorite(_:)), for: .touchUpInside)
                favoriteStar.tintColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0, alpha: 1)
                
                /*
                let tapg = UITapGestureRecognizer(target: self, action: #selector(performSearch(_:)))
                historyEntry.isUserInteractionEnabled = true
                historyEntry.addGestureRecognizer(tapg)
                 */
            }
            favoritesScrollView.contentSize = CGSize(width: dummyScrollView.frame.width, height: prev_y)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.userInterfaceStyle == .dark {
            favoritesLabel.textColor = UIColor.white
        }
        else {
            favoritesLabel.textColor = UIColor.black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadFavorites()
        
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            favoritesLabel.text = "Omiljeni"
        }
        else {
            favoritesLabel.text = "Омиљени"
        }
        
        if self.traitCollection.userInterfaceStyle == .dark {
            favoritesLabel.textColor = UIColor.white
        }
        else {
            favoritesLabel.textColor = UIColor.black
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        loadFavorites()
    }
    
    @IBAction func didTapButtonBack(){

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @IBAction func indexChanged(_ sender : Any) {
        if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
            favoritesLabel.text = "Omiljeni"
        }
        else {
            favoritesLabel.text = "Омиљени"
        }
    }
}
