//
//  UIViewController+Extensions.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/13.
//

import UIKit

extension UIViewController {
    func showToast(text: String){
        let toast = ToastView(frame: CGRect(x: 0, y: 0, width: 320, height: 90))
//        let toast = ToastView(frame: self.view.frame)
        toast.setLabel(text: text)
        toast.alpha = 0
        self.view.addSubview(toast)
        
        toast.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-101)
            $0.height.equalTo(52)
        }
        
        
        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1
            
        },completion: { finish in
            UIView.animate(withDuration: 0.3, delay: 0.7, animations: {
                toast.alpha = 0

            }, completion: { finish in
                if finish {
//                    toast.removeFromSuperview()
                }
            })
        })
    }
}
