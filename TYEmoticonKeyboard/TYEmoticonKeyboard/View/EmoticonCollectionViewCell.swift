//
//  EmoticonCollectionViewCell.swift
//  TYEmoticonKeyboard
//
//  Created by thomasTY on 16/11/10.
//  Copyright © 2016年 thomasTY. All rights reserved.
//

import UIKit

class EmoticonCollectionViewCell: UICollectionViewCell
{
    //记录20个表情按钮
    fileprivate lazy var emoticonButtonArray: [EmoticonButton] = [EmoticonButton]()
    //删除表情按钮
    fileprivate lazy var deleteEmoticonButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteEmoticonButtonAction), for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named: "emotion_delete"), for: .normal)
        button.setImage(UIImage(named: "emotion_delete_highlighted"), for: .highlighted)
        return button
    }()
    
    //提供给外界绑定数据
    var emoticonArray: [Emoticon]?
        {
        didSet
        {
            guard let emtnArray = emoticonArray else
            {
                return
            }
            for button in emoticonButtonArray
            {
                button.isHidden = true
            }
            for (i, emoticon) in emtnArray.enumerated()
            {
                let emoticonButton = emoticonButtonArray[i]
                emoticonButton.emoticon = emoticon
                //只有当为其赋值时才显示，防止cell的重复
                emoticonButton.isHidden = false
                if emoticon.type == "0"
                {
                    emoticonButton.setImage(UIImage(named:emoticon.fullPath!), for: UIControlState.normal)
                    emoticonButton.setTitle(nil, for: UIControlState.normal)
                }else
                {
                    emoticonButton.setImage(nil, for: UIControlState.normal)
                    emoticonButton.setTitle((emoticon.code! as NSString).emoji() , for: UIControlState.normal)
                }
            }
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI()
    {
        addChildButton()
        contentView.addSubview(deleteEmoticonButton)
    }
    
    
    //MARK: - 添加20个表情按钮
    private func addChildButton()
    {
        for _ in 0..<20
        {
            let button = EmoticonButton()
            button.addTarget(self, action: #selector(emoticonButtonAction(btn:)), for: UIControlEvents.touchUpInside)
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 33)
            contentView.addSubview(button)
            emoticonButtonArray.append(button)
        }
        
    }
    
    //MARK: - 表情按钮点击事件
    @objc private func emoticonButtonAction(btn: EmoticonButton)
    {
        let emoticon = btn.emoticon
        print(emoticon?.chs ?? "",emoticon?.code ?? "")
        NotificationCenter.default.post(name: NSNotification.Name(DidSelectedEmoticonButtonNotification), object: emoticon)
    }
    //MARK: - 点击删除表情按钮事件
    @objc private func deleteEmoticonButtonAction()
    {
        NotificationCenter.default.post(name: NSNotification.Name(DidSelectedDeleteEmotionButtonNotification), object: nil)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        let buttonWidth = self.frame.size.width / 7
        let buttonHeight = self.frame.size.height / 3
        for (i , btn) in  emoticonButtonArray.enumerated()
        {
            let colIndex = i % 7
            let rowIndex = i / 7
            btn.frame.origin.x = CGFloat(colIndex) * buttonWidth
            btn.frame.origin.y = CGFloat(rowIndex) * buttonHeight
            btn.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        }
        deleteEmoticonButton.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        deleteEmoticonButton.frame.origin.x = self.frame.size.width - buttonWidth
        deleteEmoticonButton.frame.origin.y = self.frame.size.height - buttonHeight
    }
}
