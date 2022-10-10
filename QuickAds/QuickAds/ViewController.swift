//
//  ViewController.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 08/10/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.text = "Hello world!"
        view.addSubview(label)
    }


}

