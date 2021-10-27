class TokenProvider {
  String _token;

  static final TokenProvider _instance = TokenProvider._internal();

  factory TokenProvider() {
    return _instance;
  }

  TokenProvider._internal();

  void setToken(String token) {
    this._token = token;
  }

  String getToken() => _token;

  bool hasToken() => _token != null && _token != '';
}
