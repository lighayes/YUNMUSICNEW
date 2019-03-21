//
//  PlayViewController.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/16.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import CoreGraphics
import MediaPlayer
import CoreData

extension UIButton{//一个小扩展，实现图片契合按钮大小
    func imgFitBtn(){
        self.imageView?.contentMode = .scaleAspectFill
        self.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
}
extension CALayer {
    func pauseAnim() {
        
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    func resumeAnim() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let currentTime = convertTime(CACurrentMediaTime(), from: nil)
        beginTime = currentTime - pausedTime
    }
}
class PlayViewController: ZViewController,AVAudioPlayerDelegate {
    var singer:String = "0"
    var song:String = "0"
    var nowMusicArry:[Music] = Music.getMusic()
    var nowNum:Int = 0
    static var playMethodIt:Int = 0
    static var isLike:[Int] = [0,0,0,0,0,0,0,0,0]//store is like?
    static var playOrPause:Bool = true//true == play
    var isPlaying:Bool = true
    var delegate:backDelegate?
    var avDelegate:AVAudioPlayerDelegate?
    var time:Timer?
    var lbIng = UILabel()
    var lb = UILabel()
    var slider = UISlider()
    let playBtn = UIButton()
    let likeBtn = UIButton()
    let playModeBtn = UIButton()
    var rotationAnim:CABasicAnimation?
    var anim:CABasicAnimation?
    let musicView = UIView()
    let bangImageView = UIImageView()
    let cdTrueImageView = UIImageView()
    let cdImageView = UIImageView()
    let imageView1 = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        self.view.backgroundColor = UIColor.backgroundDark
        setUp()
        setupButtonView()
        setupImageView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    func setUp(){
//        nowMusicArry = Music.getMusic()
        showBlurEffect()
        getCoreData()
        self.navigationItem.title = nowMusicArry[nowNum].song
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        if isPlaying {
            self.createAudioPlayer()
        
        }else{
            
            if !PlayViewController.playOrPause{
                addBangAnim()
                anim?.toValue = -M_PI/6
                bangImageView.layer.add(anim!, forKey: nil)
                cdTrueImageView.layer.pauseAnim()
                cdImageView.layer.pauseAnim()
                
            }
            
        }
        setTime()
    }
    
    func showBlurEffect() {
        
//        imageView1.layer.borderColor     = UIColor.black.cgColor
//        imageView1.layer.borderWidth     = 2
//        imageView1.layer.cornerRadius    = 5
        imageView1.frame = self.view.bounds
        imageView1.clipsToBounds = true
        
        imageView1.image = UIImage(contentsOfFile: nowMusicArry[nowNum].musicIMG!)
        self.view.addSubview(imageView1)
    //创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
    //创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
   
   
        self.view.addSubview(blurView)
    }
    
   
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextSong()
    }
    
    func createAudioPlayer(){
        if MusicPlayer.create(model: nowMusicArry[nowNum]) {
            print("play")
            //setTime()
            setLikeBtnImage()
            imageView1.image = UIImage(contentsOfFile: nowMusicArry[nowNum].musicIMG!)
             cdTrueImageView.image = UIImage(contentsOfFile: nowMusicArry[nowNum].musicIMG!)
            PlayViewController.playOrPause = true
            setPlayBtnImage()
           
        }
        else{
            print("not")
        }
    }
    
