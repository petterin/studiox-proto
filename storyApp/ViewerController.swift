import UIKit
import AVFoundation

class ViewerController: UIViewController, AVAudioPlayerDelegate {

    required init(coder aDecoder: NSCoder) {
        self.audioPlayer = AVAudioPlayer()
        super.init(coder: aDecoder)
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var controllerImageView: UIImageView!

    let imageList = ["mokki1.jpg","mokki2.jpg","mokki3.jpg","mokki4.jpg","mokki5.jpg","mokki6.jpg","mokki7.jpg","mokki8.jpg","mokki9.jpg","mokki10.jpg","mokki11.jpg","mokki12.jpg","mokki13.jpg"]
    let audioURLs = ["story1_audio", "story2_audio", "story3_audio", "story4_audio", "story5_audio", "story4_audio", "story4_audio", "story4_audio", "story4_audio", "story4_audio", "story4_audio", "story4_audio", "story4_audio"].map({(filename) -> NSURL in
        let path = NSBundle.mainBundle().pathForResource(filename, ofType: "m4a")!
        return NSURL(fileURLWithPath: path)!})
    let playImage = UIImage(named: "play_icon")
    let pauseImage = UIImage(named: "pause_icon")
    var recordingStartedAtLeastOnce = false
    
    var imageIndex = 0
    var audioPlayer:AVAudioPlayer {
        didSet{
            audioPlayer.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swipedView:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        imageView.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipedView:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        imageView.addGestureRecognizer(swipeLeft)

        imageView.userInteractionEnabled = true
        imageView.image = UIImage(named: imageList[0])
        imageView.frame = UIScreen.mainScreen().applicationFrame
        audioPlayer = AVAudioPlayer(contentsOfURL: audioURLs[0], error: nil)
        audioPlayer.prepareToPlay()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func swipedView(gesture: UIGestureRecognizer){

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right :
                    println("User swiped right")
                    
                    imageIndex++
                    if imageIndex > imageList.count - 1 {
                        imageIndex = 0
                    }
                    
                    imageView.image = UIImage(named: imageList[imageIndex])
                    audioPlayer = AVAudioPlayer(contentsOfURL: audioURLs[imageIndex], error: nil)
                    audioPlayer.play()

                case UISwipeGestureRecognizerDirection.Left:
                    println("User swiped Left")
                    
                    imageIndex--
                    if imageIndex < 0 {
                        imageIndex = imageList.count - 1
                    }
                    
                    imageView.image = UIImage(named: imageList[imageIndex])

                default:
                    break //stops the code/codes nothing.
            }

        }

        imageView.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    @IBAction func controllerTapped(sender : AnyObject) {
        if(controllerImageView.hidden == false) {
            if(controllerImageView.image == pauseImage) {
                controllerImageView.image = playImage
                audioPlayer.pause()
                
            }
            else {
                audioPlayer.play()
                recordingStartedAtLeastOnce = true
                controllerImageView.image = pauseImage
                controllerImageView.hidden = true
                self.navigationController?.setNavigationBarHidden(!self.navigationController!.navigationBarHidden, animated: false)
            }
        }
    }
    
    @IBAction func imageTapped(sender : AnyObject) {
        controllerImageView.hidden = !controllerImageView.hidden
        self.navigationController?.setNavigationBarHidden(!self.navigationController!.navigationBarHidden, animated: false)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!,
        successfully flag: Bool){
            if(imageIndex < imageList.count - 1) {
                imageIndex++
                imageView.image = UIImage(named: imageList[imageIndex])
                audioPlayer = AVAudioPlayer(contentsOfURL: audioURLs[imageIndex], error: nil)
                audioPlayer.play()
            }
            
    }
}