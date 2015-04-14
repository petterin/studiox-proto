import UIKit
import AVFoundation

class ViewerController: UIViewController, AVAudioPlayerDelegate {

    required init(coder aDecoder: NSCoder) {
        self.audioPlayer = AVAudioPlayer()
        super.init(coder: aDecoder)
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var controllerImageView: UIImageView!
    let swipeRec = UISwipeGestureRecognizer()
    let imageList = ["story1.jpg","story2.jpg", "story3.jpg", "story4.jpg", "story5.jpg"]
    let audioURLs = ["story1_audio", "story2_audio", "story3_audio", "story4_audio", "story5_audio"].map({(filename) -> NSURL in
        let path = NSBundle.mainBundle().pathForResource(filename, ofType: "m4a")!
        return NSURL(fileURLWithPath: path)!})
    let playImage = UIImage(named: "play_icon")
    let pauseImage = UIImage(named: "pause-icon")
    var recordingStartedAtLeastOnce = false
    
    var imageIndex = 0
    var audioPlayer:AVAudioPlayer {
        didSet{
            audioPlayer.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRec.addTarget(self, action: "swipedView")
        imageView.addGestureRecognizer(swipeRec)
        imageView.userInteractionEnabled = true
        imageView.image = UIImage(named: imageList[0])
        imageView.frame = UIScreen.mainScreen().applicationFrame
        audioPlayer = AVAudioPlayer(contentsOfURL: audioURLs[0], error: nil)
        audioPlayer.prepareToPlay()
    }
    
    func showSaveOptionInNavBar() {
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Done, target: self, action: "recordingDone")
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = saveButton
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
    
    func swipedView(){
        
        switch swipeRec.direction {
            
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
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func recordingDone() {
        var alert = UIAlertController(title: "Save", message: "Please give a name for your story", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: saveCompletionHandler))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Amazing story"
        })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveCompletionHandler(action:UIAlertAction!) {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        
        let newStoriesController = storyboard.instantiateViewControllerWithIdentifier("mockStoriesAfterRecord") as UIViewController
        var oldTabs = self.tabBarController?.viewControllers
        oldTabs![1] = newStoriesController
        self.tabBarController?.setViewControllers(oldTabs!, animated: false)
        self.tabBarController?.selectedIndex = 1
        
        
        
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
        if(controllerImageView.hidden == false && recordingStartedAtLeastOnce) {
            showSaveOptionInNavBar()
        }
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