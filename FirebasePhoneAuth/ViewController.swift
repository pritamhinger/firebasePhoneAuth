//
//  ViewController.swift
//  FirebasePhoneAuth
//
//  Created by Pritam Hinger on 23/07/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.isHidden = true
        if let uid = Auth.auth().currentUser?.uid{
            print("Your user id is \(uid)")
            logoutButton.isHidden = false
        }
    }

    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }
        catch let error{
            print(error)
        }
    }
    
    @IBAction func authenticate(_ sender: Any) {
        print("Initiating authentication")
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberField.text!, completion: { (verificationId, error) in
            if error != nil{
                print(error!)
                return
            }
            
            UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
            print("Authentication called")
        })
    }

    @IBAction func verifyCode(_ sender: Any) {
        if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID"){
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCodeTextField.text!);
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error != nil{
                    print(error!)
                    return
                }
                
                print(user!)
            })
        }
    }
}

