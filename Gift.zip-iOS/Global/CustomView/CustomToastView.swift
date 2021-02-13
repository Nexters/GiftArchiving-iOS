//
//  CustomToastView.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/02/13.
//

import UIKit
import Then
import SnapKit

class ToastView: UIView {

    var toastBackground: UIImageView = UIImageView().then {
        $0.backgroundColor = UIColor.init(named: "popup")
    }
    var toastLabel: UILabel = UILabel().then {
        $0.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 16)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(){
        self.addSubview(toastBackground)
        self.addSubview(toastLabel)
        
        toastBackground.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setLabel(text: String){
        toastLabel.text = text
    }
}


