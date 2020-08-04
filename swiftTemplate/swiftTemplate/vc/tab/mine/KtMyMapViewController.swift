//
//  KtMyMapViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/25.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 我的地图
import UIKit
import AMapSearchKit
class KtMyMapViewController: BaseViewController {
    
    let locationManager = AMapLocationManager()
    let search = AMapSearchAPI()
    let keyword1 = "商务住宅|科教文化服务|传媒机构|学校|地铁站|住宿服务|体育休闲服务|生活服务|地铁站"
    let keyword = "商务住宅|学校|宾馆酒店|地铁站"
    var pointAnnotation = MAPointAnnotation()
    var list:[MAPointAnnotation]? = []
    var infoList : [AMapPOI]? = []
    var userlocation:CLLocation? = nil
    var ktcity :String? = nil
    var MyMapViewType = 0
    lazy var  countrySearchController:UISearchController? = UISearchController()
    func callBackBlock(block : @escaping swiftblock)  {
        callBack = block
    }
    var callBack :swiftblock?
    typealias swiftblock = (_ btntag : AMapPOI? ) -> Void
    @IBOutlet weak var mymap: MAMapView!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func initView() {
        self.countrySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self   //两个样例使用不同的代理
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.barStyle = .default
            //            controller.view.backgroundColor = .white
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "输入地名进行搜索"
            return controller
        })()
        self.navigationItem.titleView = self.countrySearchController?.searchBar
        mymap.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: KtMyMapAddressViewCell.reuseID, bundle: nil), forCellReuseIdentifier: KtMyMapAddressViewCell.reuseID)
        
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        mymap.compassOrigin = CGPoint(x: self.mymap.bounds.maxX-50, y: self.mymap.bounds.minY+100)
        mymap.showsUserLocation = true
        mymap.userTrackingMode = .follow
        search?.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 30
        locationManager.reGeocodeTimeout = 30
        startLoc()
    }
    
    /// 关闭持续定位
    /// - Parameter animated: 是否开启动画
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    /// 开始定位
    func startLoc(){
        locationManager.requestLocation(withReGeocode: false, completionBlock: {  (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
                self.ShowTip(Title: "定位失败")
            }
            
            if  let location = location {
                self.userlocation = location
                
            }
            
            if let reGeocode = reGeocode{
                log.verbose("\(reGeocode)")
                let request = AMapPOIKeywordsSearchRequest()
                if location != nil {
                    request.location = AMapGeoPoint.location(withLatitude: CGFloat(location!.coordinate.latitude), longitude: CGFloat(location!.coordinate.longitude))
                }
                self.ktcity = reGeocode.city
                request.keywords = reGeocode.street
                request.cityLimit = true
                request.types = self.keyword
                request.city = reGeocode.city
                self.searchKeyPoit(request: request)
            }else{
                self.locationManager.locatingWithReGeocode = true
                self.locationManager.startUpdatingLocation()
            }
            
        })
    }
    
    /// 搜索地点
    /// - Parameter request: 参数
    func searchKeyPoit(request:AMapPOIKeywordsSearchRequest){
        locationManager.stopUpdatingLocation()
        mymap.removeAnnotations(list)
        self.search?.aMapPOIKeywordsSearch(request)
    }
}
extension KtMyMapViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || (searchController.searchBar.text?.count ?? 0) < 2  || searchController.searchBar.text == ""{
            log.verbose("搜查的内容---  \(searchController.searchBar.text ?? "")")
            return
        }else{
            let request = AMapPOIKeywordsSearchRequest()
            if self.userlocation != nil {
                request.location = AMapGeoPoint.location(withLatitude: CGFloat(self.userlocation!.coordinate.latitude), longitude: CGFloat(self.userlocation!.coordinate.longitude))
            }
            log.verbose("搜索关键词\(searchController.searchBar.text ?? "")")
            request.keywords = searchController.searchBar.text ?? ""
            request.cityLimit = true
            request.types = keyword1
            request.city = ktcity
            self.searchKeyPoit(request: request)
        }
        
        
    }
    
    
}
extension KtMyMapViewController :MAMapViewDelegate{
    /// 根据传入的annotation来展现：保持中心点不变的情况下，展示所有传入annotation
    ///
    /// - Parameters:
    ///   - annotations: annotation
    ///   - insets: 填充框，用于让annotation不会靠在地图边缘显示
    ///   - mapView: 地图view
    func showsAnnotations(_ annotations:Array<MAPointAnnotation>, edgePadding insets:UIEdgeInsets, andMapView mapView:MAMapView!) {
        var rect:MAMapRect = MAMapRectZero
        
        for annotation:MAPointAnnotation in annotations {
            let diagonalPoint:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude - (annotation.coordinate.latitude - mapView.centerCoordinate.latitude),mapView.centerCoordinate.longitude - (annotation.coordinate.longitude - mapView.centerCoordinate.longitude))
            
            let annotationMapPoint: MAMapPoint = MAMapPointForCoordinate(annotation.coordinate)
            let diagonalPointMapPoint: MAMapPoint = MAMapPointForCoordinate(diagonalPoint)
            
            let annotationRect:MAMapRect = MAMapRectMake(min(annotationMapPoint.x, diagonalPointMapPoint.x), min(annotationMapPoint.y, diagonalPointMapPoint.y), abs(annotationMapPoint.x - diagonalPointMapPoint.x), abs(annotationMapPoint.y - diagonalPointMapPoint.y));
            
            rect = MAMapRectUnion(rect, annotationRect)
        }
        
        mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
    }
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAUserLocation.self) {
            
            return nil
        }
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.pinColor = .red
            return annotationView!
        }
        return nil
    }
    func mapView(_ mapView: MAMapView!, didTouchPois pois: [Any]!) {
        
    }
}
extension KtMyMapViewController:AMapSearchDelegate{
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        log.verbose("搜索结果数量----\(response.pois.count)")
        if response.count == 0 || response.pois.count == 0{
            return
        }
        if let listf = response.pois{
            log.verbose("tableview添加数据\(listf)")
            infoList = listf
            self.tableview.reloadData()
        }
        
        for (_,item) in response!.pois.enumerated() {
                 log.verbose("地图添加标记\(item)")
                let pointAnnotation = MAPointAnnotation()
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(item.location.latitude), longitude: CLLocationDegrees(item.location.longitude))
                pointAnnotation.title = item.name
                pointAnnotation.subtitle = item.address
                mymap.addAnnotation(pointAnnotation)
                list?.append(pointAnnotation)
        }
        
    }
}
extension KtMyMapViewController:AMapLocationManagerDelegate{
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
        
    }
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestWhenInUseAuthorization()
    }
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        if let reGeocode = reGeocode {
            log.verbose("\(reGeocode)")
            let request = AMapPOIKeywordsSearchRequest()
            if location != nil {
                request.location = AMapGeoPoint.location(withLatitude: CGFloat(location!.coordinate.latitude), longitude: CGFloat(location!.coordinate.longitude))
            }
            request.keywords = reGeocode.street
            request.cityLimit = true
            request.city = reGeocode.city
            self.searchKeyPoit(request: request)
            self.locationManager.stopUpdatingLocation()
        }
        
    }
    
}
extension KtMyMapViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = infoList?[indexPath.item]
        let address = "\(info?.province ?? "")\(info?.city ?? "")\(info?.district ?? "")\(info?.address ?? "")\(info?.name ?? "")"
        if address.count > 5 && MyMapViewType == 1{
            let body = RequestBody()
            body.id = UserInfoHelper.instance.user?.id ?? 0
            body.address = address
            body.province = info?.province ?? ""
            body.city = info?.city ?? ""
            MyMoyaManager.AllRequest(controller: self, NetworkService.updateuserinfo(k: body.toJSONString() ?? "")) { (data) in
                UserInfoHelper.instance.user = data.userinfo
                self.ShowTipsClose(tite: data.msg ?? "更新成功")
            }
        }else if MyMapViewType == 2 {
            log.verbose("返回发帖")
            if callBack != nil {
                callBack!(infoList?[indexPath.item])
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtMyMapAddressViewCell.reuseID, for: indexPath) as! KtMyMapAddressViewCell
        cell.updateCell(info: infoList?[indexPath.item])
        return cell
    }
    
    
}
