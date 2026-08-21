import 'package:easy_localization/easy_localization.dart';

class AppStrings {
  AppStrings._();

  // Buttons
  static String get login => 'buttons.login'.tr();
  static String get register => 'buttons.register'.tr();
  static String get save => 'buttons.save'.tr();
  static String get cancel => 'buttons.cancel'.tr();
  static String get submit => 'buttons.submit'.tr();
  static String get forgotPassword => 'buttons.forgotPassword'.tr();
  static String get loginGoogle => 'buttons.loginGoogle'.tr();
  static String get loginFacebook => 'buttons.loginFacebook'.tr();
  static String get bookNow => 'buttons.bookNow'.tr();
  static String get viewAll => 'buttons.viewAll'.tr();

  // Errors
  static String get errorUnknown => 'errors.unknown'.tr();
  static String get errorNetwork => 'errors.network'.tr();
  static String get errorServer => 'errors.server'.tr();
  static String get errorUnauthorized => 'errors.unauthorized'.tr();
  static String get errorCancel => 'errors.cancel'.tr();
  static String get errorOccurred => 'errors.occurred'.tr();
  static String get retry => 'errors.retry'.tr();

  // Validation
  static String get requiredField => 'validation.required'.tr();
  static String get invalidEmail => 'validation.invalidEmail'.tr();
  static String get passwordLength => 'validation.passwordLength'.tr();
  static String get passwordMatch => 'validation.passwordMatch'.tr();

  // Messages
  static String get welcome => 'messages.welcome'.tr();
  static String get success => 'messages.success'.tr();
  static String get loginSubtitle => 'messages.loginSubtitle'.tr();
  static String get or => 'messages.or'.tr();
  static String get dontHaveAccount => 'messages.dontHaveAccount'.tr();
  static String get alreadyHaveAccount => 'messages.alreadyHaveAccount'.tr();
  static String get createAccountTitle => 'messages.createAccountTitle'.tr();
  static String get createAccountSubtitle =>
      'messages.createAccountSubtitle'.tr();
  static String get profilePhotoOptional =>
      'messages.profilePhotoOptional'.tr();

  // Labels
  static String get emailLabel => 'labels.email'.tr();
  static String get passwordLabel => 'labels.password'.tr();
  static String get phoneLabel => 'labels.phone'.tr();
  static String get nameLabel => 'labels.name'.tr();
  static String get confirmPasswordLabel => 'labels.confirmPassword'.tr();
  static String get governorateLabel {
    final res = 'labels.governorate'.tr();
    return res == 'labels.governorate' ? 'المحافظة (اختياري)' : res;
  }

  // Hints
  static String get emailHint => 'hints.email'.tr();
  static String get passwordHint => 'hints.password'.tr();
  static String get searchHint => 'hints.search'.tr();
  static String get confirmPasswordHint => 'hints.confirmPassword'.tr();
  static String get phoneHint => 'hints.phone'.tr();
  static String get nameHint => 'hints.name'.tr();
  static String get governorateHint {
    final res = 'hints.governorate'.tr();
    return res == 'hints.governorate' ? 'اختر المحافظة' : res;
  }

  // Splash
  static String get splashTitle => 'splash.title'.tr();
  static String get splashTagline => 'splash.tagline'.tr();
  static String get splashLoading => 'splash.loading'.tr();
  static String get splashVerifyingLogin => 'splash.verifyingLogin'.tr();

  // Home
  static String get homeTitle => 'home.title'.tr();
  static String get homeFeaturedTrip => 'home.featuredTrip'.tr();
  static String get homeCategories => 'home.categories'.tr();
  static String get homePopularDestinations => 'home.popularDestinations'.tr();
  static String get homeDiscountBanner => 'home.discountBanner'.tr();
  static String get homeDiscountSubtitle => 'home.discountSubtitle'.tr();
  static String get homeBeachTrips => 'home.beachTrips'.tr();
  static String get homeHistoricalTrips => 'home.historicalTrips'.tr();
  static String get homeMountainTrips => 'home.mountainTrips'.tr();
  static String get homeSafariTrips => 'home.safariTrips'.tr();
  static String get homeFamilyTrips => 'home.familyTrips'.tr();
  static String get homeCampingTrips => 'home.campingTrips'.tr();
  static String get navHome => 'home.navHome'.tr();
  static String get navNotifications => 'home.navNotifications'.tr();
  static String get navBookings => 'home.navBookings'.tr();
  static String get homeNavFavorites => 'home.navFavorites'.tr();
  static String get homeNavMore => 'home.navMore'.tr();

  // Bookings
  static String get bookingsTitle => 'bookings.title'.tr();
  static String get bookingsFilterAll => 'bookings.filterAll'.tr();
  static String get bookingsFilterAccepted => 'bookings.filterAccepted'.tr();
  static String get bookingsFilterPending => 'bookings.filterPending'.tr();
  static String get bookingsFilterCancelled => 'bookings.filterCancelled'.tr();
  static String get bookingsTotal => 'bookings.total'.tr();
  static String get bookingsDetails => 'bookings.details'.tr();

