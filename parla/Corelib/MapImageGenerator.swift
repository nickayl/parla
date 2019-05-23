//
//  MapImageGenerator.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 15/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

@objc public protocol MapImageGenerator {
    func generateImageFor(coordinates: CLLocationCoordinate2D, withPlacemark: Bool, completitionHandler: @escaping (UIImage?) -> Void)
}

@objc public class MapKitImageGenerator : NSObject, MapImageGenerator {
    
    public func generateImageFor(coordinates: CLLocationCoordinate2D, withPlacemark: Bool, completitionHandler: @escaping (UIImage?) -> Void) {
        let opts = MKMapSnapshotter.Options()
        
        opts.region = MKCoordinateRegion(center: coordinates,
                                         latitudinalMeters: CLLocationDistance(floatLiteral: 1000),
                                         longitudinalMeters: CLLocationDistance(1000))
        
        let snaps = MKMapSnapshotter(options: opts)
        
        snaps.start { (snapshot, error) in
            let img = snapshot?.image
            completitionHandler(img)
        }
        
    }
}
