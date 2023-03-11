//
//  ViewController.swift
//  FFCodingExercise
//
//  Created by Brian McIntosh on 3/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var tasks = ["KPWM", "KAUS"]
    //var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FF Coding Exercise"
        
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
                
        // Create a URLRequest for an API endpoint
        let url = URL(string: "https://qa.foreflight.com/weather/report/kpwm")!
        var request = URLRequest(url: url)

        request.setValue(
            "1",
            forHTTPHeaderField: "ff-coding-exercise"
        )

        // Create the HTTP request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
                print(error)
            } else if let data = data {
                // Handle HTTP request response
                print(data)
                
                let response: Response = try! JSONDecoder().decode(Response.self, from: data)

                print(response.report.conditions.ident)
        
            } else {
                // Handle unexpected error
            }
        }
        task.resume()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if searchTextField.text == "" {
            print("please enter some text")
            
            // Create new Alert
            var dialogMessage = UIAlertController(title: "", message: "Please enter an airport abbreviation.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            
        }else{
            print("navigate to detail screen")
            searchTextField.resignFirstResponder()
            
            let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
            vc.title = "Detail View"
            vc.task = searchTextField.text
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // un-highlight the row
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        vc.title = "Detail View"
        vc.task = searchTextField.text
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
