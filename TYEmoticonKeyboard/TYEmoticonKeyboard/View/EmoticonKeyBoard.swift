//
//  EmoticonKeyBoard.swift
//  TYEmoticonKeyboard
//
//  Created by thomasTY on 16/11/10.
//  Copyright © 2016年 thomasTY. All rights reserved.
//

import UIKit
//cell重用标识
private let EmoticonCollectionViewCellIdentifier = "EmoticonCollectionViewCellIdentifier"

//自定表情键盘
class EmoticonKeyBoard: UIView
{
    //自定义表情键盘底部按钮工具条
    fileprivate lazy var toolBar: EmoticonToolBar = EmoticonToolBar()
    //表情视图
    fileprivate lazy var emoticonCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        view.backgroundColor = self.backgroundColor
        
        //注册cell
        view.register(EmoticonCollectionViewCell.self, forCellWithReuseIdentifier: EmoticonCollectionViewCellIdentifier)
        view.dataSource = self
        view.delegate = self
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
        
    }()
    
    ///页数指示器
    fileprivate lazy var pageControl: UIPageControl = {
     let pageCtr = UIPageControl()
    pageCtr.numberOfPages = 3
        pageCtr.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "keyboard_dot_normal")!)
        pageCtr.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "keyboard_dot_selected")!)
        pageCtr.hidesForSinglePage = true
        
        return pageCtr
    }()
    
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
        backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        addSubview(toolBar)
        addSubview(emoticonCollectionView)
        addSubview(pageControl)

        toolBar.snp_makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(35)
        }
        emoticonCollectionView.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(toolBar.snp_top)
        }
        pageControl.snp_makeConstraints { (make) in
            make.bottom.equalTo(emoticonCollectionView)
            make.centerX.equalTo(emoticonCollectionView)
            make.height.equalTo(10)
        }
        
        //设置默认滚动到默认表情
        let normalIndexPath = IndexPath(item: 0, section: 1)
        DispatchQueue.main.async {
            self.emoticonCollectionView.scrollToItem(at: normalIndexPath, at: .left, animated: false)
            self.setPageControlData(indexPath: normalIndexPath)
        }
        
        toolBar.callBack = { [unowned self] (type: EmoticonToolBarButtonType) in
            let indexPath: IndexPath
            switch type
            {
            case .recent:
                indexPath = IndexPath(item: 0, section: 0)
            case .normal:
                indexPath = IndexPath(item: 0, section: 1)
            case .emoji:
                indexPath = IndexPath(item: 0, section: 2)
            case .lxh:
                indexPath = IndexPath(item: 0, section: 3)
            }
            self.emoticonCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            self.setPageControlData(indexPath: indexPath)
        }
    }
    
    //根据indexPath设置pageControl
    fileprivate func setPageControlData(indexPath: IndexPath)
    {
        pageControl.numberOfPages = EmoticonTools.sharedTool.allEmoticonArray[indexPath.section].count
        pageControl.currentPage = indexPath.item
    }
    
    //刷新最近表情的数据
    func reloadRecentData()
    {
        let indexPath = IndexPath(item: 0, section: 0)
        emoticonCollectionView.reloadItems(at: [indexPath])
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        let flowlayout = emoticonCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowlayout.itemSize = emoticonCollectionView.frame.size
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension EmoticonKeyBoard: UICollectionViewDataSource,UICollectionViewDelegate
    
{
    //section
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return EmoticonTools.sharedTool.allEmoticonArray.count
    }
    //item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return EmoticonTools.sharedTool.allEmoticonArray[section].count
    }
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCollectionViewCellIdentifier, for: indexPath) as! EmoticonCollectionViewCell
        cell.emoticonArray = EmoticonTools.sharedTool.allEmoticonArray[indexPath.section][indexPath.item]
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //获取当前collectionView的中心点
        let currentCenterX = scrollView.contentOffset.x + emoticonCollectionView.frame.size.width * 0.5
        let currentCenterY = scrollView.contentOffset.y + emoticonCollectionView.frame.size.height * 0.5
        let currentCenter = CGPoint(x: currentCenterX, y: currentCenterY)
        if let indexPath = emoticonCollectionView.indexPathForItem(at: currentCenter)
        {
            let section = indexPath.section
            toolBar.selectedButtonWithSection(section: section)
            setPageControlData(indexPath: indexPath)
        }
        
    }
    
}
