//
//  DetailViewController.swift
//  Presidents
//
//  Created by Admin on 05.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!

    private var languageListController: LanguageListController?
    private var languageButton: UIBarButtonItem?
    var languageString = "" {
        didSet {
            if languageString != oldValue {
                configureView()
            }
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                let dict = detail as! [String: String]
                //let urlString = dict["url"]
                let urlString = modifyUrlForLanguage(url: dict["url"]!, language: languageString)
                label.text = urlString
                
                let url = URL(string: urlString)!
                let request = URLRequest(url: url)
                webView.load(request)
                let name = dict["name"]
                title = name
            }
        }
    }

    private func modifyUrlForLanguage(url: String, language lang: String?) -> String {
        
        var newUrl = url
        if let langStr = lang {
            let range = NSMakeRange(8, 2)
            if !langStr.isEmpty && (url as NSString).substring(with: range) != langStr {
                newUrl = (url as NSString).replacingCharacters(in: range, with: langStr)
            }
        }
        return newUrl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        languageButton = UIBarButtonItem(title: "Choose Language", style: .plain, target: self, action: #selector(DetailViewController.showLanguagePopover))
        navigationItem.rightBarButtonItem = languageButton
    }
    
    @objc func showLanguagePopover() {
        if languageListController == nil {
            languageListController = LanguageListController()
            languageListController!.detailViewController = self
            languageListController!.modalPresentationStyle = .popover
        }
        present(languageListController!, animated: true, completion: nil)
        if let ppc = languageListController?.popoverPresentationController {
            ppc.barButtonItem = languageButton
        }
    }

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

