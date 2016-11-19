//
//  EmoticonToolBar.swift
//  TYEmoticonKeyboard
//
//  Created by thomasTY on 16/11/10.
//  Copyright © 2016年 thomasTY. All rights reserved.
//

import UIKit
//MARK: -  如果原始值要用做tag，那么不要使用0开始，避免和系统的tag重复
enum EmoticonToolBarButtonType: Int
{
    //  最近表情
    case recent = 1000
    //  默认表情
    case normal = 1001
    //  emoji
    case emoji = 1002
    //  浪小花
    case lxh = 1003
}

class EmoticonToolBar: UIStackView
{
    
    
    //接收外界点击操作
    var callBack:((EmoticonToolBarButtonType)->())?
    //记录上次选中button
    var lastSelectedButton: UIButton?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  setupUI()
    {
        axis = .horizontal
        distribution = .fillEqually
        addChildButton(title: "最近", imageName: "emotion_table_left", type: .recent)
        addChildButton(title: "默认", imageName: "emotion_table_mid", type: .normal)
        addChildButton(title: "emoji", imageName: "emotion_table_mid", type: .emoji)
        addChildButton(title: "浪小花", imageName: "emotion_table_right", type: .lxh)
    }
    
    private func addChildButton(title: String, imageName: String, type: EmoticonToolBarButtonType)
    {
        let button = UIButton()
        button.tag = type.rawValue
        button.setBackgroundImage(UIImage(named: imageName + "_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: imageName + "_selected"), for: .selected)
        button.addTarget(self, action: #selector(buttonAction(btn:)), for: UIControlEvents.touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(title, for: .normal)
        button.adjustsImageWhenHighlighted = false
        addArrangedSubview(button)
        if type == .normal
        {
            lastSelectedButton?.isSelected = false
            button.isSelected = true
            lastSelectedButton = button
        }
    }
    
    @objc private func buttonAction(btn:UIButton)
    {
        //重复点击按钮不做响应
        if lastSelectedButton == btn
        {
            return
        }
        lastSelectedButton?.isSelected = false
        btn.isSelected = true
        lastSelectedButton = btn
        let type = EmoticonToolBarButtonType(rawValue: btn.tag)!
        callBack?(type)
    }
    
    
    func selectedButtonWithSection(section: Int)
    {
        let button  = viewWithTag(section + 1000) as! UIButton
        if lastSelectedButton == button
        {
            return
        }
        lastSelectedButton?.isSelected = false
        button.isSelected = true
        lastSelectedButton = button
    }
}