  // Trip Details
  static String get tripDetailsReviews => 'tripDetails.reviews'.tr();
  static String get tripDetailsGallery => 'tripDetails.gallery'.tr();
  static String get tripDetailsExcluded => 'tripDetails.excluded'.tr();
  static String get tripDetailsIncluded => 'tripDetails.included'.tr();
  static String get tripDetailsOverview => 'tripDetails.overview'.tr();
  static String get tripDetailsItinerary => 'tripDetails.itinerary'.tr();
  static String get tripDetailsDay => 'tripDetails.day'.tr();
  static String get tripDetailsPerPerson => 'tripDetails.perPerson'.tr();
  static String get tripDetailsAvailableSeats =>
      'tripDetails.availableSeats'.tr();
  static String get tripDetailsDays => 'tripDetails.days'.tr();
  static String get tripDetailsTransportIncluded =>
      'tripDetails.transport Included'.tr();
  static String get tripDetailsSaveForLater => 'tripDetails.saveForLater'.tr();

  // Booking Confirmation
  static String get bookingConfirmationTitle =>
      'bookingConfirmation.title'.tr();
  static String get bookingConfirmationNumberOfIndividuals =>
      'bookingConfirmation.numberOfIndividuals'.tr();
  static String get bookingConfirmationPerPerson =>
      'bookingConfirmation.perPerson'.tr();
  static String get bookingConfirmationSpecialNotes =>
      'bookingConfirmation.specialNotes'.tr();
  static String get bookingConfirmationSpecialNotesHint =>
      'bookingConfirmation.specialNotesHint'.tr();
  static String get bookingConfirmationPriceSummary =>
      'bookingConfirmation.priceSummary'.tr();
  static String get bookingConfirmationTripCost =>
      'bookingConfirmation.tripCost'.tr();
  static String get bookingConfirmationDiscount =>
      'bookingConfirmation.discount'.tr();
  static String get bookingConfirmationServiceFee =>
      'bookingConfirmation.serviceFee'.tr();
  static String get bookingConfirmationFinalPrice =>
      'bookingConfirmation.finalPrice'.tr();
  static String get bookingConfirmationConfirmBooking =>
      'bookingConfirmation.confirmBooking'.tr();
  static String get bookingConfirmationBookingPolicyAgree =>
      'bookingConfirmation.bookingPolicyAgree'.tr();
  static String get bookingConfirmationBookingPolicy =>
      'bookingConfirmation.bookingPolicy'.tr();

  // Booking Details
  static String get bookingDetailsTitle => 'bookingDetails.title'.tr();
  static String get bookingDetailsBookingData =>
      'bookingDetails.bookingData'.tr();
  static String get bookingDetailsBookingNumber =>
      'bookingDetails.bookingNumber'.tr();
  static String get bookingDetailsBookingDate =>
      'bookingDetails.bookingDate'.tr();
  static String get bookingDetailsStatus => 'bookingDetails.status'.tr();
  static String get bookingDetailsConfirmed => 'bookingDetails.confirmed'.tr();
  static String get bookingDetailsIndividuals =>
      'bookingDetails.individuals'.tr();
  static String get bookingDetailsAdults => 'bookingDetails.adults'.tr();
  static String get bookingDetailsPaymentMethod =>
      'bookingDetails.paymentMethod'.tr();
  static String get bookingDetailsBankCard => 'bookingDetails.bankCard'.tr();
  static String get bookingDetailsTotalPrice =>
      'bookingDetails.totalPrice'.tr();
  static String get bookingDetailsTripData => 'bookingDetails.tripData'.tr();
  static String get bookingDetailsDestination =>
      'bookingDetails.destination'.tr();
  static String get bookingDetailsTripDates => 'bookingDetails.tripDates'.tr();
  static String get bookingDetailsDuration => 'bookingDetails.duration'.tr();
  static String get bookingDetailsMeetingPoint =>
      'bookingDetails.meetingPoint'.tr();
  static String get bookingDetailsMeetingTime =>
      'bookingDetails.meetingTime'.tr();
  static String get bookingDetailsCancelBooking =>
      'bookingDetails.cancelBooking'.tr();
  static String get bookingDetailsContactUs => 'bookingDetails.contactUs'.tr();

  // Notifications Tab
  static String get notificationsTitle => 'notifications.title'.tr();
  static String get notificationsEmpty => 'notifications.empty'.tr();
  static String get notificationsJustNow => 'notifications.justNow'.tr();
  static String get notificationsHoursAgo => 'notifications.hoursAgo'.tr();
  static String get notificationsBookingConfirmed =>
      'notifications.bookingConfirmed'.tr();
  static String get notificationsBookingConfirmedDesc =>
      'notifications.bookingConfirmedDesc'.tr();
  static String get notificationsNewOffer => 'notifications.newOffer'.tr();
  static String get notificationsNewOfferDesc =>
      'notifications.newOfferDesc'.tr();

  // Favorites Tab
  static String get favoritesTitle => 'favorites.title'.tr();
  static String get favoritesEmpty => 'favorites.empty'.tr();

  // Profile Tab
  static String get profileTitle => 'profile.title'.tr();
  static String get profilePersonalData => 'profile.personalData'.tr();
  static String get profileEditAccount => 'profile.editAccount'.tr();
  static String get profileChangePassword => 'profile.changePassword'.tr();
  static String get profileHelpSupport => 'profile.helpSupport'.tr();
  static String get profileAboutApp => 'profile.aboutApp'.tr();
  static String get profileLogout => 'profile.logout'.tr();
  static String get loginAdmin => 'buttons.loginAdmin'.tr();

