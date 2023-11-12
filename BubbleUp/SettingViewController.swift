//
//  SettingViewController.swift
//  BubbleUp
//
//  Created by sarah jang on 11/11/23.
//

import UIKit

class SettingViewController: UIViewController{
    var account: Account?

    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var pass: UILabel!
    @IBOutlet weak var friend1: UILabel!
    @IBOutlet weak var friend2: UILabel!
    @IBOutlet weak var friend3: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://bubbleup.onrender.com/api/users/503") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Account.self, from: data)
                        print(res.phoneNumber)

                        DispatchQueue.main.async {
                            // Update UI on the main thread
                            self.user.text = res.username
                            self.num.text = res.phoneNumber
                            self.pass.text = res.password
                            let numberOfLabels = res.friends.count

                            for i in 0..<numberOfLabels {
                                let label = UILabel()
                                label.text = "♥ \(res.friends[i])"
                                label.frame = CGRect(x: 100, y: 350 + i * 30, width: 200, height: 30)
                                self.view.addSubview(label)
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
