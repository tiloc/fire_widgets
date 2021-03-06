import 'package:fhir/r4.dart';

import '../../../model.dart';

/// A pseudo-model for a static questionnaire item.
///
/// Used to represent items of types group, and display.
class StaticAnswerModel extends AnswerModel<Object, Object> {
  StaticAnswerModel(ResponseModel responseModel, int answerIndex)
      : super(responseModel, answerIndex);

  @override
  QuestionnaireResponseAnswer? get filledAnswer {
    throw UnimplementedError('StaticAnswerModel cannot fill an answer.');
  }

  @override
  String get display => AnswerModel.nullText;

  @override
  String? validateInput(Object? inValue) {
    return null;
  }

  @override
  QuestionnaireErrorFlag? get isComplete => null;

  @override
  bool get isUnanswered => false;
}
