//
//  ViewController.swift
//  Translate App
//
//  Created by R95 on 07/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var selectedOption1: String = "English"
    private var selectedOption2: String = "English"
    
    
    @IBOutlet weak var fstBtnOutlet: UIButton!
    @IBOutlet weak var secBtnOutlet: UIButton!
    
    @IBOutlet weak var fstTextOutlet: UITextView!
    @IBOutlet weak var secTextOutlet: UITextView!
    
    var seclect1 = ""
    var seclect2 = ""
    let activityView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBorderAndShadow(to: fstTextOutlet)
        addBorderAndShadow(to: secTextOutlet)
    }
    
    func showActivityIndicatory() {
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    func languages()  {
        let headers = [
            "x-rapidapi-key": "1bb7c8d995msh356d5003cd3bb09p17e18ajsne9a333e60143",
            "x-rapidapi-host": "google-translate113.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://google-translate113.p.rapidapi.com/api/v1/translator/support-languages")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                options  = try JSONDecoder().decode([Language].self, from: data)
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        dataTask.resume()
    }
    
    @IBAction func langBtn(_ sender: Any) {
        let alertController1 = UIAlertController(title: "Select a Language", message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            alertController1.addAction(UIAlertAction(title: option.language, style: .default, handler: { [self] _ in
                selectedOption1 = option.language
                seclect1 = option.code ?? "default_value"
                print(seclect1)
                updateButtonTitle()
            }))
        }
        
        alertController1.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController1, animated: true, completion: nil)
    }
    
    private func updateButtonTitle() {
        fstBtnOutlet.setTitle(selectedOption1, for: .normal)
    }
    
    @IBAction func translateetxtBtnAction(_ sender: Any) {
        let alertController2 = UIAlertController(title: "Select a Language", message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            alertController2.addAction(UIAlertAction(title: option.language, style: .default, handler: { [self] _ in
                selectedOption2 = option.language
                seclect2 = option.code ?? "default_value"
                print(seclect2)
                translateupdateButtonTitle()
            }))
        }
        
        alertController2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController2, animated: true, completion: nil)
    }
    
    private func translateupdateButtonTitle() {
        secBtnOutlet.setTitle(selectedOption2, for: .normal)
    }
    
    @IBAction func exchangetextBtnAction(_ sender: Any) {
        showActivityIndicatory()
        
        let headers = [
            "x-rapidapi-key": "1bb7c8d995msh356d5003cd3bb09p17e18ajsne9a333e60143",
            "x-rapidapi-host": "google-translate113.p.rapidapi.com",
            "Content-Type": "application/json"
        ]
        let parameters = [
            "from": seclect1,
            "to": seclect2,
            "json": [
                "title": fstTextOutlet.text
            ]
        ] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://google-translate113.p.rapidapi.com/api/v1/translator/json")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { [self] (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                translate = try JSONDecoder().decode(Translate.self, from: data)
                DispatchQueue.main.async {
                    activityView.stopAnimating()
                    activityView.hidesWhenStopped = true
                    self.secTextOutlet.text = translate!.trans.title
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        dataTask.resume()
    }
    
    private func addBorderAndShadow(to textView: UITextView) {
            textView.layer.borderColor = UIColor.gray.cgColor
            textView.layer.borderWidth = 1.0

            textView.layer.shadowColor = UIColor.gray.cgColor
            textView.layer.shadowOpacity = 0.3
            textView.layer.shadowOffset = CGSize(width: 0, height: 3)
            textView.layer.shadowRadius = 10
            textView.layer.masksToBounds = false
        }
}
