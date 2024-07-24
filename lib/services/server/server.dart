import 'package:alfred/alfred.dart';
import 'package:cloud_mining/config/load_env.dart';
import 'package:cloud_mining/controllers/file_upload.dart';
import 'package:cloud_mining/services/routes/index.dart';

class ServerService {
  late Alfred _app;
  Alfred get app => _app;
  static final ServerService _instance = ServerService._init();
  late final Env _env;

  ServerService._init() {
    _env = Env();
    _app = Alfred();

    _setupFileUploadRoutes();

    _setupRoutes();
  }

  factory ServerService() => _instance;

  Future<void> startServer() async {
    await _app.listen(int.parse(_env.envConfig.port), _env.envConfig.host);
  }

  void _setupRoutes() async {
    await IndexRoute.setupRoutes(app);
  }

  void _setupFileUploadRoutes() {
    app.get('/files/*', (req, res) => FileUploadController().uploadDirectory);
  }
}
