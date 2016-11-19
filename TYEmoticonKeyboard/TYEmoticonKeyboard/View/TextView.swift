//
//  TextView.swift
//  TYEmoticonKeyboard
//
//  Created by thomasTY on 16/11/10.
//  Copyright © 2016年 thomasTY. All rights reserved.
//

import UIKit
/// 自定义textView
class TextView: UITextView
{
    fileprivate lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "听说下雨天音乐跟辣条更配哟~"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    /// 提供给调用者设置占位文字
    var placeHolder: String?{
        didSet
        {
            placeHolderLabel.text = placeHolder
        }
    }
    override var font: UIFont?
    {
        didSet
        {
            if font != nil
            {
                
                placeHolderLabel.font = font!
            }
        }
    }
    override init(frame: CGRect, textContainer: NSTextContainer?)
    {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI()
    {
        //监听文字变化，当有编辑操作时让占位文字隐藏
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        addSubview(placeHolderLabel)
        
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6))
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -10))
    }
    
    @objc private func textChange()
    {
        placeHolderLabel.isHidden = true
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TextView
{
    var emoticonText: String
    {
        var  result = ""
        self.attributedText.enumerateAttributes(in: NSMakeRange(0, self.attributedText.length), options: []) { (info, range, _) in
            if let attachment = info["NSAttachment"] as? TextAttachment
            {
                let emoticon = attachment.emoticon!
                result += emoticon.chs!
                
            }else//取到普通文本
            {
                let text = self.attributedText.attributedSubstring(from: range).string
                result += text
            }
        }
        return result
    }
    
    //根据表情模型转换为富文本插入到textView
    func insertEmoticon(emoticon: Emoticon)
    {
        if emoticon.type == "0"
        {
            let lastAttributedString = NSMutableAttributedString(attributedString: self.attributedText)
            let attributedString = NSAttributedString.attributedStringWithEmoticon(emoticon: emoticon, font: self.font!)
            //替换上一次富文本选中范围的内容
            var selectRange = self.selectedRange
            lastAttributedString.replaceCharacters(in: selectRange, with: attributedString)
            lastAttributedString.addAttribute(NSFontAttributeName, value: self.font!, range: NSMakeRange(0, lastAttributedString.length))
            self.attributedText = lastAttributedString
            //清空选中范围
            selectRange.length = 0
            selectRange.location += 1
            self.selectedRange = selectRange
        }else
        {
            self.insertText((emoticon.code! as NSString).emoji())
        }
        
    }
}

