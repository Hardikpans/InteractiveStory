//
//  ViewController.swift
//  InteractiveStory
//
//  Created by hardik Pans on 6/8/18.
//  Copyright © 2018 hardik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var NameTextField: UITextField!
    
    @IBOutlet weak var TextEditorBottomConstraint: NSLayoutConstraint!
    
    enum error: Error {
        case NoName
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    /*    let story = Page(story: .TouchDown)
        story.firstChoice = (title: "Some Title", page: Page(story: .Droid))
      */
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Start Adventure" {
            do {
                if let name = NameTextField.text {
                    if name == "" {
                        throw error.NoName
                    }
                    if let pageController = segue.destination as? PageController {
                        pageController.page = Adventure.story(name: name)
                    }
                    

                }
            } catch error.NoName {
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start your story!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                
                present(alertController, animated: true, completion: nil)
                
            } catch let error {
                fatalError("\(error)")
            }
            
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            
          //  TextEditorBottomConstraint.constant = keyboardFrame.size.height + 10
            UIView.animate(withDuration: 0.8) {
                self.TextEditorBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()
            }
        
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.8) {
            self.TextEditorBottomConstraint.constant = 40.0
            self.view.layoutIfNeeded()
        }
    }

    /*deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }*/

    // Mark: - UItextfeild delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


}



