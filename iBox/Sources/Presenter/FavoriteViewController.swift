//
//  FavoriteViewController.swift
//  iBox
//
//  Created by 이지현 on 12/27/23.
//

import UIKit

class FavoriteViewController: BaseViewController<MainView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        let favorite = UserDefaultsManager.favorite.value
        print("\(favorite.name) : \(favorite.url)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