  // Admin
  static String get adminDashboardTitle => 'admin.dashboardTitle'.tr();
  static String get adminWelcomeMessage => 'admin.welcomeMessage'.tr();
  static String get adminOverview => 'admin.overview'.tr();
  static String get adminTotalTrips => 'admin.totalTrips'.tr();
  static String get adminTotalBookings => 'admin.totalBookings'.tr();
  static String get adminActiveUsers => 'admin.activeUsers'.tr();
  static String get adminRevenue => 'admin.revenue'.tr();
  static String get adminManageTrips => 'admin.manageTrips'.tr();
  static String get adminManageBookings => 'admin.manageBookings'.tr();
  static String get adminManageUsers => 'admin.manageUsers'.tr();
  static String get adminAnalytics => 'admin.analytics'.tr();
  static String get adminQuickActions => 'admin.quickActions'.tr();
  static String get adminAddTrip => 'admin.addTrip'.tr();
  static String get adminSwitchUserMode => 'admin.switchUserMode'.tr();
  static String get adminTripsTitle => 'admin.tripsTitle'.tr();
  static String get adminFilterPublished => 'admin.filterPublished'.tr();
  static String get adminFilterUnpublished => 'admin.filterUnpublished'.tr();
  static String get adminFilterDraft => 'admin.filterDraft'.tr();
  static String get adminEditTrip => 'admin.editTrip'.tr();
  static String get adminDeleteTrip => 'admin.deleteTrip'.tr();
  static String get adminRepublishTrip => 'admin.republishTrip'.tr();
  static String get adminViewTrip => 'admin.viewTrip'.tr();
  static String get adminAddTripTitle => 'admin.addTripTitle'.tr();
  static String get adminStepBasicInfo => 'admin.stepBasicInfo'.tr();
  static String get adminStepPriceAndDates => 'admin.stepPriceAndDates'.tr();
  static String get adminStepMediaAndServices =>
      'admin.stepMediaAndServices'.tr();
  static String get adminStepItinerary => 'admin.stepItinerary'.tr();
  static String get adminTripTitleLabel => 'admin.tripTitleLabel'.tr();
  static String get adminTripTitleHint => 'admin.tripTitleHint'.tr();
  static String get adminTripDescLabel => 'admin.tripDescLabel'.tr();
  static String get adminTripDescHint => 'admin.tripDescHint'.tr();
  static String get adminOriginLabel => 'admin.originLabel'.tr();
  static String get adminOriginHint => 'admin.originHint'.tr();
  static String get adminDestinationLabel => 'admin.destinationLabel'.tr();
  static String get adminDestinationHint => 'admin.destinationHint'.tr();
  static String get adminPriceLabel => 'admin.priceLabel'.tr();
  static String get adminPriceHint => 'admin.priceHint'.tr();
  static String get adminCapacityLabel => 'admin.capacityLabel'.tr();
  static String get adminCapacityHint => 'admin.capacityHint'.tr();
  static String get adminStartDateLabel => 'admin.startDateLabel'.tr();
  static String get adminEndDateLabel => 'admin.endDateLabel'.tr();
  static String get adminCoverImageLabel => 'admin.coverImageLabel'.tr();
  static String get adminCoverImageHint => 'admin.coverImageHint'.tr();
  static String get adminGalleryLabel => 'admin.galleryLabel'.tr();
  static String get adminGalleryHint => 'admin.galleryHint'.tr();
  static String get adminIncludedLabel => 'admin.includedLabel'.tr();
  static String get adminIncludedHint => 'admin.includedHint'.tr();
  static String get adminExcludedLabel => 'admin.excludedLabel'.tr();
  static String get adminExcludedHint => 'admin.excludedHint'.tr();
  static String get adminCancelPolicyLabel => 'admin.cancelPolicyLabel'.tr();
  static String get adminCancelPolicyHint => 'admin.cancelPolicyHint'.tr();
  static String get adminAddDayButton => 'admin.addDayButton'.tr();
  static String get adminAddActivityButton => 'admin.addActivityButton'.tr();
  static String get adminActivityTitleLabel => 'admin.activityTitleLabel'.tr();
  static String get adminActivityTimeLabel => 'admin.activityTimeLabel'.tr();
  static String get adminActivityLocationLabel =>
      'admin.activityLocationLabel'.tr();
  static String get adminNextStep => 'admin.nextStep'.tr();
  static String get adminPreviousStep => 'admin.previousStep'.tr();
  static String get adminPublishTrip => 'admin.publishTrip'.tr();
  static String get adminSaveDraft => 'admin.saveDraft'.tr();
  static String get adminPickCoverImage => 'admin.pickCoverImage'.tr();
  static String get adminPickGalleryImages => 'admin.pickGalleryImages'.tr();
  static String get adminPickActivityImageOptional =>
      'admin.pickActivityImageOptional'.tr();
  static String get adminAddCustomService => 'admin.addCustomService'.tr();
  static String get adminPresetIncludedServices =>
      'admin.presetIncludedServices'.tr();
  static String get adminPresetExcludedServices =>
      'admin.presetExcludedServices'.tr();
  static String get adminBookingRequestsTitle =>
      'admin.bookingRequestsTitle'.tr();
  static String get adminFilterPending => 'admin.filterPending'.tr();
  static String get adminFilterAccepted => 'admin.filterAccepted'.tr();
  static String get adminFilterRejected => 'admin.filterRejected'.tr();
  static String get adminAcceptRequest => 'admin.acceptRequest'.tr();
  static String get adminRejectRequest => 'admin.rejectRequest'.tr();
  static String get adminAcceptedBanner => 'admin.acceptedBanner'.tr();
  static String get adminRejectedBanner => 'admin.rejectedBanner'.tr();
  static String get adminPassengersCountLabel =>
      'admin.passengersCountLabel'.tr();
  static String get adminTotalAmountLabel => 'admin.totalAmountLabel'.tr();
  static String get adminBookingDetailsTitle =>
      'admin.bookingDetailsTitle'.tr();
  static String get adminCustomerDataSection =>
      'admin.customerDataSection'.tr();
  static String get adminCustomersTitle {
    final res = 'admin.customersTitle'.tr();
    return res == 'admin.customersTitle' ? 'سجل وقائمة العملاء' : res;
  }
  static String get adminCustomersDatabase {
    final res = 'admin.customersDatabase'.tr();
    return res == 'admin.customersDatabase' ? 'قاعدة بيانات العملاء' : res;
  }
  static String get adminCustomersRegistered {
    final res = 'admin.customersRegistered'.tr();
    return res == 'admin.customersRegistered' ? 'عميل مسجل' : res;
  }
  static String get adminCustomersTotalSales {
    final res = 'admin.customersTotalSales'.tr();
    return res == 'admin.customersTotalSales' ? 'إجمالي مبيعات العملاء المعروضين:' : res;
  }
  static String get adminCustomersSearchHint {
    final res = 'admin.customersSearchHint'.tr();
    return res == 'admin.customersSearchHint'
        ? 'بحث باسم العميل، البريد، أو رقم الهاتف...'
        : res;
  }
  static String get adminCustomersClearSearch {
    final res = 'admin.customersClearSearch'.tr();
    return res == 'admin.customersClearSearch' ? 'مسح البحث' : res;
  }
  static String get adminCustomersNoResults {
    final res = 'admin.customersNoResults'.tr();
    return res == 'admin.customersNoResults'
        ? 'لم يتم العثور على أي عملاء مطبقين للبحث'
        : res;
  }
  static String get adminTripDataSection => 'admin.tripDataSection'.tr();
  static String get adminBookingDetailsSection =>
      'admin.bookingDetailsSection'.tr();
  static String get adminCustomerNotesSection =>
      'admin.customerNotesSection'.tr();
  static String get adminBookingNumberLabel => 'admin.bookingNumberLabel'.tr();
  static String get adminRequestDateLabel => 'admin.requestDateLabel'.tr();
  static String get adminPaymentMethodLabel => 'admin.paymentMethodLabel'.tr();
  static String get adminCancelBooking => 'admin.cancelBooking'.tr();
  static String get adminContactCustomer => 'admin.contactCustomer'.tr();
  static String get adminBookingAcceptedTitle =>
      'admin.bookingAcceptedTitle'.tr();
  static String get adminBookingAcceptedDesc =>
      'admin.bookingAcceptedDesc'.tr();
  static String get adminBookingRejectedTitle =>
      'admin.bookingRejectedTitle'.tr();
  static String get adminBookingRejectedDesc =>
      'admin.bookingRejectedDesc'.tr();
  static String get adminCompanyTools {
    final res = 'admin.companyTools'.tr();
    return res == 'admin.companyTools' ? 'أدوات وإدارة الشركة' : res;
  }
  static String get adminBookingPendingTitle =>
      'admin.bookingPendingTitle'.tr();
  static String get adminBookingPendingDesc => 'admin.bookingPendingDesc'.tr();
  static String get adminDefaultCustomerName {
    final res = 'admin.defaultCustomerName'.tr();
    return res == 'admin.defaultCustomerName' ? 'عميل' : res;
  }
  static String get adminDefaultTripTitle {
    final res = 'admin.defaultTripTitle'.tr();
    return res == 'admin.defaultTripTitle' ? 'رحلة' : res;
  }
  static String get adminDefaultDuration {
    final res = 'admin.defaultDuration'.tr();
    return res == 'admin.defaultDuration' ? 'حسب البرنامج' : res;
  }
  static String get adminDefaultToday {
    final res = 'admin.defaultToday'.tr();
    return res == 'admin.defaultToday' ? 'اليوم' : res;
  }
  static String get adminDefaultBookingNumberPrefix {
    final res = 'admin.defaultBookingNumberPrefix'.tr();
    return res == 'admin.defaultBookingNumberPrefix' ? '#TRP-' : res;
  }
  static String get adminDefaultBankCard {
    final res = 'admin.defaultBankCard'.tr();
    return res == 'admin.defaultBankCard' ? 'بطاقة بنكية' : res;
  }
  static String get adminNoCustomerNotes {
    final res = 'admin.noCustomerNotes'.tr();
    return res == 'admin.noCustomerNotes' ? 'لا توجد ملاحظات إضافية من العميل.' : res;
  }
  static String get adminNoBookingsFound {
    final res = 'admin.noBookingsFound'.tr();
    return res == 'admin.noBookingsFound' ? 'لا توجد طلبات حجز حالياً' : res;
  }
  static String get adminFilterByTripHeader {
    final res = 'admin.filterByTripHeader'.tr();
    return res == 'admin.filterByTripHeader' ? 'تصفية حسب الرحلة:' : res;
  }
  static String get adminRejectDialogTitle {
    final res = 'admin.rejectDialogTitle'.tr();
    return res == 'admin.rejectDialogTitle' ? 'رفض طلب الحجز' : res;
  }
  static String get adminRejectDialogSubtitle {
    final res = 'admin.rejectDialogSubtitle'.tr();
    return res == 'admin.rejectDialogSubtitle' ? 'يرجى كتابة سبب رفض الطلب للتوضيح للعميل:' : res;
  }
  static String get adminRejectDialogHint {
    final res = 'admin.rejectDialogHint'.tr();
    return res == 'admin.rejectDialogHint' ? 'مثال: عذراً، اكتمل عدد المقاعد المتاحة لهذه الرحلة' : res;
  }
  static String get adminRejectDialogConfirm {
    final res = 'admin.rejectDialogConfirm'.tr();
    return res == 'admin.rejectDialogConfirm' ? 'تأكيد الرفض' : res;
  }
  static String get adminContactInAppChat {
    final res = 'admin.contactInAppChat'.tr();
    return res == 'admin.contactInAppChat' ? 'محادثة شات داخل التطبيق' : res;
  }
  static String get adminContactInAppChatSubtitle {
    final res = 'admin.contactInAppChatSubtitle'.tr();
    return res == 'admin.contactInAppChatSubtitle' ? 'فتح غرفة المحادثة والرسائل الخاصة بالحجز' : res;
  }
  static String get adminContactWhatsApp {
    final res = 'admin.contactWhatsApp'.tr();
    return res == 'admin.contactWhatsApp' ? 'تواصل عبر WhatsApp' : res;
  }
  static String adminContactWhatsAppMessage(String name) {
    return 'أهلاً بك أستاذ $name، نتواصل معك بخصوص طلب حجزك في تطبيق فسحة.';
  }
  static String get adminContactPhoneCall {
    final res = 'admin.contactPhoneCall'.tr();
    return res == 'admin.contactPhoneCall' ? 'إجراء اتصال هاتفي' : res;
  }
  static String get adminChatOpenError {
    final res = 'admin.chatOpenError'.tr();
    return res == 'admin.chatOpenError' ? 'تعذر فتح المحادثة' : res;
  }
  static String get adminStatusUpdateSuccessApprove {
    final res = 'admin.statusUpdateSuccessApprove'.tr();
    return res == 'admin.statusUpdateSuccessApprove' ? 'تم قبول طلب الحجز بنجاح' : res;
  }
  static String get adminStatusUpdateSuccessReject {
    final res = 'admin.statusUpdateSuccessReject'.tr();
    return res == 'admin.statusUpdateSuccessReject' ? 'تم رفض طلب الحجز' : res;
  }
  static String get adminPersonUnit {
    final res = 'admin.personUnit'.tr();
    return res == 'admin.personUnit' ? 'شخص' : res;
  }
  static String get adminCurrencyEGP {
    final res = 'admin.currencyEGP'.tr();
    return res == 'admin.currencyEGP' ? 'ج.م' : res;
  }

