/// [crm]: 用户登录
enum Host {
  github("api.github.com", ""),
  ;

  final String value;
  final String testValue;
  final String version;

  const Host(this.value, this.testValue, {this.version = ''});

  String url({bool ssl = true, bool isDev = false}) {
    String schema = ssl ? 'https://' : 'http://';
    String host = isDev ? testValue : value;
    return schema + host;
  }
}

enum GithubApi {
  // auth
  a("/a"),
  ;

  final String path;
  final Method? method;

  const GithubApi(this.path,[this.method]);
}

enum Method{
  post,
  get
}