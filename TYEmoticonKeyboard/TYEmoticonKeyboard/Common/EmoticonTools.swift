//
//  EmoticonTools.swift
//  TYEmoticonKeyboard
//
//  Created by thomasTY on 16/11/10.
//  Copyright © 2016年 thomasTY. All rights reserved.
//

import UIKit

///每页20个表情
let NumberOfPage = 20

//解档和归档的路径
let RecentEmoticonPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("recentEmoticonArray.archiver")

/// 表情工具类
class EmoticonTools: NSObject
{
    static let sharedTool: EmoticonTools = EmoticonTools()
    lazy var emoticonsBundle: Bundle = {
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)!
        let bundle = Bundle(path:path)!
        return bundle
    }()
    // 最近使用表情
    private lazy var recentEmoticonArray: [Emoticon] = {
        if let localArray = self.loadRecentEmoitcon()
        {
            return localArray
        } else
        {
            let emotionArray = [Emoticon]()
            return emotionArray
        }
    }()
    // 默认表情的表情模型数组
    private lazy var defaultEmoticonArray: [Emoticon] = {
        return self.loadEmoticonArray(folderName: "default", fileName: "info.plist")
    }()
    // emoji表情的表情模型
    private lazy var emojiEmoticonArray: [Emoticon] = {
        return self.loadEmoticonArray(folderName: "emoji", fileName: "info.plist")
    }()
    //浪小花表情的表情模型数组
    private lazy var lxhEmoticonArray: [Emoticon] =
        {
            return self.loadEmoticonArray(folderName: "lxh", fileName: "info.plist")
            
    }()
    // 全部表情数组
    lazy var allEmoticonArray: [[[Emoticon]]] = {
        return [
            [self.recentEmoticonArray],
            self.sectionEmoticonsArray(emoticons: self.defaultEmoticonArray),
            self.sectionEmoticonsArray(emoticons: self.emojiEmoticonArray),
            self.sectionEmoticonsArray(emoticons: self.lxhEmoticonArray)
        ]
    }()
    
    private override init()
    {
        super.init()
    }
    
    /// 获得表情模型数组
    ///
    /// - parameter folderName: 文件夹名
    /// - parameter fileName:   文件名
    ///
    /// - returns: 装着表情模型的数组
    private func loadEmoticonArray(folderName: String, fileName: String) -> [Emoticon]
    {
        let subPath = folderName + "/" + fileName
        let path = self.emoticonsBundle.path(forResource: subPath, ofType: nil)!
        let dictArray = NSArray(contentsOfFile: path) as! [[String:Any]]
        var modelArray = [Emoticon]()
        for dict in dictArray
        {
            let model:Emoticon = Emoticon(dict: dict)
            modelArray.append(model)
        }
        for model in modelArray
        {
            //只有图片表情时才拼接图片全路径
            if model.type == "0"
            {
                let path = self.emoticonsBundle.path(forResource: folderName, ofType: nil)! + "/" + model.png!
                model.fullPath = path
                model.folderName = folderName
            }
        }
        return modelArray
    }
    
    
    /// 将表情数组拆分为二维数组
    ///
    /// - parameter emoticons: 一套表情所有表情模型数组
    ///
    /// - returns: 拆分好的表情模型二维数组
    private func sectionEmoticonsArray(emoticons: [Emoticon]) -> [[Emoticon]]
    {
        let pageCount = (emoticons.count - 1) / NumberOfPage + 1
        var tempArray = [[Emoticon]]()
        for i in 0..<pageCount
        {
            let loc = i * NumberOfPage
            var len = NumberOfPage
            if loc + len > emoticons.count
            {
                len = emoticons.count - loc
            }
            let subArray = (emoticons as NSArray).subarray(with: NSMakeRange(loc, len)) as! [Emoticon]
            tempArray.append(subArray)
        }
        return tempArray
    }
    
    /// 添加最近表情数据
    ///
    /// - parameter emoticon: 表情模型
    func saveRecentEmoticon(emoticon: Emoticon)
    {
        for (i, etn) in recentEmoticonArray.enumerated()
        {
            if etn.type == "0"
            {
                if etn.chs == emoticon.chs
                {
                    recentEmoticonArray.remove(at: i)
                    break
                }
            }else
            {
                if etn.code == emoticon.code
                {
                    recentEmoticonArray.remove(at: i)
                    break
                }
            }
        }
        recentEmoticonArray.insert(emoticon, at: 0)
        while recentEmoticonArray.count > 20
        {
            recentEmoticonArray.removeLast()
        }
        allEmoticonArray[0][0] = recentEmoticonArray
        NSKeyedArchiver.archiveRootObject(recentEmoticonArray, toFile: RecentEmoticonPath)
    }
    //MARK: - 解档读取最近表情数据
    func loadRecentEmoitcon() -> [Emoticon]?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: RecentEmoticonPath) as? [Emoticon]
    }
    
    
    //MARK: - 根据描述拿到表情模型
    func selectEmoticonWithChs(chs: String) -> Emoticon?
    {
        for emoticon in defaultEmoticonArray
        {
            if emoticon.chs == chs
            {
                return emoticon
            }
        }
        for emoticon in lxhEmoticonArray
        {
            if emoticon.chs == chs
            {
                return emoticon
            }
        }
        return nil
    }
    
}
