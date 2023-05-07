//
//  ViewController.swift
//  Cooking
//
//  Created by Jiang LinShan on 2023/5/7.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var state: CookingState?
    lazy var clock: Clock = {
        return Clock()
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("开始计时", for: .normal)
        btn.setTitle("等待...", for: .disabled)
        btn.addTarget(self, action:#selector(buttonClick), for: .touchUpInside)
        btn.showsTouchWhenHighlighted = true
        btn.backgroundColor = UIColor.red
        return btn
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("下一步", for: .normal)
        btn.addTarget(self, action:#selector(nextClick), for: .touchUpInside)
        btn.showsTouchWhenHighlighted = true
        btn.backgroundColor = UIColor.red
        return btn
    }()
    
    lazy var resetBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("重新开始", for: .normal)
        btn.addTarget(self, action:#selector(resetClick), for: .touchUpInside)
        btn.showsTouchWhenHighlighted = true
        btn.backgroundColor = UIColor.orange
        return btn
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        changeState(.Soaking)
    }
    
    
    func setUpUI() {
        view.addSubview(titleLabel)
        view.addSubview(button)
        view.addSubview(nextBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(200)
            make.top.equalTo(view.snp.top).offset(200)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(100)
            make.width.equalTo(180)
            make.height.equalTo(50)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(30)
            make.width.equalTo(180)
            make.height.equalTo(50)
            make.centerX.equalTo(view.snp.centerX)
        }
    }

    func changeButton(enable: Bool) {
        button.isEnabled = enable
        button.backgroundColor = !enable ? .gray : .red
    }
    
    func changeState(_ newState: CookingState) {
        state = newState
        let model = clock.clockModel[state!]
        titleLabel.text = model?.des
    }

    @objc func buttonClick() {
        changeButton(enable: false)
        clock.state = state
    }
    
    
    @objc func nextClick() {
        if clock.state == .PostCooking {
            changeState(.Soaking)
        } else {
            changeState(CookingState(rawValue: clock.state!.rawValue + 1)!)
        }
        changeButton(enable: true)

    }
    
    @objc func resetClick() {
        changeState(.Soaking)
        nextBtn.isEnabled = true;
        nextBtn.backgroundColor = .red

    }
}

