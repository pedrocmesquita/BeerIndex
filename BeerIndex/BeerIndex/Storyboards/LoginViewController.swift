//
//  LoginViewController.swift
//  BeerIndex
//
//  Created by ITSector on 09/03/2024.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    //let googleLoginButton = GIDSignInButton()
    @IBOutlet weak var infoPanelView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        googleLoginButton.center = CGPoint(x: view.center.x, y: view.bounds.height - googleLoginButton.bounds.height/2 - 60)
        googleLoginButton.addTarget(self, action: #selector(handleSignInWithGoogle), for: .touchUpInside)
        view.addSubview(googleLoginButton)
         */
        
        
        let maskPath = UIBezierPath(roundedRect: infoPanelView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        infoPanelView.layer.mask = shape
    }
    
    @IBAction func LoginGoogleBtn(_ sender: UIButton) {
        handleSignInWithGoogle();
    }
}

extension LoginViewController {
    
    //fileprivate-- accessable anywhere in this file
    //private-- only accessable in the class
    
    @objc fileprivate func handleSignInWithGoogle() {
        
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
        let currentUser = User.current
        
        // Executa a operação de logout em uma fila de background
        DispatchQueue.global(qos: .background).async {
            
            if((currentUser) != nil) {
                // Logout do usuário do Parse
                do {
                    try User.logout()
                    print("previous user logged out!")
                } catch {
                    print("No user to logout")
                }
            }
            
            // Logout Google
            if (GIDSignIn.sharedInstance.hasPreviousSignIn()){
                GIDSignIn.sharedInstance.signOut();
            }
            
            // Exibe uma mensagem na thread principal
            DispatchQueue.main.async {
                print("Utilizador desconectado de todos os serviços")
            }
        }
    }
    
    func fillInMissenUserData(GoogleUser: GIDGoogleUser, regularUser: User)-> User{
        var user = regularUser;
        
        // we directly add in info that
        // parse didn't add to our db
        
        if(user.FullName == nil){
            
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
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
            
            self.present(alertController, animated: true)
            }
    }
}
