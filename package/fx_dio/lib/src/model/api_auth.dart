class ApiAuth {
  final int? proAccountId;
  final String accessToken;
  final int userId;
  final Map<String, dynamic> appInfo;

  ApiAuth({
    required this.proAccountId,
    required this.userId,
    required this.accessToken,
    required this.appInfo,
  });

  bool get isProAccount {
    return (proAccountId ?? 0) > 0;
  }
}
