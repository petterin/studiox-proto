import UIKit

class ImageController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var recordIndicatorView: UIImageView!
    @IBOutlet weak var controllerImageView: UIImageView!
    @IBOutlet weak var recPause: UIButton!

    let imageList = ["mokki1.jpg","mokki2.jpg","mokki3.jpg","mokki4.jpg","mokki5.jpg","mokki6.jpg","mokki7.jpg","mokki8.jpg","mokki9.jpg","mokki10.jpg","mokki11.jpg","mokki12.jpg","mokki13.jpg"]
    
    let recImage = UIImage(named: "player_record")
    let pauseImage = UIImage(named: "pause_icon")
    var recordingStartedAtLeastOnce = false
    
    var imageIndex = 0
    
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
        recordIndicatorView.hidden = true
        // println(self.navigationController?.navigationBar.topItem?.leftBarButtonItem)
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

    func swipedView(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right:
                    println("User swiped right")
                    
                    imageIndex--
                    if imageIndex < 0 {
                        imageIndex = imageList.count - 1
                    }
                    
                    imageView.image = UIImage(named: imageList[imageIndex])

                case UISwipeGestureRecognizerDirection.Left:
                    println("User swiped left")
                    
                    imageIndex++
                    if imageIndex > imageList.count - 1 {
                        imageIndex = 0
                    }
                    
                    imageView.image = UIImage(named: imageList[imageIndex])

                default:
                    break //stops the code/codes nothing.
            }

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
        
        let newStoriesController = storyboard.instantiateViewControllerWithIdentifier("mockStoriesAfterRecord") as! UIViewController
        var oldTabs = self.tabBarController?.viewControllers
        oldTabs![1] = newStoriesController
        self.tabBarController?.setViewControllers(oldTabs!, animated: false)
        self.tabBarController?.selectedIndex = 1

        
       
    }
    
    @IBAction func controllerTapped(sender : AnyObject) {
        if(controllerImageView.hidden == false) {
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
    }
    
    @IBAction func imageTapped(sender : AnyObject) {
        controllerImageView.hidden = !controllerImageView.hidden
        self.navigationController?.setNavigationBarHidden(!self.navigationController!.navigationBarHidden, animated: false)
        if(controllerImageView.hidden == false && recordingStartedAtLeastOnce) {
                showSaveOptionInNavBar()
        }
    }
    
    @IBAction func pressed(sender: UIButton!) {
        controllerImageView.hidden = !controllerImageView.hidden
        controllerImageView.image = recImage
        
    }
}