  // General & Missing
  static String get currencyEGP => 'currencyEGP'.tr();
  static String get tripDetailsPriceFrom => 'tripDetails.priceFrom'.tr();
  static String get settingsTitle => 'settingsTitle'.tr();
  static String get adminFilterAllTrips => 'admin.filterAllTrips'.tr();
  static String get adminPendingBookings => 'admin.pendingBookings'.tr();
  static String get adminTotalRevenue => 'admin.totalRevenue'.tr();
  static String get bookingsViewDetails => 'bookings.viewDetails'.tr();
  static String get adminEditTripTitle => 'admin.editTripTitle'.tr();
  static String get adminDeleteTripConfirmTitle =>
      'admin.deleteTripConfirmTitle'.tr();
  static String get adminDeleteTripConfirmDesc =>
      'admin.deleteTripConfirmDesc'.tr();
  static String get adminRepublishTripConfirmTitle =>
      'admin.republishTripConfirmTitle'.tr();
  static String get adminRepublishTripConfirmDesc =>
      'admin.republishTripConfirmDesc'.tr();
  static String get adminTripCreatedSuccess => 'admin.tripCreatedSuccess'.tr();
  static String get adminTripUpdatedSuccess => 'admin.tripUpdatedSuccess'.tr();
  static String get adminTripDeletedSuccess => 'admin.tripDeletedSuccess'.tr();
  static String get adminTripRepublishedSuccess =>
      'admin.tripRepublishedSuccess'.tr();
  static String get adminSelectCity => 'admin.selectCity'.tr();
  static String get adminCustomCityHint => 'admin.customCityHint'.tr();
  static String get confirm => 'confirm'.tr();

