//
//  MoreViewController.swift
//  VeggieBook
//
//  Created by Matt Flickner on 7/21/17.
//  Copyright © 2017 Technical Empowerment Inc. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    @IBOutlet weak var buttonViewController: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var printView: UIView!
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var printAtLabel: UILabel!
    @IBOutlet weak var choosePantryTextField: UITextField!
    @IBOutlet weak var printPantryButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var printBottomView: UIView!
    @IBOutlet weak var buttonViewHeightContrainst: NSLayoutConstraint!
    
    var pantryId = 0
    
    var effect:UIVisualEffect!
    var pickerData: [String] = [String]()
    var availableBook : AvailableBook!
    var createdBookId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if APP_VERSION == "MFF" {
            printButton.isHidden = true
            printBottomView.isHidden = true
            buttonViewHeightContrainst.constant = buttonViewHeightContrainst.constant - 30
            buttonViewController.layoutIfNeeded()
        }

        editButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Editar" : "Edit", for: .normal)
        printButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Imprimir en despensa de alimentos" : "Print at Food Pantry", for: .normal)
        self.cancelButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Cancelar" : "Cancel", for: .normal)
        printPantryButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Impresión" : "Print", for: .normal)
        printAtLabel.text = LanguageCode.appLanguage.isSpanish() ? "Imprimir en" : "Print At"
        choosePantryTextField.placeholder = LanguageCode.appLanguage.isSpanish() ? "Elegir una despensa" : "Choose a pantry"
        
        buttonViewController.layer.cornerRadius = 5
        printView.layer.cornerRadius = 5
        buttonViewController.layer.borderColor = UIColor.lightGray.cgColor
        buttonViewController.layer.borderWidth = 1
        buttonViewController.layer.masksToBounds = false
        buttonViewController.layer.shadowColor = UIColor.gray.cgColor
        buttonViewController.layer.shadowRadius = 3
        buttonViewController.layer.shadowOpacity = 0.5
        buttonViewController.layer.shadowOffset.width = -1
        buttonViewController.layer.shadowOffset.height = 1
        buttonViewController.layer.shadowPath = UIBezierPath(rect: buttonViewController.bounds).cgPath
        buttonViewController.layer.shouldRasterize = true
        buttonViewController.layer.rasterizationScale = UIScreen.main.scale

        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isUserInteractionEnabled = false
        
        // Connect data:
        let pantryPickerView = UIPickerView()
        pantryPickerView.delegate = self
        pantryPickerView.backgroundColor = UIColor.white
        
        // Input data into the Array:
        
        pickerTextField.inputView = pantryPickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 128/255, green: 198/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MoreViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MoreViewController.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        pickerTextField.inputAccessoryView = toolBar
        
        getPantryList()

    }

    func getPantryList() {
        let url = RestEndPoint.Pantries.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                guard let pantryJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [[String: Any]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                for pantry in pantryJson {
                    self.pickerData.append(pantry["name"] as! String)
                    self.pantryId = pantry["id"] as! Int
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func donePicker() {
        pickerTextField.resignFirstResponder()
    }
    
    func printBook() {
        let url = RestEndPoint.PrintVeggieBook.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = PrintRequest(createdBookId: self.createdBookId, pantryId: self.pantryId, bookType: self.availableBook.bookType).data
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                guard let printJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                print(printJson)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func animateIn() {
        self.view.addSubview(printView)
        printView.center = self.view.center
        printView.frame = printView.frame.offsetBy( dx: 0, dy: -100 ); // offset by an amount
        printView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        printView.alpha = 0
        visualEffectView.isUserInteractionEnabled = true
        
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.printView.alpha = 1
            self.printView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.printView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.printView.alpha = 0
            self.visualEffectView.effect = nil
            self.visualEffectView.isUserInteractionEnabled = false
            
            
        }) { (success:Bool) in
            self.printView.removeFromSuperview()
            
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                                     didFinishAnimating finished: Bool,
                                     previousViewControllers: [UIViewController],
                                     transitionCompleted completed: Bool){
    }

    @IBAction func dismissPrintView(_ sender: Any) {
        animateOut()
    }
    
    @IBAction func printAtPantry(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        if self.visualEffectView.isUserInteractionEnabled {
            animateOut()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func editTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "unwindToViewController2", sender: self)
    }
    
    @IBAction func printTapped(_ sender: Any) {
        printBook()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "unwindToViewController2" {
            guard let mainViewController = segue.destination as? VeggieBooksViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            mainViewController.editBook = BookBuilder(book: availableBook)
            mainViewController.fromEdit = true
        }
    }
    
    
}

extension MoreViewController : UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
    }
}
