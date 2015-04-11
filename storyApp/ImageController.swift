import UIKit

class ImageController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var recordIndicatorView: UIImageView!
    @IBOutlet weak var controllerImageView: UIImageView!
    let swipeRec = UISwipeGestureRecognizer()
    let imageList = ["ImageRowImage1","ImageRowImage2", "ImageRowImage3"]
    let recImage = UIImage(named: "player_record")
    let pauseImage = UIImage(named: "pause-icon")
    var recordingStartedAtLeastOnce = false
    
    var imageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRec.addTarget(self, action: "swipedView")
        imageView.addGestureRecognizer(swipeRec)
        imageView.userInteractionEnabled = true
        imageView.image = UIImage(named: imageList[0])
        imageView.frame = UIScreen.mainScreen().applicationFrame
        recordIndicatorView.hidden = true
                println(self.navigationController?.navigationBar.topItem?.leftBarButtonItem)
    }
    
    func showSave() {
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Done, target: self, action: "recordingDone")
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = saveButton
    }
    
    func hideSave() {
         self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
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
                
                
                imageIndex--
                
                if imageIndex < 0 {
                    
                imageIndex = imageList.count - 1
                    
                }
                
                imageView.image = UIImage(named: imageList[imageIndex])
            case UISwipeGestureRecognizerDirection.Left:
                println("User swiped Left")
               
                
                imageIndex++
                if imageIndex > imageList.count - 1 {
                    
                    imageIndex = 0
                    
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
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func controllerTapped(sender : AnyObject) {
        if(controllerImageView.image == pauseImage) {
            controllerImageView.image = recImage
            recordIndicatorView.hidden = true
            
        }
        else {
            recordingStartedAtLeastOnce = true
            controllerImageView.image = pauseImage
            recordIndicatorView.hidden = false
            controllerImageView.hidden = true
            self.navigationController?.setNavigationBarHidden(!self.navigationController!.navigationBarHidden, animated: false)
        }
        
    }
    
    @IBAction func imageTapped(sender : AnyObject) {
        controllerImageView.hidden = !controllerImageView.hidden
        self.navigationController?.setNavigationBarHidden(!self.navigationController!.navigationBarHidden, animated: false)
        if(controllerImageView.hidden == false && recordingStartedAtLeastOnce) {
                showSave()
        }
    }
    
    

}