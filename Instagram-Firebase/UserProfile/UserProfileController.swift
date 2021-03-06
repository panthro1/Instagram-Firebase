//
//  UserProfileController.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/11/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
            "headerId", for: indexPath) as? UserProfileHeader
        
        header?.user = self.user
        
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    var user: User?
    fileprivate func fetchUser() {

        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let dbRef = Database.database().reference()
        dbRef.child("users").child(uid).observe(.value, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value  as? [String: Any] else { return }
            
//            let profileUrl = dictionary["profileUrl"] as? String
//            let username = dictionary["username"] as? String
            
            self.user = User(dictionary: dictionary)
            
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
            
        }) { (error) in
            
            print("Failed to fetch user:", error)
        }
        
    }
    
    
}


struct User {
    
    let username:String
    let profileUrl:String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileUrl = dictionary["profileUrl"] as? String ?? ""
    }
}
