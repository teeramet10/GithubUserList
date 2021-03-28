//
//  BaseView.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 24/3/2564 BE.
//

import Foundation
import UIKit
@IBDesignable
class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        self.initView()
    }
    
    
    fileprivate func setupView() {
        let view = viewFromNibForClass()
        view?.frame = bounds
        view?.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        guard let newView = view else{return}
        addSubview(newView)
    }
    
    fileprivate func viewFromNibForClass() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    func initView(){
        
    }
}