  // Company Profile
  static String get companyProfileEditTitle {
    final res = 'admin.companyProfileEditTitle'.tr();
    return res == 'admin.companyProfileEditTitle' ? 'تعديل ملف الشركة' : res;
  }
  static String get companyProfileHeaderTitle {
    final res = 'admin.companyProfileHeaderTitle'.tr();
    return res == 'admin.companyProfileHeaderTitle' ? 'إعدادات حساب الشركة' : res;
  }
  static String get companyProfileHeaderSubtitle {
    final res = 'admin.companyProfileHeaderSubtitle'.tr();
    return res == 'admin.companyProfileHeaderSubtitle'
        ? 'قم بتحديث معلومات التواصل والعنوان لظهورها للعملاء'
        : res;
  }
  static String get companyProfileIdNotFound {
    final res = 'admin.companyProfileIdNotFound'.tr();
    return res == 'admin.companyProfileIdNotFound'
        ? 'لم يتم العثور على معرف الشركة الحالي'
        : res;
  }
  static String get companyProfileFetchError {
    final res = 'admin.companyProfileFetchError'.tr();
    return res == 'admin.companyProfileFetchError'
        ? 'فشل في جلب بيانات الشركة'
        : res;
  }
  static String get companyProfileUpdateSuccess {
    final res = 'admin.companyProfileUpdateSuccess'.tr();
    return res == 'admin.companyProfileUpdateSuccess'
        ? 'تم تحديث بيانات الشركة بنجاح'
        : res;
  }
  static String get companyProfileUpdateError {
    final res = 'admin.companyProfileUpdateError'.tr();
    return res == 'admin.companyProfileUpdateError'
        ? 'فشل في تحديث بيانات الشركة'
        : res;
  }
  static String get companyProfileInvalidResponse {
    final res = 'admin.companyProfileInvalidResponse'.tr();
    return res == 'admin.companyProfileInvalidResponse'
        ? 'نطاق الاستجابة غير صحيح'
        : res;
  }
  static String get companyNameLabel {
    final res = 'admin.companyNameLabel'.tr();
    return res == 'admin.companyNameLabel' ? 'اسم الشركة' : res;
  }
  static String get companyNameHint {
    final res = 'admin.companyNameHint'.tr();
    return res == 'admin.companyNameHint' ? 'مثال: شركة فسحني شكرا للسياحة' : res;
  }
  static String get companyNameRequired {
    final res = 'admin.companyNameRequired'.tr();
    return res == 'admin.companyNameRequired' ? 'يرجى إدخال اسم الشركة' : res;
  }
  static String get companyDescLabel {
    final res = 'admin.companyDescLabel'.tr();
    return res == 'admin.companyDescLabel' ? 'وصف الشركة' : res;
  }
  static String get companyDescHint {
    final res = 'admin.companyDescHint'.tr();
    return res == 'admin.companyDescHint' ? 'وصف ورؤية الشركة ورحلاتها...' : res;
  }
  static String get companyPhoneLabel {
    final res = 'admin.companyPhoneLabel'.tr();
    return res == 'admin.companyPhoneLabel' ? 'هاتف التواصل' : res;
  }
  static String get companyPhoneRequired {
    final res = 'admin.companyPhoneRequired'.tr();
    return res == 'admin.companyPhoneRequired' ? 'يرجى إدخال رقم الهاتف' : res;
  }
  static String get companyEmailLabel {
    final res = 'admin.companyEmailLabel'.tr();
    return res == 'admin.companyEmailLabel' ? 'البريد الإلكتروني للتواصل' : res;
  }
  static String get companyEmailRequired {
    final res = 'admin.companyEmailRequired'.tr();
    return res == 'admin.companyEmailRequired'
        ? 'يرجى إدخال البريد الإلكتروني'
        : res;
  }
  static String get companyEmailInvalid {
    final res = 'admin.companyEmailInvalid'.tr();
    return res == 'admin.companyEmailInvalid' ? 'البريد الإلكتروني غير صحيح' : res;
  }
  static String get companyAddressLabel {
    final res = 'admin.companyAddressLabel'.tr();
    return res == 'admin.companyAddressLabel' ? 'العنوان التفصيلي' : res;
  }
  static String get companyAddressHint {
    final res = 'admin.companyAddressHint'.tr();
    return res == 'admin.companyAddressHint' ? 'المنيا - كورنيش النيل' : res;
  }
  static String get companyGovernorateLabel {
    final res = 'admin.companyGovernorateLabel'.tr();
    return res == 'admin.companyGovernorateLabel' ? 'المحافظة' : res;
  }
  static String get saveChanges {
    final res = 'buttons.saveChanges'.tr();
    return res == 'buttons.saveChanges' ? 'حفظ التغييرات' : res;
  }
  static String get savingChanges {
    final res = 'buttons.savingChanges'.tr();
    return res == 'buttons.savingChanges' ? 'جاري الحفظ...' : res;
  }

