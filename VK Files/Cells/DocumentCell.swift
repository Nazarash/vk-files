//
//  MainDocumentCell.swift
//  VK Files
//
//  Created by Дмитрий on 22.04.2020.
//  Copyright © 2020 Dmitryd20. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {
    
    static let identifier = "DocumentCell"
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private var state: DownloadState!
    
    var delegate: DocumentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        previewImage.image = nil
    }
    
    func configure(with document: VkDocument) {
        previewImage.contentMode = .scaleAspectFit
        previewImage.image = UIImage(systemName: document.type.systemImageName)
        if let photo_preview = document.preview {
            previewImage.contentMode = .scaleAspectFill
            previewImage.loadImage(from: photo_preview)
        }
        titleLabel.text = document.title
        detailsLabel.text = ByteCountFormatter.string(fromByteCount: Int64(document.size), countStyle: .file)
        setAppearance(for: document.downloadState)
    }
    
    func setAppearance(for state: DownloadState) {
        self.state = state
        
        switch state {
        case .notDownloaded:
            progressBar.isHidden = true
            progressBar.setProgress(0, animated: false)
            downloadButton.isHidden = false
            switch NetworkService.state {
            case .online:
                downloadButton.setImage(UIImage(systemName: "arrow.down.to.line.alt"), for: .normal)
            case .offline:
                downloadButton.setImage(UIImage(systemName: "cloud"), for: .normal)
            }
        case .downloading:
            progressBar.isHidden = false
            downloadButton.isHidden = false
            downloadButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
        case .downloaded:
            progressBar.isHidden = true
            progressBar.setProgress(0, animated: false)
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
