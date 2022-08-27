class LineEncoding {
  final List<int> _signal;

  LineEncoding(this._signal);

  List<int> convert(String type) {
    List<int> result = List.filled(_signal.length, 0);

    switch (type) {
      case "nrz":
        for (var i = 0; i < _signal.length; i++) {
          result[i] = (_signal[i] == 0) ? 1 : -1;
        }
        break;

      case "nrz-i":
        for (var i = 0; i < _signal.length; i++) {
          if (i != 0) {
            if (_signal[i] == 0) {
              result[i] = result[i - 1];
            } else {
              result[i] = (result[i - 1] == 1) ? -1 : 1;
            }
          } else {
            result[0] = (_signal[i] == 0) ? 1 : -1;
          }
        }
        break;

      case "pzr":
        result = List.filled(_signal.length * 2, 0);
        for (var i = 0; i < _signal.length; i++) {
          result[i * 2] = (_signal[i] == 0) ? -1 : 1;
          result[(i * 2) + 1] = 0;
        }
        break;

      case "me":
        result = List.filled(_signal.length * 2, 0);
        for (var i = 0; i < _signal.length; i++) {
          result[i * 2] = (_signal[i] == 0) ? 1 : -1;
          result[(i * 2) + 1] = (_signal[i] == 0) ? -1 : 1;
        }
        break;

      case "dme":
        result = List.filled(_signal.length * 2, 0);
        for (var i = 0; i < _signal.length; i++) {
          if (i != 0) {
            result[i * 2] = (_signal[i] == 0)
                ? result[(i * 2) - 2] // no change
                : (result[(i * 2) - 2] == 1) // change
                    ? -1
                    : 1;
            result[(i * 2) + 1] = (result[(i * 2)] == 1) ? -1 : 1;
          } else {
            result[0] = (_signal[i] == 0) ? -1 : 1;
            result[1] = (result[0] == 1) ? -1 : 1;
          }
        }
        break;

      case "ml":
        if (_signal.length % 2 != 0) return List.empty();

        result = List.filled(_signal.length ~/ 2, 0);
        for (var i = 0; i < _signal.length; i += 2) {
          int factor = 1;
          int index = i ~/ 2;

          if (i != 0) {
            if (result[index - 1] < 0) {
              factor = -1;
            }
          }

          switch ("${_signal[i]}${_signal[i + 1]}") {
            case "00":
              result[index] = factor * 1;
              break;
            case "01":
              result[index] = factor * 3;
              break;
            case "10":
              result[index] = factor * -1;
              break;
            case "11":
              result[index] = factor * -3;
              break;
          }
        }
    }

    return result;
  }
}
