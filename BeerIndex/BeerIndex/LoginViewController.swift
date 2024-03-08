//
//  LoginViewController.swift
//  BeerIndex
//
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func OnClickGoogleBtn(_ sender: Any) {
        handleSignInWithGoogle();
    }
}

extension LoginViewController {
    
    //fileprivate-- accessable anywhere in this file
    //private-- only accessable in the class
    
    @objc fileprivate func handleSignInWithGoogle() {
        
        // we dont have to do this becuase google sdk
        // will read your target properties so set it
        // up there.
        //---------------------------------------------
        // configuring google signin SDK with client Id
        // let signInConfig = GIDConfiguration(clientID: "ClientId Here");
        //---------------------------------------------
        
        // to help google sign in present its signIn flow
        // correctly we have to pass in a reference to the
        // presenting view contoller.
        
        //** WindowScene A scene that manages one or
        // more windows for your app.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              // get first view from scene(connection of windows)
              let window = windowScene.windows.first,
              // get the view controller that the view uses
              let rootViewContoller = window.rootViewController
        else{
            print("There is no root view controller");
            return;
        }
        
        // since no logout button yet.
        // we logout previous user before
        // login again
        logoutCurrentUser();
        
        // Start the sign in flow!
        
        // we passing the rootViewContoller so that it know
        // the dimention of our screen which help positon
        // the google sign in window well for bigger devices.
    
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewContoller) {
            [weak self] authentication, error in
            
            if let error = error {
                self?.showMessage(title: "Error",
                                  message: error.localizedDescription)
                return;
            }
            
            // After Google returns a successful sign in,
            // we get the users id and idToken
            guard let googleUser = authentication?.user,
                  let userId = googleUser.userID,
                  let idToken = googleUser.idToken
            else{
                print("Error: ID token missing!");
                return;
            }
            
            
            // Sign in the user in our Back4App application.
            User.google.login(id:userId, idToken: idToken.tokenString){
                [weak self] result in
                
                switch result {
                    
                case .success(var user):
            
                   user = self!.fillInMissenUserData(GoogleUser: googleUser, regularUser: user);
                    
                    self?.showMessage(title: "Success", message:
                                        "\(user.FullName!) signed in successfully!")
                    
                case .failure(let error):
                    // Handle the error if the login process failed
                    self?.showMessage(title: "Failed to sign in", message: error.message)
                }
            }
        }
    }

    
    func logoutCurrentUser() {
        let currentUser = User.current;
        
        // handel signout in parse swift
        if ((currentUser) != nil) {
            do{
                try User.logout()
                
                print("previous user logged out!")
            }
            catch{
                print("No user to logout")
            }
        }
        
        // handele signout for google
        if (GIDSignIn.sharedInstance.hasPreviousSignIn()){
            GIDSignIn.sharedInstance.signOut();
        }
    }
    
    func fillInMissenUserData(GoogleUser: GIDGoogleUser, regularUser: User)-> User{
        var user = regularUser;
        
        // we directly add in info that
        // parse didn't add to our db
        
        if(user.FullName == nil){
            
            //{add what ever field you want here}
            user.FullName = GoogleUser.profile?.name;
            user.email = GoogleUser.profile?.email;
            
            // update the user stored in the db
            user.save{
                [weak self] result in
                
                switch result {
                case .success(let user):
                    print("User Updated! \(user)")
                case .failure(let error):
                    self?.showMessage(title: "Error updating User", message: error.localizedDescription)
                }
            }
        }
        else{
            print("User needs no update!")
        }
       return user;
    }
}

extension UIViewController {
    
    func showMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alertController, animated: true)
    }
}