    func setupButtonView(){
        //create view
        let view = UIView(frame:CGRect(x: 0, y: UIScreen.main.bounds.height/4*3, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4))
        self.view.addSubview(view)
        
        //create play button
        
//        playBtn.layer.cornerRadius = 45/2
//        playBtn.layer.borderWidth=1
//        playBtn.layer.borderColor=UIColor.snow.cgColor
        setPlayBtnImage()
        //playBtn.sizeToFit()
//        button.contentVerticalAlignment = .fill
//        button.contentHorizontalAlignment = .fill
        //playBtn.backgroundColor = UIColor.black
        playBtn.frame.size = CGSize(width: 45, height: 45)
        playBtn.imageView?.contentMode = .scaleAspectFill
        playBtn.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        playBtn.addTarget(self, action: #selector(play(btn:)), for: .touchUpInside)
        view.addSubview(playBtn)
        
        //create two btn
        let nextBtn=UIButton()
        let preBtn=UIButton()
        nextBtn.setImage(UIImage(named:"play_btn_next"), for: .normal)
        preBtn.setImage(UIImage(named:"play_btn_prev"), for: .normal)
        nextBtn.tintColor = UIColor.snow
        nextBtn.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        preBtn.addTarget(self, action: #selector(preSong), for: .touchUpInside)
        preBtn.imgFitBtn()
        nextBtn.imgFitBtn()
        //nextBtn.sizeToFit()
        //preBtn.sizeToFit()
        view.addSubview(nextBtn)
        view.addSubview(preBtn)
        
        //create slider
        
        slider.minimumTrackTintColor = UIColor.init(red: 51/255, green: 194/255, blue: 124/255, alpha: 1)
        slider.thumbTintColor = UIColor.snow
        view.addSubview(slider)
        addTargetToSlider()
        
        //create lb
        
        lbIng.text = "00:00"
        lbIng.textColor = UIColor.white
        lbIng.font = UIFont.systemFont(ofSize: 10)
        lbIng.sizeToFit()
        view.addSubview(lbIng)
        
        
        lb.text = MusicPlayer.duration()
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.sizeToFit()
        view.addSubview(lb)
        
        
        setPlayModeBtnImage()
        playModeBtn.imgFitBtn()
        playModeBtn.addTarget(self, action: #selector(playMethod), for: .touchUpInside)
        view.addSubview(playModeBtn)
        
        setLikeBtnImage()
        likeBtn.addTarget(self, action: #selector(likePre), for: .touchUpInside)
        likeBtn.imgFitBtn()
        view.addSubview(likeBtn)
        
        //snapkit
        //暂停or开始
        playBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        //上一首
        preBtn.snp.makeConstraints { (make) in
            make.right.equalTo(playBtn.snp.left).offset(-40)
            make.centerY.equalTo(playBtn.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
            
        }
        //下一首
        nextBtn.snp.makeConstraints { (make) in
            make.left.equalTo(playBtn.snp.right).offset(40)
            make.centerY.equalTo(playBtn.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        //进度条
        slider.snp.makeConstraints { (make) in
            make.bottom.equalTo(playBtn.snp.top).offset(-20)
            make.centerX.equalTo(playBtn.snp.centerX)
            make.width.equalTo(view.bounds.width - lb.frame.width - lbIng.frame.width-5)
            make.height.equalTo(4)
        }
        //歌曲进度时间
        lbIng.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            
            make.centerY.equalTo(slider.snp.centerY)
            
        }
        
        //歌曲时长
        
        lb.snp.makeConstraints { (make) in
            
            make.right.equalTo(view.snp.right)
            make.centerY.equalTo(slider.snp.centerY)
            
        }
        
        //播放方式
        playModeBtn.snp.makeConstraints{ (make) in
            make.right.equalTo(preBtn.snp.left).offset(-40)
            make.centerY.equalTo(playBtn.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        //like
        likeBtn.snp.makeConstraints{ (make) in
            make.bottom.equalTo(slider.snp.top).offset(-25)
            make.centerX.equalTo(playBtn.snp.centerX)
            make.width.equalTo(37)
            make.height.equalTo(37)
        }
        
        
    }
    
    func setPlayBtnImage(){
        if PlayViewController.playOrPause {
            playBtn.setImage(UIImage(named:"play_btn_pause"), for: .normal)
        }
        else {
            playBtn.setImage(UIImage(named:"play_btn_play"), for: .normal)
        }
    }
    
    func setLikeBtnImage(){
        if PlayViewController.isLike[nowNum]==1 {
             likeBtn.setImage(UIImage(named: "play_icn_loved"), for: .normal)
        }
        else {
             likeBtn.setImage(UIImage(named: "play_icn_love"), for: .normal)
        }
    }
    
    func setPlayModeBtnImage(){
        var modeName:String = ""
        switch PlayViewController.playMethodIt {
        case 0:
            modeName = "play_icn_loop"
            break
        case 1:
            modeName = "play_icn_shuffle"
            break
        case 2:
            modeName = "play_icn_one"
            break
            
        default:
            print("ohhhh")
        }
        playModeBtn.setImage(UIImage(named:modeName), for: .normal)
    }
    
    func addTargetToSlider(){
    
    // 监听进度条各个事件
//        slider.addTarget(self, action: Selector(("sliderTouchUpInside")), for: UIControl.Event.touchUpInside)
//
//        slider.addTarget(self, action: Selector(("sliderTouchUpOutside")), for: UIControl.Event.touchUpOutside)
//
//        slider.addTarget(self, action: Selector(("slidertouchDown")), for: UIControl.Event.touchDown)
        slider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)

    }
    
    @objc func likePre(btn:UIButton){
        
        
        if PlayViewController.isLike[nowNum] == 1 {
            PlayViewController.isLike[nowNum] = 0
            deleteNumFromCore()
        }
        else{
            PlayViewController.isLike[nowNum] = 1
            saveNumToCore()
            }
        

        setLikeBtnImage()
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicNumber")
        //fetchRequest.predicate = NSPredicate(format: "num = \(nowNum)","" )
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {
            (result:NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult! as! [MusicNumber]
            for i in fetchObject{
                print("\(i.num)")
                print("\n")
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("error")
        }
        
    }
    //以下为coredata操作的函数
    func getCoreData(){
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicNumber")
        //fetchRequest.predicate = NSPredicate(format: "num = \(nowNum)","" )
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {
            (result:NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult! as! [MusicNumber]
            for i in fetchObject{
                let temp = Int(i.num - 1)
                if  temp >= 0{
                PlayViewController.isLike[temp] = 1
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("error")
        }
    }
    //备用方法
    //用于删除核心数据
    //放进去运行一遍即可
    func deleteAll(){
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicNumber")
        //fetchRequest.predicate = NSPredicate(format: "num = \(nowNum)","" )
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {
            (result:NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult! as! [MusicNumber]
            for i in fetchObject{
                context.delete(i)
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("error")
        }
    }
    
    func saveNumToCore(){
        //注意注意！！nowNum要记得加一
        //由于未知原因
        //删除数据后会变为0一段时间
        //所以舍0
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let Entity = NSEntityDescription.entity(forEntityName: "MusicNumber", in: context)
        let classEntity = NSManagedObject(entity: Entity!, insertInto: context)
        classEntity.setValue(nowNum+1, forKey: "num")
        do{
            try context.save()
        }catch{
            let nserror = error as NSError
            fatalError("error:\(nserror),\(nserror.userInfo)")
        }
    }

        
    func deleteNumFromCore(){
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicNumber")
        fetchRequest.predicate = NSPredicate(format: "num = \(nowNum+1)","" )
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {
            (result:NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult! as! [MusicNumber]
            for i in fetchObject{
                context.delete(i)
                appDelegate.saveContext()
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("error")
        }
    }
    
    @objc func sliderValueChange(){
        print("\(slider.value)")
        setCTime()
    }
    
    func sliderTouchUpOutside(){
        
        setCTime()
    }
    func sliderTouchUpInside(){
        setCTime()
        
    }
    
    func setCTime(){
        print("\(slider.value)")
        let time = Double(slider.value) * MusicPlayer.doubleDuration()
        MusicPlayer.setCurrent(time: time)
        
    }
    
    func slidertouchDown(){
        
        time?.invalidate()
        time = nil
    
        
    }
    
    func setTime(){
        time = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        RunLoop.main.add(time!, forMode: RunLoop.Mode.common)
    }
    
    @objc func updateTime(){
        lbIng.text=MusicPlayer.currentTime()
        slider.value = Float(MusicPlayer.progress())
        setBackground(playBack: 1)
        if slider.value >= slider.maximumValue*0.99{
            nextSong()
        }
    }
   
    @objc func play(btn:UIButton){
        if MusicPlayer.play() {
            btn.setImage(UIImage(named:"play_btn_pause"), for: .normal)
            PlayViewController.playOrPause = true
            anim?.toValue = 0
            bangImageView.layer.add(anim!, forKey: nil)
            rotationAnim?.beginTime = 0.5
            cdTrueImageView.layer.resumeAnim()
            cdImageView.layer.resumeAnim()
//            bangImageView.transform = bangImageView.transform.rotated(by: CGFloat(M_PI/6))
        }
        else {
            btn.setImage(UIImage(named:"play_btn_play"), for: .normal)
            PlayViewController.playOrPause = false
            anim?.toValue = -M_PI/6
            bangImageView.layer.add(anim!, forKey: nil)
            cdTrueImageView.layer.pauseAnim()
            cdImageView.layer.pauseAnim()
            setBackground(playBack: 0)
//             bangImageView.transform = bangImageView.transform.rotated(by: CGFloat(-M_PI/6))
        }
        
        
    }
    @objc func preSong(){
        switch PlayViewController.playMethodIt {
        case 0:
            nowNum = nowNum - 1
            if(nowNum>=nowMusicArry.count){
                nowNum = 0
            }
            
            break
        case 1:
            nowNum = Int(arc4random()) % (nowMusicArry.count-1)
            break
                        //nowNum = RandomNumberGenerator
        case 2:
            
            break
        default:
            print("googogd")
        }
        createAudioPlayer()
        self.navigationItem.title = nowMusicArry[nowNum].song
        lb.text = MusicPlayer.duration()
    }
    @objc func nextSong(){
        switch PlayViewController.playMethodIt {
        case 0:
            nowNum = nowNum + 1
            if(nowNum>=nowMusicArry.count){
                nowNum = 0
            }
        case 1:
            nowNum = Int(arc4random()) % (nowMusicArry.count-1)
            break
        //nowNum = RandomNumberGenerator
        case 2:
            
            break
        default:
            print("googogd")
        }
       createAudioPlayer()
        self.navigationItem.title = nowMusicArry[nowNum].song
        lb.text = MusicPlayer.duration()
        
        
    }
    
    @objc func playMethod(){
        switch PlayViewController.playMethodIt {
        case 0://order
            PlayViewController.playMethodIt = 1

            break
        case 1://random
            PlayViewController.playMethodIt = 2
            break
        case 2://single
            PlayViewController.playMethodIt = 0
            break
        default:
            print("ohhhhh")
        }
        setPlayModeBtnImage()
    }
    func setupImageView(){
        let view = UIView(frame:CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4*3))
        
        self.view.addSubview(view)
        
        
        musicView.layer.borderColor = UIColor.addV.cgColor
        musicView.layer.cornerRadius = view.frame.width/5*4/2
        musicView.layer.borderWidth = 10
        view.addSubview(musicView)
        
        cdTrueImageView.image = UIImage(contentsOfFile: nowMusicArry[nowNum].musicIMG!)
        cdTrueImageView.layer.cornerRadius = view.frame.width/5*4/2
        cdTrueImageView.layer.masksToBounds = true
        view.addSubview(cdTrueImageView)
        
        cdImageView.image = UIImage(named: "play_disc")
        cdImageView.layer.cornerRadius = view.frame.width/5*4/2
        cdImageView.contentMode = .scaleAspectFill
        view.addSubview(cdImageView)
        
        bangImageView.image = UIImage(named: "play_needle_bang")
        bangImageView.contentMode = .scaleAspectFill
        view.addSubview(bangImageView)
        
        let bangCircleImageView = UIImageView(image: UIImage(named: "play_needle_circle"))
        bangCircleImageView.contentMode = .scaleAspectFill
        view.addSubview(bangCircleImageView)
        bangImageView.layer.anchorPoint = CGPoint(x: -0.05, y: 0)
        addBangAnim()
        
        addRotationAnim()
        cdTrueImageView.layer.add(rotationAnim!, forKey: nil)
        cdImageView.layer.add(rotationAnim!, forKey: nil)
        
        //
        //
        // 以下snp布局
        musicView.snp.makeConstraints{(make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(50)
            make.height.equalTo(view.frame.width/5*4)
            make.width.equalTo(view.frame.width/5*4)
        }
        
        cdImageView.snp.makeConstraints{(make) in
            make.centerX.equalTo(musicView.snp.centerX)
            make.centerY.equalTo(musicView.snp.centerY)
            make.height.equalTo(musicView.snp.height)
            make.width.equalTo(musicView.snp.width)
        }
        
        cdTrueImageView.snp.makeConstraints{(make) in
            make.centerX.equalTo(musicView.snp.centerX)
            make.centerY.equalTo(musicView.snp.centerY)
            make.height.equalTo(musicView.snp.height).offset(-50)
            make.width.equalTo(musicView.snp.width).offset(-50)
        }
        
        bangImageView.snp.makeConstraints{(make) in
            make.centerX.equalTo(view.snp.centerX).offset(52-45-0.05*90)
            make.top.equalTo(view.snp.top).offset((self.navigationController?.navigationBar.frame.height)!+UIApplication.shared.statusBarFrame.size.height+5-70)
            make.height.equalTo(140)
            make.width.equalTo(90)
        }
        
        bangCircleImageView.snp.makeConstraints{(make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset((self.navigationController?.navigationBar.frame.height)!+UIApplication.shared.statusBarFrame.size.height)
            make.height.equalTo(10)
            make.width.equalTo(30)
        }
        
        
    }
    
    func addBangAnim(){
//        let path = CGMutablePath()
//        let point = CGPoint.init(x:UIScreen.main.bounds.width/2,y:(self.navigationController?.navigationBar.frame.height)!+UIApplication.shared.statusBarFrame.size.height)
//        path.addArc(center: point, radius: 140, startAngle: .pi, endAngle: (.pi)*3/2, clockwise: true)
//
//        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
//        anim.path = path
//        anim.duration = 10
        anim = CABasicAnimation(keyPath: "transform.rotation.z")
        //anim?.fromValue = 0
//        if PlayViewController.playOrPause {
//        anim?.toValue = M_PI / 6
//        }else{
//            anim?.toValue = -M_PI / 6
//        }
        anim?.duration = 0.5
        anim?.fillMode = CAMediaTimingFillMode.forwards
        
        anim?.isRemovedOnCompletion = false
        
//        anim.rotationMode = CAAnimationRotationMode(rawValue: "auto")
        
        
        
        //CGPathAddArc(path, NULL, view.centerX, view.centerY, 1, 0,M_PI * 2, 1);
    }
    
    func addRotationAnim() {
        rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotationAnim?.fromValue = 0
        rotationAnim?.toValue = M_PI * 2
        rotationAnim?.repeatCount = MAXFLOAT
        rotationAnim?.duration = 30
        
        rotationAnim?.isRemovedOnCompletion = false
    }
    
    @objc override func back() {
        self.delegate?.backToTable(number: nowNum)
        time?.invalidate()
        time = nil
        //time? = nil
        self.navigationController?.popViewController(animated: true)
    }
}

extension PlayViewController {
    override func remoteControlReceived(with event: UIEvent?) {
        
        if event?.type == UIEvent.EventType.remoteControl {
            switch event!.subtype {
            case .remoteControlTogglePlayPause:
                //self.play(btn: playBtn)
                print("play???")
            case .remoteControlPreviousTrack:
                self.preSong()
            case .remoteControlNextTrack:
               self.nextSong()
            case .remoteControlPlay:
                self.play(btn: playBtn)
//                setBackground(playBack: 1)
            case .remoteControlPause: 
                self.play(btn: playBtn)
                setBackground(playBack: 0)
            default:
                break
            }
        }
    }
    func setBackground(playBack:Int) {
        
        let settings = [MPMediaItemPropertyTitle: nowMusicArry[nowNum].song as Any,
                        MPMediaItemPropertyArtist: nowMusicArry[nowNum].singer as Any,
                        MPMediaItemPropertyPlaybackDuration: MusicPlayer.doubleDuration(),
                        MPNowPlayingInfoPropertyElapsedPlaybackTime: MusicPlayer.doubleCurrentTime(),
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: UIImage(contentsOfFile: nowMusicArry[nowNum].musicIMG!)!),
            MPNowPlayingInfoPropertyPlaybackRate:playBack] as [String : Any]
        
        MPNowPlayingInfoCenter.default().setValue(settings, forKey: "nowPlayingInfo")
    }
    
    
}


