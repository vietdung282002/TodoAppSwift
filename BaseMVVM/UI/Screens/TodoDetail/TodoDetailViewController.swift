//
//  AddTodoViewController.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 15/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TodoDetailViewController: ViewController<TodoDetailViewModel,TodoDetailNavigator> {
    
    var todoId: Int?
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var timeTextField: CustomTextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var taskTitleLabel: CustomTextField!
    @IBOutlet weak var taskCategoryImage: UIImageView!
    @IBOutlet weak var eventCategoryImage: UIImageView!
    @IBOutlet weak var goalCategoryImage: UIImageView!
    @IBOutlet weak var saveButton: CustomButton!
    
    private var categoryOpt = BehaviorRelay<Int?>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setTitle("Add New Task", subTitle: nil)
        if todoId != nil{
            viewModel.loadTodo(todoId: todoId!)
            updateTodo()
            setTitle("Edit Task", subTitle: nil)
        }
    }
    
    override func setupUI(){
        super.setupUI()
        
        showLeftButton(image: UIImage(named: "BackButton"))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        let calendarIcon = UIImageView(image: UIImage(named: "iconCalendar"))
        calendarIcon.contentMode = .scaleAspectFit
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 18))
        calendarIcon.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        
        paddingView.addSubview(calendarIcon)
        
        dateTextField.rightView = paddingView
        dateTextField.rightViewMode = .always
        
        addEndIcon(textField: dateTextField, image: UIImage(named: "iconCalendar"),action: nil)
        addEndIcon(textField: timeTextField, image: UIImage(named: "iconClock"),action: nil)
        
        noteTextView.textContainerInset = UIEdgeInsets(top: 8,left: 5,bottom: 8,right: 5)
        
        setupDateTimePicker(forTextField: dateTextField, mode: .date)
        setupDateTimePicker(forTextField: timeTextField, mode: .time)
        
        
        let taskCategoryTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        taskCategoryImage.addGestureRecognizer(taskCategoryTap)
        let eventCategoryTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        eventCategoryImage.addGestureRecognizer(eventCategoryTap)
        let goalCategoryTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        goalCategoryImage.addGestureRecognizer(goalCategoryTap)
        
        noteTextView.placeholder = "Detail.Notes".localized()
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.black.cgColor
        noteTextView.layer.cornerRadius = 7 
    }
    
    
    override func setupListener(){
        super.setupListener()
        
        categoryOpt.subscribe(onNext: {[weak self] category in
            switch category{
            case 1:
                self!.taskCategoryImage.backgroundColor = .gray
                self!.eventCategoryImage.backgroundColor = .clear
                self!.goalCategoryImage.backgroundColor = .clear
            case 2:
                self!.taskCategoryImage.backgroundColor = .clear
                self!.eventCategoryImage.backgroundColor = .gray
                self!.goalCategoryImage.backgroundColor = .clear
            case 3:
                self!.taskCategoryImage.backgroundColor = .clear
                self!.eventCategoryImage.backgroundColor = .clear
                self!.goalCategoryImage.backgroundColor = .gray
            case nil:
                return
            case .some(_):
                return
            }
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.bind{[weak self] in
            guard let self = self else { return }
            if todoId == nil{
                viewModel.addTodo(taskTitle: taskTitleLabel.text ?? "", categoryId: categoryOpt.value ?? 0, taskNote: noteTextView.text, time: convertToDateTimeFormat(dateString: dateTextField.text ?? "", timeString: timeTextField.text ?? ""))
            }else{
                viewModel.editTodo(taskTitle: taskTitleLabel.text ?? "", categoryId: categoryOpt.value ?? 0, taskNote: noteTextView.text, time: convertToDateTimeFormat(dateString: dateTextField.text ?? "", timeString: timeTextField.text ?? ""))
            }
            
        }.disposed(by: disposeBag)
        
        viewModel.loadingIndicator.asObservable().bind(to: isLoading).disposed(by: disposeBag)
    }
    
    private func setupDateTimePicker(forTextField textField: UITextField, mode: UIDatePicker.Mode) {
        let date = Date()
        let formatter = DateFormatter()
        
        switch mode {
        case .date:
            formatter.dateFormat = "dd/MM/yyyy"
        case .time:
            formatter.dateFormat = "hh:mm a"
        default:
            formatter.dateFormat = "dd/MM/yyyy"
        }
        
        textField.text = formatter.string(from: date)
        textField.textColor = .blue
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.addTarget(self, action: #selector(dateTimePickerValueChanged(sender:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 150)
        
        textField.inputView = datePicker
    }
    
    @objc private func dateTimePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        
        if sender.datePickerMode == .date {
            formatter.dateFormat = "dd/MM/yyyy"
        } else if sender.datePickerMode == .time {
            formatter.dateFormat = "hh:mm a"
        }
        
        if let activeTextField = view.findFirstResponder() as? UITextField {
            activeTextField.text = formatter.string(from: sender.date)
        }
    }
    
    private func updateTodo(){
        viewModel.todo.subscribe(
            onNext: { todo in
                self.taskTitleLabel.text = todo.taskTitle
                self.dateTextField.text = todo.dateFormatted()
                self.timeTextField.text = todo.timeFormatted()
                self.noteTextView.text = todo.taskNote
                self.categoryOpt.accept(todo.categoryId)
            }
        ).disposed(by: disposeBag)
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        if let tappedImageView = sender.view as? UIImageView {
            if tappedImageView == taskCategoryImage {
                categoryOpt.accept(1)
            } else if tappedImageView == eventCategoryImage {
                categoryOpt.accept(2)
            } else if tappedImageView == goalCategoryImage {
                categoryOpt.accept(3)
            }
        }
    }
}

