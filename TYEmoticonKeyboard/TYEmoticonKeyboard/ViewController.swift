//
//  ViewController.swift
//  TYEmoticonKeyboard
//
//  Created by thomasTY on 16/11/10.
//  Copyright © 2016年 thomasTY. All rights reserved.
//

import UIKit


//点击表情按钮通知
let DidSelectedEmoticonButtonNotification = "DidSelectedEmoticonButtonNotification"
//点击删除表情按钮通知
let DidSelectedDeleteEmotionButtonNotification = "DidSelectedDeleteEmotionButtonNotification"

let screenW = UIScreen.main.bounds.size.width
let screenH = UIScreen.main.bounds.size.height

class ViewController: UIViewController
{
    /// 输入视图
    fileprivate lazy var textView: TextView = {
        let textView = TextView()
        textView.placeHolder = "别低头，绿帽会掉哟"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.delegate = self
        textView.autocorrectionType = .no
        textView.alwaysBounceVertical = true
        return textView
    }()
    ///底部工具栏
    fileprivate lazy var toolBar: ToolBar = {
        let toolBar = ToolBar()
        return toolBar
    }()
    
    /// 自定义表情键盘
    fileprivate lazy var emoticonKeyboard: EmoticonKeyBoard = {
        let keyboard = EmoticonKeyBoard()
        keyboard.frame.size = CGSize(width:self.textView.frame.width, height: 216)
        return keyboard
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI()
    {
        //监听键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //监听表情点击
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectedEmoticonButtonNotiAction(noti:)), name: NSNotification.Name(DidSelectedEmoticonButtonNotification), object: nil)
        //监听删除表情通知
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectedDeleteEmoitconAction), name: NSNotification.Name(DidSelectedDeleteEmotionButtonNotification), object: nil)
        
        view.backgroundColor = UIColor.white
        view.addSubview(textView)
        view.addSubview(toolBar)

        textView.snp_makeConstraints { (make) in
            make.top.equalTo(view).offset(22)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(toolBar.snp_top)
        }
        toolBar.snp_makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(35)
        }
        
        toolBar.callBack = {[unowned self]
            (type: ToolBarButtonType) in
            switch type
            {
            case .add1:
                print("add1")
            case .add2:
                print("add2")
            case .add3:
                print("add3")
            case .emoticon:
                print("表情")
                self.didSelectedEmoticon()
            }
        }
    }
    
    
    //键盘高度改变让toolBar工具栏也跟随一起变化
    @objc private func keyboardFrameChange(noti:Notification)
    {
        let keyboardFrame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let offset = keyboardFrame.origin.y - screenH
        toolBar.snp_updateConstraints { (make) in
            make.bottom.equalTo(view).offset(offset)
        }
        UIView.animate(withDuration: duration)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    //表情按钮点击
    @objc private func didSelectedEmoticonButtonNotiAction(noti: Notification)
    {
        let emoticon = noti.object as! Emoticon
        textView.insertEmoticon(emoticon: emoticon)
        NotificationCenter.default.post(name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    
        //将点击过的表情归档
        EmoticonTools.sharedTool.saveRecentEmoticon(emoticon: emoticon)
        emoticonKeyboard.reloadRecentData()
    }
    //删除表情操作
    @objc private func didSelectedDeleteEmoitconAction()
    {
        textView.deleteBackward()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 选择表情
    func didSelectedEmoticon()
    {
        if self.textView.inputView == nil
        {
            self.textView.inputView = emoticonKeyboard
            toolBar.showIcon(isEmoticon: true)
        }else
        {
            self.textView.inputView = nil
            toolBar.showIcon(isEmoticon: false)
        }
        self.textView.becomeFirstResponder()
        self.textView.reloadInputViews()
    }
    
    
}

/// 代理方法
extension ViewController: UITextViewDelegate
{
    //拖动输入视图时让键盘消失
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        self.view.endEditing(true)
    }
}