  // Company Coupons
  static String get companyCouponsTitle {
    final res = 'admin.companyCouponsTitle'.tr();
    return res == 'admin.companyCouponsTitle' ? 'كوبونات الخصم للشركة' : res;
  }
  static String get newCoupon {
    final res = 'admin.newCoupon'.tr();
    return res == 'admin.newCoupon' ? 'كوبون جديد' : res;
  }
  static String get addCouponTitle {
    final res = 'admin.addCouponTitle'.tr();
    return res == 'admin.addCouponTitle' ? 'إضافة كوبون خصم جديد' : res;
  }
  static String get couponCodeLabel {
    final res = 'admin.couponCodeLabel'.tr();
    return res == 'admin.couponCodeLabel' ? 'كود الكوبون' : res;
  }
  static String get couponCodeHint {
    final res = 'admin.couponCodeHint'.tr();
    return res == 'admin.couponCodeHint' ? 'مثال: COMPANY20' : res;
  }
  static String get couponCodeRequired {
    final res = 'admin.couponCodeRequired'.tr();
    return res == 'admin.couponCodeRequired' ? 'يرجى إدخال كود الكوبون' : res;
  }
  static String get couponCodeMinLength {
    final res = 'admin.couponCodeMinLength'.tr();
    return res == 'admin.couponCodeMinLength'
        ? 'الكود يجب أن يتكون من 3 أحرف على الأقل'
        : res;
  }
  static String get discountPercentageLabel {
    final res = 'admin.discountPercentageLabel'.tr();
    return res == 'admin.discountPercentageLabel' ? 'نسبة الخصم %' : res;
  }
  static String get discountPercentageRequired {
    final res = 'admin.discountPercentageRequired'.tr();
    return res == 'admin.discountPercentageRequired' ? 'نسبة الخصم مطلوبة' : res;
  }
  static String get discountPercentageInvalid {
    final res = 'admin.discountPercentageInvalid'.tr();
    return res == 'admin.discountPercentageInvalid' ? 'نسبة بين 1 و 100' : res;
  }
  static String get usageLimitLabel {
    final res = 'admin.usageLimitLabel'.tr();
    return res == 'admin.usageLimitLabel'
        ? 'حد الاستخدام (0 = غير محدود)'
        : res;
  }
  static String get maxDiscountLabel {
    final res = 'admin.maxDiscountLabel'.tr();
    return res == 'admin.maxDiscountLabel'
        ? 'أقصى مبلغ خصم (0 = بدون حد)'
        : res;
  }
  static String get minTripPriceLabel {
    final res = 'admin.minTripPriceLabel'.tr();
    return res == 'admin.minTripPriceLabel'
        ? 'أقل سعر للرحلة (0 = الكل)'
        : res;
  }
  static String get validUntilLabel {
    final res = 'admin.validUntilLabel'.tr();
    return res == 'admin.validUntilLabel' ? 'صالح حتى' : res;
  }
  static String get deleteCoupon {
    final res = 'admin.deleteCoupon'.tr();
    return res == 'admin.deleteCoupon' ? 'حذف الكوبون' : res;
  }
  static String get deleteCouponConfirm {
    final res = 'admin.deleteCouponConfirm'.tr();
    return res == 'admin.deleteCouponConfirm'
        ? 'هل أنت تأكد من رغبتك في حذف الكوبون'
        : res;
  }
  static String get noCouponsFound {
    final res = 'admin.noCouponsFound'.tr();
    return res == 'admin.noCouponsFound' ? 'لا توجد كوبونات خصم حالية' : res;
  }
  static String get noCouponsSubtitle {
    final res = 'admin.noCouponsSubtitle'.tr();
    return res == 'admin.noCouponsSubtitle'
        ? 'قم بإضافة كوبونات خصم لترويج رحلات شركتك'
        : res;
  }
  static String get couponCreatedSuccess {
    final res = 'admin.couponCreatedSuccess'.tr();
    return res == 'admin.couponCreatedSuccess' ? 'تم إضافة الكوبون بنجاح' : res;
  }
  static String get couponDeletedSuccess {
    final res = 'admin.couponDeletedSuccess'.tr();
    return res == 'admin.couponDeletedSuccess' ? 'تم حذف الكوبون بنجاح' : res;
  }
  static String get copiedToClipboard {
    final res = 'admin.copiedToClipboard'.tr();
    return res == 'admin.copiedToClipboard' ? 'تم نسخ الكود' : res;
  }

