//
//  ToolBar.swift
//  TYEmoticonKeyboard
//
//  Created by thomasTY on 16/11/10.
//  Copyright © 2016年 thomasTY. All rights reserved.
//

import UIKit
///区分底部工具条按钮的点击
enum ToolBarButtonType: Int
{
    case add1 = 0
    case add2 = 1
    case add3 = 2
    case emoticon = 3
}

/// 自定义StackView
class ToolBar: UIStackView
{
    
    /// 接收不同按钮的点击
    var callBack: ((ToolBarButtonType)->())?
    /// 接收工具条表情按钮
    fileprivate var emoticonButton: UIButton?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI()
    {
        axis = .horizontal
        distribution = .fillEqually
        addChildButton(imageName: "add_background", type: .add1)
        addChildButton(imageName: "add_background", type: .add2)
        addChildButton(imageName: "add_background", type: .add3)
        emoticonButton = addChildButton(imageName: "emoticonbutton_background", type: .emoticon)
    }
    //不接受返回结果警告
    @discardableResult
    private func addChildButton(imageName:String, type:ToolBarButtonType)->(UIButton)
    {
        let button = UIButton()
        button.tag = type.rawValue
        button.addTarget(self, action: #selector(buttonAction(btn:)), for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named:imageName), for: UIControlState.normal)
        button.setImage(UIImage(named:imageName + "_highlighted"), for: UIControlState.highlighted)
        button.setBackgroundImage(
            UIImage(named:"toolbar_background"), for: UIControlState.normal)
        button.adjustsImageWhenHighlighted = false
        addArrangedSubview(button)
        return button
    }
    //按钮的点击
    @objc private func buttonAction(btn:UIButton)
    {
        let type = ToolBarButtonType(rawValue: btn.tag)!
        callBack?(type)
    }
    
    ///提供给外部调用，根据不同的键盘类型切换不同的工具栏显示图标
    func showIcon(isEmoticon: Bool)
    {
        if isEmoticon
        {
            emoticonButton?.setImage(UIImage(named:"keyboardbutton_background"), for: UIControlState.normal)
            emoticonButton?.setImage(UIImage(named:"keyboardbutton_background_highlighted"), for: UIControlState.highlighted)
        }else
        {
            //弹出系统键盘时，显示表情键盘切换按钮图片
            emoticonButton?.setImage(UIImage(named:"emoticonbutton_background"), for: UIControlState.normal)
            emoticonButton?.setImage(UIImage(named:"emoticonbutton_background_highlighted"), for: UIControlState.highlighted)
        }
    }
}
