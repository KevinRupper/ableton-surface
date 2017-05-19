//
//  ViewController.swift
//  ios-ableton-controller
//
//  Created by Kevin Rupper on 5/2/17.
//  Copyright © 2017 Guerrilla Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView?
    
    var udpClient:UdpClient?
    var udpServer:UdpServer?
    
    var collectionViewLayout: CollectionViewLayout!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set configure collection view
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.darkGray
        collectionViewLayout = collectionView?.collectionViewLayout as! CollectionViewLayout

        self.udpServer = UdpServer(socket: Socket())
    }
    
    @IBAction func connect(sender: AnyObject) {
        DispatchQueue.global(qos: .background).async {
            [unowned self] in
            
            let result = self.udpServer?.start()
            
            if result != Result.success {
                print("Error starting server")
            }
        }
    }
    
    @IBAction func close(sender: AnyObject) {}
}

extension ViewController: AbletonProtocol {
    func didMatrixSizeChange(tracks: Int, clips: Int) {
        collectionViewLayout.columns = tracks
        collectionViewLayout.items = clips
        collectionView?.reloadData()
    }
    
    func didClipSlotChange(track: Int, clip: Int, isRemoved: Int) {
        
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionViewLayout.columns * collectionViewLayout.items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clipCell", for: indexPath) as! ClipCell
        
        let trackIndex : Int = indexPath.item / (collectionViewLayout.items)
        let clipSlotIndex = indexPath.item - (trackIndex * collectionViewLayout.items)
    
        
        cell.label.text  = "Track: \(trackIndex), Slot:\(clipSlotIndex)"
        cell.image!.image = UIImage(named: "play-on.png")
        cell.label.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
        //auxCell.playButton!.addTarget(self, action: "playButtonClip", forControlEvents: UIControlEvents.TouchDown)
        
        //Color of cell depends if slot clip it's empty or not
//        cell.backgroundColor = UIColor(red: 85.0/255.0, green: 207.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        cell.backgroundColor = UIColor(red: 50.0/255.0, green: 52.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        
        return cell
    }
}
