//
//  VCMapView.swift
//  MapKitDemo
//
//  Created by 吴林丰 on 2017/4/27.
//  Copyright © 2017年 吴林丰. All rights reserved.
//

import UIKit
import MapKit

extension ViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Artwork {
            let identifier = "pin"
            var view:MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                 dequeuedView.annotation = annotation
                 view = dequeuedView
            }else{
            
                view = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint.init(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure)
            }
            view.pinTintColor = UIColor.purple
            return view
        }
        /**
         mapView(_:viewForAnnotation:)是调用您添加到地图的每个注释的方法（
         类似于tableView(_:cellForRowAtIndexPath:)使用表视图时），以返回每个注释的视图。
         
         同样地tableView(_:cellForRowAtIndexPath:)，映射视图被设置为在某些不再可见时重新使用注释视图。
         因此，在创建新的注释视图之前，代码首先检查是否有可用的注释视图。
         
         在这里，MKAnnotationView如果注释视图不能出队，则使用普通的vanilla 类。
         它使用你的Artwork课程的标题和字幕属性来确定在标注中显示的内容 - 当用户点击引脚时弹出的小泡泡
         
         */
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    
}

class VCMapView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