  // Dashboard & Navigation
  static String get welcomeBack {
    final res = 'admin.welcomeBack'.tr();
    return res == 'admin.welcomeBack' ? 'أهلاً بك 👋' : res;
  }
  static String get companyPerformanceSummary {
    final res = 'admin.companyPerformanceSummary'.tr();
    return res == 'admin.companyPerformanceSummary'
        ? 'إليك ملخص أداء شركتك'
        : res;
  }
  static String get marketingAndOffers {
    final res = 'admin.marketingAndOffers'.tr();
    return res == 'admin.marketingAndOffers' ? 'التسويق والعروض' : res;
  }
  static String get promotionalOffers {
    final res = 'admin.promotionalOffers'.tr();
    return res == 'admin.promotionalOffers' ? 'العروض الترويجية' : res;
  }
  static String get managePromotionsSubtitle {
    final res = 'admin.managePromotionsSubtitle'.tr();
    return res == 'admin.managePromotionsSubtitle'
        ? 'إدارة وتخصيص الخصومات'
        : res;
  }
  static String get discountCoupons {
    final res = 'admin.discountCoupons'.tr();
    return res == 'admin.discountCoupons' ? 'كوبونات الخصم' : res;
  }
  static String get companyCouponsSubtitle {
    final res = 'admin.companyCouponsSubtitle'.tr();
    return res == 'admin.companyCouponsSubtitle'
        ? 'أكواد الخصم الخاصة بالشركة'
        : res;
  }
  static String get logoutConfirmTitle {
    final res = 'admin.logoutConfirmTitle'.tr();
    return res == 'admin.logoutConfirmTitle' ? 'تسجيل الخروج' : res;
  }
  static String get logoutConfirmMessage {
    final res = 'admin.logoutConfirmMessage'.tr();
    return res == 'admin.logoutConfirmMessage'
        ? 'هل أنت تأكد من رغبتك في تسجيل الخروج؟'
        : res;
  }
  static String get logoutSuccessMessage {
    final res = 'admin.logoutSuccessMessage'.tr();
    return res == 'admin.logoutSuccessMessage' ? 'تم تسجيل الخروج بنجاح' : res;
  }

  // Manage Trips & Itinerary
  static String get tripTitleRequired {
    final res = 'admin.tripTitleRequired'.tr();
    return res == 'admin.tripTitleRequired' ? 'برجاء كتابة عنوان الرحلة' : res;
  }
  static String get tripCategoryLabel {
    final res = 'admin.tripCategoryLabel'.tr();
    return res == 'admin.tripCategoryLabel' ? 'تصنيف الرحلة' : res;
  }
  static String get dayTitleLabel {
    final res = 'admin.dayTitleLabel'.tr();
    return res == 'admin.dayTitleLabel' ? 'عنوان اليوم' : res;
  }
  static String get dayTitleHint {
    final res = 'admin.dayTitleHint'.tr();
    return res == 'admin.dayTitleHint' ? 'مثال: الوصول والتسكين بالفندق' : res;
  }
  static String get activitiesLabel {
    final res = 'admin.activitiesLabel'.tr();
    return res == 'admin.activitiesLabel' ? 'الأنشطة:' : res;
  }
  static String get adminTripDeleteFailed {
    final res = 'admin.tripDeleteFailed'.tr();
    return res == 'admin.tripDeleteFailed' ? 'فشل حذف الرحلة' : res;
  }
  static String get adminTripRepublishFailed {
    final res = 'admin.tripRepublishFailed'.tr();
    return res == 'admin.tripRepublishFailed' ? 'فشل نشر الرحلة' : res;
  }

