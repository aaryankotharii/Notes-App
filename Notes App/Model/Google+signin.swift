//
//  Google+signin.swift
//  Notes App
//
//  Created by Aaryan Kothari on 01/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

extension UIViewController : GIDSignInDelegate{
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            if error.localizedDescription == "The user canceled the sign-in flow." {
               // removeBlurView()
                return
            }
            else {
            print(error)
            return
            }
        }
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        print(credential as Any)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            guard let uid = user.userID else { return }
            print("Sucessfully logged into firebase with Google!",uid)
            
           //Access the storyboard and fetch an instance of the view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "nav") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated:true, completion: nil)
        }
    }
}

