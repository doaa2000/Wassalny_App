import '../localization/app_translations.dart';

/// All user-facing copy. Each member is now a locale-aware getter backed by
/// [AppTranslations], so the existing `AppStrings.x` call sites keep working
/// while the value follows the app's current language (en / ar / es).
class AppStrings {
  AppStrings._();

  static String _t(String key) => AppTranslations.get(key);

  static String get appName => _t('appName');
  static String get appVersion => _t('appVersion');

  // Welcome
  static String get welcomeTitle => _t('welcomeTitle');
  static String get welcomeSubtitle => _t('welcomeSubtitle');
  static String get getStarted => _t('getStarted');
  static String get haveAccount => _t('haveAccount');

  // Onboarding
  static String get skip => _t('skip');
  static String get onboardingTitle => _t('onboardingTitle');
  static String get onboardingSubtitle => _t('onboardingSubtitle');
  static String get continueLabel => _t('continueLabel');

  // Location permission
  static String get enableLocationTitle => _t('enableLocationTitle');
  static String get enableLocationSubtitle => _t('enableLocationSubtitle');
  static String get allowLocation => _t('allowLocation');
  static String get enterManually => _t('enterManually');

  // Auth
  static String get welcomeBack => _t('welcomeBack');
  static String get loginSubtitle => _t('loginSubtitle');
  static String get emailOrPhone => _t('emailOrPhone');
  static String get password => _t('password');
  static String get forgotPassword => _t('forgotPassword');
  static String get login => _t('login');
  static String get orContinueWith => _t('orContinueWith');
  static String get google => _t('google');
  static String get apple => _t('apple');
  static String get newToWassalny => _t('newToWassalny');
  static String get createAccount => _t('createAccount');
  static String get signupSubtitle => _t('signupSubtitle');
  static String get fullName => _t('fullName');
  static String get phoneNumber => _t('phoneNumber');
  static String get agreePrefix => _t('agreePrefix');
  static String get termsOfService => _t('termsOfService');
  static String get and => _t('and');
  static String get privacyPolicy => _t('privacyPolicy');
  static String get alreadyHaveAccount => _t('alreadyHaveAccount');

  // OTP
  static String get verifyNumberTitle => _t('verifyNumberTitle');
  static String get verifyNumberSubtitle => _t('verifyNumberSubtitle');
  static String get demoPhone => _t('demoPhone');
  static String get didntGetCode => _t('didntGetCode');
  static String get resendIn => _t('resendIn');
  static String get verify => _t('verify');

  // Forgot
  static String get forgotTitle => _t('forgotTitle');
  static String get forgotSubtitle => _t('forgotSubtitle');
  static String get emailAddress => _t('emailAddress');
  static String get sendResetCode => _t('sendResetCode');
  static String get backToLogin => _t('backToLogin');

  // Home
  static String get currentLocation => _t('currentLocation');
  static String get greeting => _t('greeting');
  static String get whereTo => _t('whereTo');
  static String get whereToShort => _t('whereToShort');
  static String get setOnMap => _t('setOnMap');
  static String get driversNearYou => _t('driversNearYou');
  static String get compareAll => _t('compareAll');

  // Search
  static String get planYourRide => _t('planYourRide');
  static String get recent => _t('recent');
  static String get savedPlaces => _t('savedPlaces');
  static String get findDriver => _t('findDriver');
  static String get setDropoffFirst => _t('setDropoffFirst');

  // Driver select
  static String get chooseDriver => _t('chooseDriver');
  static String get tripRoute => _t('tripRoute');
  static String get arrives => _t('arrives');
  static String get plate => _t('plate');
  static String get estFare => _t('estFare');

  // Confirm
  static String get confirmRide => _t('confirmRide');
  static String get confirmRideAction => _t('confirmRideAction');
  static String get requestRide => _t('requestRide');
  static String get pickup => _t('pickup');
  static String get dropoff => _t('dropoff');
  static String get dropoffPlace => _t('dropoffPlace');
  static String get change => _t('change');
  static String get paymentMethod => _t('paymentMethod');
  static String get fareBreakdown => _t('fareBreakdown');

