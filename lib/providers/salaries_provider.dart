import 'package:flutter/foundation.dart';
import 'package:hejposta/models/postman_salary_model.dart';

class PostmanSalariesProvier extends ChangeNotifier{
  final List<PostmanSalaryModel> _salaries = [];

  List<PostmanSalaryModel> getSalaries() => _salaries;

  addSalaries(List<PostmanSalaryModel> salaries) {
    _salaries.clear();
    _salaries.addAll(salaries);
    notifyListeners();
  }

  addSalary(PostmanSalaryModel salary){
    _salaries.add(salary);
    notifyListeners();
  }

  removeSalary(){
    _salaries.clear();
    notifyListeners();
  }
}