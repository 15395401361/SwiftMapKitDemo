//
//  ViewController.swift
//  MapKitDemo
//
//  Created by 吴林丰 on 2017/4/26.
//  Copyright © 2017年 吴林丰. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    let initialLocation = CLLocation.init(latitude: 21.282778, longitude: -157.829444)//设置一个初始位置
    
    /**
        当你试图告诉地图上显示的内容时，你不能仅仅给经纬度，这足以使地图居中，但是您需要指定要显示的矩形区域
     以获得正确的缩放级别。
     */
    
    let regionRadius:CLLocationDistance = 1000
    var artworks = [Artwork]()
    
    func loadInitialDate(){
        // 1.获取文件路径
        let path = Bundle.main.path(forResource: "PublicArt.json", ofType: nil)
        // 2.通过文件路径创建NSData
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            // 带throws的方法需要抛异常
            do {
                /*
                 * 有可能发生异常的代码放在这
                 */
                // 3.序列化 data -> array
                /*
                 * try 和 try! 的区别
                 * try 发生异常会跳到catch代码中
                 * try! 发生异常程序会直接crash
                 */
                let dictArr = try JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                // 4.遍历数组
                // 在Swift中遍历数组，必须明确数据的类型 [[String: String]]表示字典里键值都是字符串 [[String]]表示数组里都是字符串
                if let _ = dictArr as? [String: AnyObject],
                    // 4
                    let jsonData = JSONValue.fromObject(object: dictArr as AnyObject)?["data"]?.array{
                    for artworkJSON in jsonData {
                        if let artworkJSON = artworkJSON.array,
                            // 5
                            let artwork = Artwork.fromJSON(json: artworkJSON) {
                            artworks.append(artwork)
                        }
                    }
                }
            }catch {
                // 异常代码放在这
                print(error)
            }
        }
    }
    
    func centerMapOnLocation(location:CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0,regionRadius * 2.0 )
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    /**
     该location参数是中心点。该地区将根据距离regionRadius设置南北和东西跨度- 您设置为1000米（1公里），这是一个半英里以上。然后regionRadius * 2.0，您可以在这里使用，因为它可以很好地绘制JSON文件中的公开图形数据。
     setRegion告诉mapView显示该地区。地图视图通过整齐的缩放动画自动将当前视图转换到所需区域，无需额外的代码！
     */
    
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        /**
         这将调用帮助程序来放大initialLocation启动。
         构建和运行应用程序，现在应该放大到威基基的心脏：]
         */
        centerMapOnLocation(location: initialLocation)
        let artWork = Artwork.init(title: "吴林丰", locationName: "阜通东大街", discipline: "sculpture", coordinate: CLLocationCoordinate2DMake(21.283921, -157.831661))
        mapView.addAnnotation(artWork)
        mapView.delegate = self
        
        loadInitialDate()
        mapView.addAnnotations(artworks)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

