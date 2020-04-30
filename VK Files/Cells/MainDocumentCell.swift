//
//  MainDocumentCell.swift
//  VK Files
//
//  Created by Дмитрий on 22.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class MainDocumentCell: UITableViewCell {
    
    static let identifier = "MainDocumentCell"
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private var state: DownloadState!
    
    var delegate: DocumentCellDelegate?
    
    override func prepareForReuse() {
        previewImage.image = nil
    }
    
    func configure(with document: VkDocument) {
        previewImage.image = UIImage(systemName: document.systemImageName)
        previewImage.loadImage(from: document.preview)
        titleLabel.text = document.title
        detailsLabel.text = ByteCountFormatter.string(fromByteCount: document.size, countStyle: .file)
        
        setAppearance(for: document.downloadState)
    }
    
    func setAppearance(for state: DownloadState) {
        self.state = state
        
        switch state {
        case .notDownloaded:
            progressBar.isHidden = true
            downloadButton.isHidden = false
            downloadButton.setImage(UIImage(systemName: "arrow.down.to.line.alt"), for: .normal)
        case .downloading:
            progressBar.isHidden = false
            progressBar.setProgress(0, animated: false)
            downloadButton.isHidden = false
            downloadButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
        case .downloaded:
            progressBar.isHidden = true
            downloadButton.isHidden = true
        }
    }
    
    func setDownloadProgress(_ progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        if state == .notDownloaded {
            delegate?.downloadStarted(self)
        } else if state == .downloading {
            delegate?.donloadCancelled(self)
        }
    }
}
