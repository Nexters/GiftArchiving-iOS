//
//  CropVC.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/29.
//

import UIKit

class CropVC: UIViewController {

    static let identifier: String = "CropVC"
    
    var image: UIImage?
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

//MARK: - ScrollViewDelegate

extension CropVC: UIScrollViewDelegate {
    
}

