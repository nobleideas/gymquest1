class HomeController {
  Future<String> loadWelcomeMessage() async {
    
    // This would normally call a model/service
    await Future.delayed(Duration(seconds: 1));
    return "Welcome to Gym Quest at 24 Hr Fitness!";
  }
}
