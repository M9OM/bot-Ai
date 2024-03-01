import 'package:flutter/cupertino.dart';

import '../models/models_model.dart';
import '../chatGptServs/chatGptServ.dart';

class ModelsProvider with ChangeNotifier {
  // String currentModel = "text-davinci-003";
  String currentModel = "gpt-3.5-turbo-16k";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}