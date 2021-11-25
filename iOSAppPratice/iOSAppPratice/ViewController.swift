import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var firstView = UIView()
    var secondView = UIView()
    var dataAmount = 0
    let viewModel = ViewControllerViewModel()
    
    override func viewDidLoad() {
        initView()
        bindViewModel()
        viewModel.getApiData(lastIndex: -1)
    }
    
    @IBAction func buttonAction() {
        print("touch inside")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initView() {
        var safeAreaHeight : CGFloat = 0
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            safeAreaHeight = window?.safeAreaInsets.top ?? 0
        }
        firstView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300))
        firstView.backgroundColor = .darkGray
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 70, y: 270)
        label.textAlignment = .center
        label.text = "label"
        firstView.addSubview(label)
        view.addSubview(firstView)
        secondView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300))
        secondView.backgroundColor = .lightGray
        let button = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
        button.backgroundColor = .systemBlue
        button.setTitle("button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        secondView.addSubview(button)
        view.addSubview(secondView)
        tableView.estimatedRowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 300 - safeAreaHeight, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.white
    }
    
    func bindViewModel() {
        viewModel.onRequestEnd = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell {
            viewModel.getApiData(lastIndex: indexPath.row)
            cell.picture.image = viewModel.listCellViewModels[indexPath.row].pic
            cell.nameLabel.text =  viewModel.listCellViewModels[indexPath.row].name
            cell.featureText.text  = viewModel.listCellViewModels[indexPath.row].feature
            cell.locationText.text  = viewModel.listCellViewModels[indexPath.row].location
            return cell
        }
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 120), 300)
        secondView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        secondView.alpha = ( (height - 120) / 180)
        firstView.frame = CGRect(x: 0, y: -(300 - height), width: UIScreen.main.bounds.size.width, height: 300)
    }
}

