//
//  Emoticon.swift
//  TYEmoticonKeyboard
//
//  Created by thomasTY on 16/11/10.
//  Copyright © 2016年 thomasTY. All rights reserved.
//
import UIKit
//表情模型
class Emoticon: NSObject, NSCoding
{
    //  表情描述
    var chs: String?
    //  表情图片名称
    var png: String?
    //  表情类型 -> 0: 图片表情, 1: emoji 表情
    var type: String?
    //  16进制字符串 -> 转成 emoji 表情显示
    var code: String?
    //  图片全路径
    var fullPath: String?
    //  保存图片对应的文件夹
    var folderName: String?
    
    override init()
    {
        super.init()
    }
    
    init(dict:[String:Any])
    {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String)
    {
    }
    
    //MARK: -  解档和归档
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(chs, forKey: "chs")
        aCoder.encode(png, forKey: "png")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(fullPath, forKey: "fullPath")
        aCoder.encode(folderName, forKey: "folderName")
        
    }
    required init?(coder aDecoder: NSCoder)
    {
        chs = aDecoder.decodeObject(forKey: "chs") as? String
        png = aDecoder.decodeObject(forKey: "png") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        code = aDecoder.decodeObject(forKey: "code") as? String
        fullPath = aDecoder.decodeObject(forKey: "fullPath") as? String
        folderName = aDecoder.decodeObject(forKey: "folderName") as? String
        
        //沙盒的全路径每次运行都不一样
        if type == "0"
        {
            fullPath = EmoticonTools.sharedTool.emoticonsBundle.path(forResource: folderName, ofType: nil)! +  "/" + png!
        }
        
    }
    
}
