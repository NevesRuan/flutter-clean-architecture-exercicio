class AuthHeaders {
  static Map<String, String> bearer(String? token) {
    if (token == null || token.isEmpty) {
      return const {'Content-Type': 'application/json'};
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
