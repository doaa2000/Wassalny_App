/// All user-facing copy, kept in one place so the UI layer stays free of
/// hard-coded literals and future localization is straightforward.
class AppStrings {
  AppStrings._();

  static const String appName = 'Wassalny';
  static const String appVersion = 'Wassalny · v1.0.0';

  // Welcome
  static const String welcomeTitle = 'Your ride,\none tap away.';
  static const String welcomeSubtitle =
      'Compare nearby drivers, see real prices, and book the perfect ride across Cairo in seconds.';
  static const String getStarted = 'Get started';
  static const String haveAccount = 'I already have an account';

  // Onboarding
  static const String skip = 'Skip';
  static const String onboardingTitle = 'Compare drivers,\npick your perfect ride.';
  static const String onboardingSubtitle =
      'See real ratings, arrival times and prices side by side — then book in a single tap.';
  static const String continueLabel = 'Continue';

  // Location permission
  static const String enableLocationTitle = 'Enable your location';
  static const String enableLocationSubtitle =
      'We use your location to find nearby drivers and set your pickup point accurately across Cairo.';
  static const String allowLocation = 'Allow location access';
  static const String enterManually = 'Enter location manually';

  // Auth
  static const String welcomeBack = 'Welcome back';
  static const String loginSubtitle = 'Log in to book your next ride.';
  static const String emailOrPhone = 'Email or phone';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot password?';
  static const String login = 'Log in';
  static const String orContinueWith = 'or continue with';
  static const String google = 'Google';
  static const String apple = 'Apple';
  static const String newToWassalny = 'New to Wassalny? ';
  static const String createAccount = 'Create account';
  static const String signupSubtitle = 'Join Wassalny in under a minute.';
  static const String fullName = 'Full name';
  static const String phoneNumber = 'Phone number';
  static const String agreePrefix = "I agree to Wassalny's ";
  static const String termsOfService = 'Terms of Service';
  static const String and = ' and ';
  static const String privacyPolicy = 'Privacy Policy';
  static const String alreadyHaveAccount = 'Already have an account? ';

  // OTP
  static const String verifyNumberTitle = 'Verify your number';
  static const String verifyNumberSubtitle = 'Enter the 4-digit code we sent to';
  static const String demoPhone = '+20 100 234 5678';
  static const String didntGetCode = "Didn't get a code? ";
  static const String resendIn = 'Resend in 0:28';
  static const String verify = 'Verify';

  // Forgot
  static const String forgotTitle = 'Forgot password?';
  static const String forgotSubtitle =
      "No worries. Enter your email and we'll send you a reset code.";
  static const String emailAddress = 'Email address';
  static const String sendResetCode = 'Send reset code';
  static const String backToLogin = 'Back to login';

  // Home
  static const String currentLocation = 'Tahrir Square, Cairo';
  static const String greeting = 'Good evening, Layla';
  static const String whereTo = 'Where would you like to go?';
  static const String whereToShort = 'Where to?';
  static const String setOnMap = 'Set on map';
  static const String driversNearYou = 'Drivers near you';
  static const String compareAll = 'Compare all';

  // Search
  static const String planYourRide = 'Plan your ride';
  static const String recent = 'Recent';
  static const String savedPlaces = 'Saved places';

  // Driver select
  static const String chooseDriver = 'Choose your driver';
  static const String tripRoute = 'Tahrir Square → Cairo Festival City';
  static const String arrives = 'Arrives';
  static const String plate = 'Plate';
  static const String estFare = 'Est. fare';

  // Confirm
  static const String confirmRide = 'Confirm your ride';
  static const String confirmRideAction = 'Confirm ride';
  static const String pickup = 'PICKUP';
  static const String dropoff = 'DROP-OFF';
  static const String dropoffPlace = 'Cairo Festival City';
  static const String change = 'Change';
  static const String paymentMethod = 'Payment method';
  static const String fareBreakdown = 'Fare breakdown';

  // Finding
  static const String findingDriver = 'Finding your driver';
  static const String findingSubtitle =
      'Matching you with the best nearby driver\nfor your trip to Cairo Festival City';
  static const String cancel = 'Cancel';

  // Assigned
  static const String trackYourRide = 'Track your ride';
  static const String cancelRide = 'Cancel ride';
  static const String call = 'Call';
  static const String chat = 'Chat';
  static const String share = 'Share';

  // Tracking
  static const String arrivingIn = 'Arriving in';
  static const String arrivingValue = '11 min · 6.4 km';
  static const String sos = 'SOS';
  static const String completeTripDemo = 'Complete trip (demo)';

  // Completed
  static const String arrivedTitle = "You've arrived!";
  static const String arrivedSubtitle = 'Hope you enjoyed your ride with Ahmed.';
  static const String addTip = 'Add a tip';
  static const String leaveReview = 'Leave a review (optional)';
  static const String submitDone = 'Submit & done';
  static const String howWasTrip = 'How was your trip?';

  // Wallet
  static const String wallet = 'Wallet';
  static const String availableBalance = 'Available balance';
  static const String balance = 'EGP 340.00';
  static const String addFunds = 'Add funds';
  static const String send = 'Send';
  static const String paymentMethods = 'Payment methods';
  static const String addNewCard = 'Add a new card';
  static const String recentTransactions = 'Recent transactions';

  // History
  static const String yourRides = 'Your rides';
  static const String all = 'All';
  static const String completed = 'Completed';
  static const String cancelled = 'Cancelled';
  static const String rebook = 'Rebook';
  static const String getReceipt = 'Get receipt';

  // Notifications
  static const String notifications = 'Notifications';
  static const String markAllRead = 'Mark all read';
  static const String today = 'Today';
  static const String earlier = 'Earlier';

  // Profile
  static const String riderName = 'Layla Mansour';
  static const String riderPhone = '+20 100 234 5678';
  static const String riderTag = '4.9 · Rider';
  static const String personalInfo = 'Personal information';
  static const String savedLocations = 'Saved locations';
  static const String language = 'Language';
  static const String languageValue = 'English';
  static const String helpSupport = 'Help & support';
  static const String logout = 'Log out';

  // Bottom nav
  static const String navHome = 'Home';
  static const String navRides = 'Rides';
  static const String navWallet = 'Wallet';
  static const String navAlerts = 'Alerts';
  static const String navProfile = 'Profile';
}