  // Company Offers
  static String get companyOffersTitle {
    final res = 'admin.companyOffersTitle'.tr();
    return res == 'admin.companyOffersTitle' ? 'عروض الشركة الترويجية' : res;
  }
  static String get newOffer {
    final res = 'admin.newOffer'.tr();
    return res == 'admin.newOffer' ? 'عرض جديد' : res;
  }
  static String get editOfferTitle {
    final res = 'admin.editOfferTitle'.tr();
    return res == 'admin.editOfferTitle' ? 'تعديل العرض الترويجي' : res;
  }
  static String get addOfferTitle {
    final res = 'admin.addOfferTitle'.tr();
    return res == 'admin.addOfferTitle' ? 'إضافة عرض ترويجي جديد' : res;
  }
  static String get changeOfferImage {
    final res = 'admin.changeOfferImage'.tr();
    return res == 'admin.changeOfferImage' ? 'تغيير صورة العرض' : res;
  }
  static String get selectOfferImage {
    final res = 'admin.selectOfferImage'.tr();
    return res == 'admin.selectOfferImage' ? 'اختر صورة العرض (مطلوب)' : res;
  }
  static String get titleArLabel {
    final res = 'admin.titleArLabel'.tr();
    return res == 'admin.titleArLabel' ? 'العنوان بالعربية *' : res;
  }
  static String get titleEnLabel {
    final res = 'admin.titleEnLabel'.tr();
    return res == 'admin.titleEnLabel' ? 'Title (EN) *' : res;
  }
  static String get descArLabel {
    final res = 'admin.descArLabel'.tr();
    return res == 'admin.descArLabel' ? 'الوصف بالعربية' : res;
  }
  static String get promoCodeLabel {
    final res = 'admin.promoCodeLabel'.tr();
    return res == 'admin.promoCodeLabel'
        ? 'كود الخصم (مثال: SUMMER20)'
        : res;
  }
  static String get selectEndDateOptional {
    final res = 'admin.selectEndDateOptional'.tr();
    return res == 'admin.selectEndDateOptional'
        ? 'تحديد تاريخ انتهاء العرض (اختياري)'
        : res;
  }
  static String get endDateLabel {
    final res = 'admin.endDateLabel'.tr();
    return res == 'admin.endDateLabel' ? 'تاريخ الانتهاء' : res;
  }
  static String get selectOfferImageRequired {
    final res = 'admin.selectOfferImageRequired'.tr();
    return res == 'admin.selectOfferImageRequired'
        ? 'يرجى اختيار صورة للعرض الترويجي'
        : res;
  }
  static String get deleteOffer {
    final res = 'admin.deleteOffer'.tr();
    return res == 'admin.deleteOffer' ? 'حذف العرض' : res;
  }
  static String get deleteOfferConfirm {
    final res = 'admin.deleteOfferConfirm'.tr();
    return res == 'admin.deleteOfferConfirm'
        ? 'هل أنت تأكد من رغبتك في حذف العرض'
        : res;
  }
  static String get noOffersFound {
    final res = 'admin.noOffersFound'.tr();
    return res == 'admin.noOffersFound' ? 'لا توجد عروض ترويجية حالية' : res;
  }
  static String get noOffersSubtitle {
    final res = 'admin.noOffersSubtitle'.tr();
    return res == 'admin.noOffersSubtitle'
        ? 'يمكنك إضافة عروض ترويجية وتخفيضات لجذب عملاء جدد'
        : res;
  }
  static String get validity {
    final res = 'admin.validity'.tr();
    return res == 'admin.validity' ? 'الصلاحية' : res;
  }
  static String get unrestricted {
    final res = 'admin.unrestricted'.tr();
    return res == 'admin.unrestricted' ? 'غير مقتصر' : res;
  }
  static String get noTripsFound {
    final res = 'admin.noTripsFound'.tr();
    return res == 'admin.noTripsFound' ? 'لا توجد رحلات حالية' : res;
  }

  // Search Page
  static String get searchTripsTitle {
    final res = 'search.title'.tr();
    return res == 'search.title' ? 'بحث عن رحلات' : res;
  }
  static String get tabTrips {
    final res = 'search.tabTrips'.tr();
    return res == 'search.tabTrips' ? 'رحلات' : res;
  }
  static String get tabCompanies {
    final res = 'search.tabCompanies'.tr();
    return res == 'search.tabCompanies' ? 'شركات' : res;
  }
  static String get tabDestinations {
    final res = 'search.tabDestinations'.tr();
    return res == 'search.tabDestinations' ? 'وجهات' : res;
  }
  static String get selectGovernorateHint {
    final res = 'search.selectGovernorateHint'.tr();
    return res == 'search.selectGovernorateHint' ? 'اختر المحافظة' : res;
  }
  static String get selectDestinationHint {
    final res = 'search.selectDestinationHint'.tr();
    return res == 'search.selectDestinationHint'
        ? 'اختر الوجهة أو اكتب للبحث'
        : res;
  }
  static String get tripTypeLabel {
    final res = 'search.tripTypeLabel'.tr();
    return res == 'search.tripTypeLabel' ? 'النوع' : res;
  }
  static String get showResults {
    final res = 'search.showResults'.tr();
    return res == 'search.showResults' ? 'عرض النتائج' : res;
  }
  static String get clearAllFilters {
    final res = 'search.clearAllFilters'.tr();
    return res == 'search.clearAllFilters' ? 'مسح جميع الفلاتر' : res;
  }
}
