//
//  MeLoginViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class MeLoginViewController: UIViewController,UITextFieldDelegate,HttpProtocol{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let http = HttpRequest()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 6
        setLoginButtonUnClickable()
        http.delegate = self
        nameTextField.delegate = self
        pwdTextField.delegate = self
    }
    
    @IBAction func cancelButtonTouchUpInside(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func editDidEnd(sender: UITextField) {
        let name = nameTextField.text!
        let pwd = pwdTextField.text!
        if(name.characters.count != 0
            && pwd.characters.count != 0){
                setLoginButtonClickable()
        }else{
            setLoginButtonUnClickable()
        }
    }
    
    @IBAction func loginButtonTouchUpInside(sender: UIButton) {
        let name = nameTextField.text!
        let pwd = pwdTextField.text!
        
        postLogin(name,pwd:pwd)
    }
    
    func setLoginButtonUnClickable(){
        let color:UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.3)
        loginButton.setTitleColor(color, forState:UIControlState.Normal)
        loginButton.userInteractionEnabled = false
    }
    
    func setLoginButtonClickable(){
        let color:UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        loginButton.setTitleColor(color, forState:UIControlState.Normal)
        loginButton.userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nameTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
    }
    
    func postLogin(name:String,pwd:String){
        let url = ServiceApi.getLoginUrl()
        let params = NSDictionary(objects: [name,pwd], forKeys: ["userName", "pwd"])
        http.postRequest(url, params: params)
    }
    
    //MARK: UITextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if pwdTextField.text!.isEmpty{
            count = 0
            if count < 1 {
                pwdTextField.becomeFirstResponder()
                count += 1
            }else{
                textField.resignFirstResponder()
            }
        }else{
            textField.resignFirstResponder()
        }
        
        if nameTextField.text!.isEmpty{
            count = 0
            if count < 1 {
                nameTextField.becomeFirstResponder()
                count += 1
            }else{
                pwdTextField.resignFirstResponder()
            }
        }
        
        return true
    }

    func didreceiveResult(result: NSDictionary) {
        let message:String = result["message"] as! String
        print(message)
        MBPHUDUtil.toastText(self.view, text: message)
        if (result["isSuccess"] as! Bool) {
            let user = UserModel(userInfo:result["user"] as? NSDictionary)
            NSUserDefaultUtil.saveUser(user)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}












