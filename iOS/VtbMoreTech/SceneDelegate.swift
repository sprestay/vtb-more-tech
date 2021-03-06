import UIKit
//import GravitySliderFlowLayout

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let windowScene = scene as! UIWindowScene
        let window = UIWindow(windowScene: windowScene)
        
        Marketplace.shared.upload()
        
        UIApplication.shared.statusBarStyle = .lightContent
            
        // MARK:-TestVC
        let cameraVC = ModuleBuilder.createCameraModule()
        let navBarCamera = UINavigationController(rootViewController: cameraVC)
        if let findCarImage = UIImage(named: "FindCar")?.pngData() {
            let testImg =  UIImage(data: findCarImage, scale: 7.25)
            let testBarItem = UITabBarItem(title: "Поиск машины", image: testImg, selectedImage: nil)
            cameraVC.tabBarItem = testBarItem
        }
        
        
        //MARK:- ProfileVC
        let profileVC = ModuleBuilder.createProfileModule()
        let navBarProfile = UINavigationController(rootViewController: profileVC)
        if let profileImage = UIImage(named: "Profile")?.pngData() {
            let testImg =  UIImage(data: profileImage, scale: 8.25)
            let testBarItem = UITabBarItem(title: "Профиль", image: testImg, selectedImage: nil)
            profileVC.tabBarItem = testBarItem
        }
        
        let offersVC = ModuleBuilder.createOfferModule(carBrand: "Cadillac", carModel: "ESCALADE", beautyCarBrand: "Cadillac", beautyCarModel: "ESCALADE")
        let navBarOffers = UINavigationController(rootViewController: offersVC)
        
        // MARK:- Setup NavBar
        let tabBar = UITabBarController()
        tabBar.tabBar.tintColor = UIColor.appColor(.TabBarTintColor)
        tabBar.tabBar.barTintColor = UIColor.appColor(.TabBarBackgroundColor)
        tabBar.setViewControllers([navBarCamera], animated: true)
        tabBar.selectedViewController = navBarCamera
        tabBar.tabBar.unselectedItemTintColor = UIColor.appColor(.White)
        
        let formVC = InputsFormViewController()

        window.rootViewController = UINavigationController(rootViewController: cameraVC)

        window.backgroundColor = .white
        self.window = window
        window.makeKeyAndVisible()
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

