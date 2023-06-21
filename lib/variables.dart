import 'instances.dart';

class Variables {
  static bool isLoading = false,
      isLoading1 = false,
      notSilentlySigningIn = true,
      isSyncing = false;
  static late bool bioOrLocalAuthIsSupported,
      useBioOrLocalAuth,
      useDetailedView,
      isReorderable;
  static late String dateFormat;
  static late String? parkingEmail;
  static late List<String> tokens;

  static Future<void> initialise() async {
    bioOrLocalAuthIsSupported = await Instances.localAuth.isDeviceSupported();
    useBioOrLocalAuth = Instances.prefs.getBool('useBioOrLocalAuth') ??
        bioOrLocalAuthIsSupported;
    useDetailedView = Instances.prefs.getBool('useDetailedView') ?? false;
    isReorderable = Instances.prefs.getBool('isReorderable') ?? false;
    dateFormat = Instances.prefs.getString('dateFormat') ?? 'dd/MM/yyyy';
    parkingEmail = Instances.prefs.getString('parkingEmail');
    tokens = Instances.prefs.getStringList('tokens') ?? [];
  }
}
