class CalculateUseCase {
  double call(String expression) {
    final tokens = _tokenize(expression.replaceAll(' ', ''));
    _index = 0;
    _tokens = tokens;
    final value = _parseExpression();
    if (_index != _tokens.length) {
      throw FormatException('Invalid expression');
    }
    return value;
  }

  late List<String> _tokens;
  int _index = 0;

  List<String> _tokenize(String expr) {
    final tokens = <String>[];
    final buffer = StringBuffer();
    for (var i = 0; i < expr.length; i++) {
      final ch = expr[i];
      if (RegExp(r'[0-9.]').hasMatch(ch)) {
        buffer.write(ch);
      } else {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        tokens.add(ch);
      }
    }
    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString());
    }
    return tokens;
  }

  String _peek() => _index < _tokens.length ? _tokens[_index] : '';
  String _consume() => _tokens[_index++];

  double _parseExpression() {
    var value = _parseTerm();
    while (true) {
      final tok = _peek();
      if (tok == '+' || tok == '-') {
        _consume();
        final term = _parseTerm();
        if (tok == '+') {
          value += term;
        } else {
          value -= term;
        }
      } else {
        break;
      }
    }
    return value;
  }

  double _parseTerm() {
    var value = _parseFactor();
    while (true) {
      final tok = _peek();
      if (tok == '*' || tok == '/') {
        _consume();
        final factor = _parseFactor();
        if (tok == '*') {
          value *= factor;
        } else {
          value /= factor;
        }
      } else {
        break;
      }
    }
    return value;
  }

  double _parseFactor() {
    final tok = _peek();
    if (tok.isEmpty) {
      throw FormatException('Unexpected end of input');
    }
    if (tok == '(') {
      _consume();
      final value = _parseExpression();
      if (_consume() != ')') {
        throw FormatException('Missing closing parenthesis');
      }
      return value;
    }
    if (tok == '-') {
      _consume();
      return -_parseFactor();
    }
    _consume();
    return double.parse(tok);
  }
}
