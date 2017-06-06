//
//  ViewController.swift
//  Codable
//
//  Created by sodas on 6/6/17.
//  Copyright © 2017 sodastsai. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    static var responseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var jsonTextView: UITextView!

    @IBAction func transformJSON(_ sender: Any) {
        let person = Person(name: self.nameTextField.text ?? "",
                            email: self.emailTextField.text ?? "",
                            birthday: self.birthdayDatePicker.date)
        if let jsonString = self.jsonString(from: person) {
            self.jsonTextView.text = jsonString
        }
    }

    @IBAction func fetchJSON(_ sender: Any) {
        Alamofire.request("http://127.0.0.1:8000/",
                          method: .post,
                          parameters: ["name": "Peter", "email": "sodas@icloud.com", "birthday": "2017-06-05"],
                          encoding: JSONEncoding.default)
            .validate()
            .responseJSONCodable(configurationHandler: { decoder in
                decoder.dateDecodingStrategy = .formatted(ViewController.responseDateFormatter)
            }) { (dataResp: DataResponse<Person>) in
                guard let person = dataResp.value else { return }
                guard let jsonString = self.jsonString(from: person) else { return }
                self.jsonTextView.text = jsonString
        }
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.emailTextField.becomeFirstResponder()
        } else {
            self.emailTextField.resignFirstResponder()
        }
        return true
    }

    // MARK: - View Controller Methods

    func jsonString(from person: Person) -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(ViewController.responseDateFormatter)
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(person) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }

}
