import UIKit

class ImageController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let swipeRec = UISwipeGestureRecognizer()
    let imageList = ["ImageRowImage1","ImageRowImage2", "ImageRowImage3"]
    var imageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRec.addTarget(self, action: "swipedView")
        imageView.addGestureRecognizer(swipeRec)
        imageView.userInteractionEnabled = true
        imageView.image = UIImage(named: imageList[0])
        imageView.frame = UIScreen.mainScreen().applicationFrame;
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: false)
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
}