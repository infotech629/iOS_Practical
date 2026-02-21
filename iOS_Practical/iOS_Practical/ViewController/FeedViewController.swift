//
//  FeedViewController.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import UIKit

class FeedViewController: UIViewController {
    //MARK: - Outlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    let data = [String]()
    let viewModel = FeedViewModel()
    var items =  [FeedItem]()
    let loadingIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        self.tableViewConfiguration()
        self.loadFeed()
        
        
        
    }
   
    //MARK: - Function
    func setUpUi(){
        self.titleLabel.text = "Feed"
        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    func tableViewConfiguration(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.register(UINib(nibName: FeedTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FeedTableViewCell.identifier)
        self.tableView.register(UINib(nibName: NoDataFoundTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NoDataFoundTableViewCell.identifier)
        self.tableView.reloadData()
        self.setupRefreshControl()
    }
    func setupRefreshControl() {
        refreshControl.tintColor = .systemBlue
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
   
}


//MARK: - Other Funcion
extension FeedViewController {
    @objc func handleRefresh() {
        loadFeed()
    }
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet",
            message: "Please check your connection.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    func loadFeed() {
        loadingIndicator.startAnimating()
        self.items.removeAll()
        tableView.isHidden = true
        
        Task { @MainActor in
            await viewModel.loadFeed()
            
            loadingIndicator.stopAnimating()
            
            switch viewModel.state {
            case .loading:
                refreshControl.endRefreshing()
                tableView.reloadData()
                break
            case .loaded(let feedItems):
                items = feedItems
                tableView.isHidden = false
                tableView.reloadData()
                tableView.layoutIfNeeded()
                DispatchQueue.main.async { [weak self] in
                    self?.updateCenteredCell()
                }
                refreshControl.endRefreshing()
            case .error(let message):
                tableView.reloadData()
                refreshControl.endRefreshing()
                let alert = UIAlertController(
                    title: "Error",
                    message: message,
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                present(alert, animated: true)
            }
        }
    }
    
    func updateCenteredCell() {
        let visibleCells = tableView.visibleCells.compactMap { $0 as? FeedTableViewCell }
        guard !visibleCells.isEmpty else {
            VideoPlayerManager.shared.pauseVideo()
            return
        }
        
        let visibleRect = CGRect(
            x: tableView.contentOffset.x,
            y: tableView.contentOffset.y,
            width: tableView.bounds.width,
            height: tableView.bounds.height
        )
        let centerY = visibleRect.midY
        
        var closestCell: FeedTableViewCell?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for cell in visibleCells {
            let cellFrameInTableView = tableView.convert(cell.bounds, from: cell)
            let cellCenterY = cellFrameInTableView.midY
            let distance = abs(cellCenterY - centerY)
            
            if distance < minDistance {
                minDistance = distance
                closestCell = cell
            }
        }
        for cell in visibleCells {
            cell.pauseVideo()
        }
        closestCell?.playVideoIfNeeded()
    }
    
    
}
// MARK: - UITableViewDataSource, UITableViewDelegate

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count != 0 {
           return self.items.count
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.items.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
            let item = items[indexPath.row]
            let isExpanded = viewModel.isExpanded(at: indexPath.row)
            cell.delegate = self
            cell.configure(with: item, index: indexPath.row, isExpanded: isExpanded)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundTableViewCell.identifier, for: indexPath) as! NoDataFoundTableViewCell
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count != 0 {
            return UITableView.automaticDimension
        }else {
            return self.tableView.layer.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        450
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCenteredCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCenteredCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateCenteredCell()
        }
    }
}

// MARK: - FeedCellDelegate

extension FeedViewController: FeedCellDelegate {
    func feedCell(_ cell: FeedTableViewCell, didRequestExpandForIndex index: Int) {
        viewModel.toggleExpanded(at: index)
        tableView.performBatchUpdates {
            if let indexPath = tableView.indexPath(for: cell) {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        } completion: { [weak self] _ in
            self?.updateCenteredCell()
        }
    }
}