  // Finding
  static String get findingDriver => _t('findingDriver');
  static String get findingSubtitle => _t('findingSubtitle');
  static String get cancel => _t('cancel');
  static String get noDriversFound => _t('noDriversFound');
  static String get noDriversFoundSubtitle => _t('noDriversFoundSubtitle');
  static String get tryAgain => _t('tryAgain');
  static String get backToSearch => _t('backToSearch');

  // Assigned
  static String get trackYourRide => _t('trackYourRide');
  static String get cancelRide => _t('cancelRide');
  static String get tripInProgress => _t('tripInProgress');
  static String get call => _t('call');
  static String get chat => _t('chat');
  static String get share => _t('share');

  // Tracking
  static String get arrivingIn => _t('arrivingIn');
  static String get arrivingValue => _t('arrivingValue');
  static String get sos => _t('sos');
  static String get completeTripDemo => _t('completeTripDemo');

  // Completed
  static String get arrivedTitle => _t('arrivedTitle');
  static String get arrivedSubtitle => _t('arrivedSubtitle');
  static String get addTip => _t('addTip');
  static String get leaveReview => _t('leaveReview');
  static String get submitDone => _t('submitDone');
  static String get howWasTrip => _t('howWasTrip');

  // Wallet
  static String get wallet => _t('wallet');
  static String get availableBalance => _t('availableBalance');
  static String get balance => _t('balance');
  static String get addFunds => _t('addFunds');
  static String get send => _t('send');
  static String get paymentMethods => _t('paymentMethods');
  static String get addNewCard => _t('addNewCard');
  static String get recentTransactions => _t('recentTransactions');

  // History
  static String get yourRides => _t('yourRides');
  static String get all => _t('all');
  static String get completed => _t('completed');
  static String get cancelled => _t('cancelled');
  static String get rebook => _t('rebook');
  static String get getReceipt => _t('getReceipt');

  // Notifications
  static String get notifications => _t('notifications');
  static String get markAllRead => _t('markAllRead');
  static String get today => _t('today');
  static String get earlier => _t('earlier');

  // Profile
  static String get riderName => _t('riderName');
  static String get personalInfo => _t('personalInfo');
  static String get emailCannotBeChanged => _t('emailCannotBeChanged');
  static String get profileUpdated => _t('profileUpdated');
  static String get couldNotUpdateProfile => _t('couldNotUpdateProfile');
  static String get savedLocations => _t('savedLocations');
  static String get language => _t('language');
  static String get languageValue => _t('languageValue');
  static String get helpSupport => _t('helpSupport');
  static String get rateApp => _t('rateApp');
  static String get aboutUs => _t('aboutUs');
  static String get logout => _t('logout');

  // Bottom nav
  static String get navHome => _t('navHome');
  static String get navRides => _t('navRides');
  static String get navWallet => _t('navWallet');
  static String get navAlerts => _t('navAlerts');
  static String get navProfile => _t('navProfile');

  // Map / pickup
  static String get setPickupHint => _t('setPickupHint');
  static String get pickerHint => _t('pickerHint');
  static String get locating => _t('locating');
  static String get confirm => _t('confirm');
  static String get outsideServiceArea => _t('outsideServiceArea');
  static String get placeHome => _t('placeHome');
  static String get placeWork => _t('placeWork');

  // Confirm extras
  static String get estimatedTotal => _t('estimatedTotal');
  static String get fareNote => _t('fareNote');
  static String get yourOffer => _t('yourOffer');
  static String get suggestedFare => _t('suggestedFare');
  static String get priceTooLow => _t('priceTooLow');
  static String get tapToAddAddress => _t('tapToAddAddress');
  static String get renamePlace => _t('renamePlace');
  static String get save => _t('save');
  static String get couldNotLoadPlaces => _t('couldNotLoadPlaces');
  static String get couldNotAddPlace => _t('couldNotAddPlace');
  static String get couldNotRenamePlace => _t('couldNotRenamePlace');
  static String get couldNotRemovePlace => _t('couldNotRemovePlace');

  // Rate app
  static String get rateTitle => _t('rateTitle');
  static String get ratePrompt => _t('ratePrompt');
  static String get submit => _t('submit');
  static String get rateThanks => _t('rateThanks');

  // About
  static String get aboutDescription => _t('aboutDescription');
  static String get aboutRights => _t('aboutRights');
}
