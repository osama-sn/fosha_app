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
    return res == 'admin.customersTotalSales'
        ? 'إجمالي مبيعات العملاء المعروضين:'
        : res;
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
    return res == 'admin.noCustomerNotes'
        ? 'لا توجد ملاحظات إضافية من العميل.'
        : res;
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
    return res == 'admin.rejectDialogSubtitle'
        ? 'يرجى كتابة سبب رفض الطلب للتوضيح للعميل:'
        : res;
  }

  static String get adminRejectDialogHint {
    final res = 'admin.rejectDialogHint'.tr();
    return res == 'admin.rejectDialogHint'
        ? 'مثال: عذراً، اكتمل عدد المقاعد المتاحة لهذه الرحلة'
        : res;
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
    return res == 'admin.contactInAppChatSubtitle'
        ? 'فتح غرفة المحادثة والرسائل الخاصة بالحجز'
        : res;
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
    return res == 'admin.statusUpdateSuccessApprove'
        ? 'تم قبول طلب الحجز بنجاح'
        : res;
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
    return res == 'admin.companyProfileHeaderTitle'
        ? 'إعدادات حساب الشركة'
        : res;
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
    return res == 'admin.companyNameHint'
        ? 'مثال: شركة فسحني شكرا للسياحة'
        : res;
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
    return res == 'admin.companyDescHint'
        ? 'وصف ورؤية الشركة ورحلاتها...'
        : res;
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
    return res == 'admin.companyEmailInvalid'
        ? 'البريد الإلكتروني غير صحيح'
        : res;
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
    return res == 'admin.discountPercentageRequired'
        ? 'نسبة الخصم مطلوبة'
        : res;
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
    return res == 'admin.minTripPriceLabel' ? 'أقل سعر للرحلة (0 = الكل)' : res;
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
    return res == 'admin.promoCodeLabel' ? 'كود الخصم (مثال: SUMMER20)' : res;
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

  // Admin Expenses
  static String get adminExpensesTitle {
    final res = 'admin.expensesTitle'.tr();
    return res == 'admin.expensesTitle' ? 'إدارة المصروفات' : res;
  }

  static String get adminAddExpense {
    final res = 'admin.addExpense'.tr();
    return res == 'admin.addExpense' ? 'إضافة مصروف' : res;
  }

  static String get adminTotalExpenses {
    final res = 'admin.totalExpenses'.tr();
    return res == 'admin.totalExpenses' ? 'إجمالي المصروفات' : res;
  }

  static String get adminRecordedExpensesCount {
    final res = 'admin.recordedExpensesCount'.tr();
    return res == 'admin.recordedExpensesCount' ? 'عدد البنود المسجلة' : res;
  }

  static String get adminNoExpensesRecorded {
    final res = 'admin.noExpensesRecorded'.tr();
    return res == 'admin.noExpensesRecorded'
        ? 'لا توجد مصروفات مسجلة حالياً'
        : res;
  }

  static String get adminDeleteExpense {
    final res = 'admin.deleteExpense'.tr();
    return res == 'admin.deleteExpense' ? 'حذف المصروف' : res;
  }

  static String get adminConfirmDeleteExpense {
    final res = 'admin.confirmDeleteExpense'.tr();
    return res == 'admin.confirmDeleteExpense'
        ? 'هل أنت أؤكد من حذف بند المصروف هذا؟'
        : res;
  }

  static String get adminAddNewExpenseTitle {
    final res = 'admin.addNewExpenseTitle'.tr();
    return res == 'admin.addNewExpenseTitle' ? 'إضافة بند مصروف جديد' : res;
  }

  static String get adminExpenseTitleLabel {
    final res = 'admin.expenseTitleLabel'.tr();
    return res == 'admin.expenseTitleLabel'
        ? 'عنوان المصروف (مثلاً: حجز الفندق)'
        : res;
  }

  static String get adminExpenseAmountLabel {
    final res = 'admin.expenseAmountLabel'.tr();
    return res == 'admin.expenseAmountLabel' ? 'المبلغ الإجمالي (ج.م)' : res;
  }

  static String get adminExpenseCategoryLabel {
    final res = 'admin.expenseCategoryLabel'.tr();
    return res == 'admin.expenseCategoryLabel' ? 'الفئة:' : res;
  }

  static String get adminExpenseTripLinkOptional {
    final res = 'admin.expenseTripLinkOptional'.tr();
    return res == 'admin.expenseTripLinkOptional'
        ? 'ربط بالرحلة (اختياري):'
        : res;
  }

  static String get adminExpenseNoTripLink {
    final res = 'admin.expenseNoTripLink'.tr();
    return res == 'admin.expenseNoTripLink' ? 'بدون ربط برحلة' : res;
  }

  static String get adminExpenseNotesHint {
    final res = 'admin.expenseNotesHint'.tr();
    return res == 'admin.expenseNotesHint' ? 'ملاحظات إضافية...' : res;
  }

  static String get adminExpenseReceiptSelected {
    final res = 'admin.expenseReceiptSelected'.tr();
    return res == 'admin.expenseReceiptSelected' ? 'تم اختيار الفاتورة' : res;
  }

  static String get adminExpenseAttachReceipt {
    final res = 'admin.expenseAttachReceipt'.tr();
    return res == 'admin.expenseAttachReceipt'
        ? 'إرفاق صورة الفاتورة / الإيصال'
        : res;
  }

  static String get adminSaveExpense {
    final res = 'admin.saveExpense'.tr();
    return res == 'admin.saveExpense' ? 'حفظ المصروف' : res;
  }

  static String get adminFillRequiredFields {
    final res = 'admin.fillRequiredFields'.tr();
    return res == 'admin.fillRequiredFields'
        ? 'يرجى ملء كافة البيانات المطلوبة'
        : res;
  }

  static String get adminReceiptImageTitle {
    final res = 'admin.receiptImageTitle'.tr();
    return res == 'admin.receiptImageTitle' ? 'صورة الإيصال/الفاتورة' : res;
  }

  static String get adminViewReceipt {
    final res = 'admin.viewReceipt'.tr();
    return res == 'admin.viewReceipt' ? 'عرض الإيصال' : res;
  }

  static String get adminLinkedToTrip {
    final res = 'admin.linkedToTrip'.tr();
    return res == 'admin.linkedToTrip' ? 'مرتبط برحلة' : res;
  }

  static String get adminExpenseAddSuccess {
    final res = 'admin.expenseAddSuccess'.tr();
    return res == 'admin.expenseAddSuccess' ? 'تمت إضافة المصروف بنجاح' : res;
  }

  static String get adminExpenseDeleteSuccess {
    final res = 'admin.expenseDeleteSuccess'.tr();
    return res == 'admin.expenseDeleteSuccess' ? 'تم حذف المصروف بنجاح' : res;
  }

  static String get adminNotesPrefix {
    final res = 'admin.notesPrefix'.tr();
    return res == 'admin.notesPrefix' ? 'ملاحظات' : res;
  }

  // Admin Financial Report
  static String get adminFinancialReportTitle {
    final res = 'admin.financialReportTitle'.tr();
    return res == 'admin.financialReportTitle'
        ? 'التقارير المالية والأرباح'
        : res;
  }

  static String get adminMonthLabel {
    final res = 'admin.monthLabel'.tr();
    return res == 'admin.monthLabel' ? 'الشهر' : res;
  }

  static String get adminAllMonths {
    final res = 'admin.allMonths'.tr();
    return res == 'admin.allMonths' ? 'جميع الشهور' : res;
  }

  static String get adminMonthPrefix {
    final res = 'admin.monthPrefix'.tr();
    return res == 'admin.monthPrefix' ? 'شهر' : res;
  }

  static String get adminYearLabel {
    final res = 'admin.yearLabel'.tr();
    return res == 'admin.yearLabel' ? 'السنة' : res;
  }

  static String get adminNetProfitTitle {
    final res = 'admin.netProfitTitle'.tr();
    return res == 'admin.netProfitTitle' ? '💵 صافي الربح الفعلي' : res;
  }

  static String get adminNetProfitBadge {
    final res = 'admin.netProfitBadge'.tr();
    return res == 'admin.netProfitBadge' ? 'Net Profit' : res;
  }

  static String get adminNetProfitFormula {
    final res = 'admin.netProfitFormula'.tr();
    return res == 'admin.netProfitFormula'
        ? 'المعادلة: (المبيعات - المصروفات - عمولة المنصة)'
        : res;
  }

  static String get adminTotalGrossRevenue {
    final res = 'admin.totalGrossRevenue'.tr();
    return res == 'admin.totalGrossRevenue' ? 'إجمالي المبيعات (GMV)' : res;
  }

  static String get adminPlatformCommission {
    final res = 'admin.platformCommission'.tr();
    return res == 'admin.platformCommission' ? 'عمولة المنصة' : res;
  }

  static String get adminTotalBookingsLabel {
    final res = 'admin.totalBookingsLabel'.tr();
    return res == 'admin.totalBookingsLabel' ? 'إجمالي الحجوزات' : res;
  }

  static String get adminBookingUnit {
    final res = 'admin.bookingUnit'.tr();
    return res == 'admin.bookingUnit' ? 'حجز' : res;
  }

  static String get adminSeatUnit {
    final res = 'admin.seatUnit'.tr();
    return res == 'admin.seatUnit' ? 'مقعد' : res;
  }

  static String get adminTripFinancialPerformance {
    final res = 'admin.tripFinancialPerformance'.tr();
    return res == 'admin.tripFinancialPerformance'
        ? 'أداء الرحلات المالي'
        : res;
  }

  static String get adminCommissionPrefix {
    final res = 'admin.commissionPrefix'.tr();
    return res == 'admin.commissionPrefix' ? 'عمولة' : res;
  }

  static String get adminDuplicateTrip {
    final res = 'admin.duplicateTrip'.tr();
    return res == 'admin.duplicateTrip' ? 'تكرار' : res;
  }

  static String get adminTripDuplicatedSuccess {
    final res = 'admin.tripDuplicatedSuccess'.tr();
    return res == 'admin.tripDuplicatedSuccess'
        ? 'تم تكرار الرحلة كمسودة جديدة بنجاح'
        : res;
  }

  // Admin Offers & Passengers
  static String get adminOfferCreatedSuccess {
    final res = 'admin.offerCreatedSuccess'.tr();
    return res == 'admin.offerCreatedSuccess'
        ? 'تم إضافة العرض الترويجي بنجاح'
        : res;
  }

  static String get adminOfferUpdatedSuccess {
    final res = 'admin.offerUpdatedSuccess'.tr();
    return res == 'admin.offerUpdatedSuccess' ? 'تم تعديل العرض بنجاح' : res;
  }

  static String get adminOfferDeletedSuccess {
    final res = 'admin.offerDeletedSuccess'.tr();
    return res == 'admin.offerDeletedSuccess' ? 'تم حذف العرض بنجاح' : res;
  }

  static String get adminOfferFetchFailed {
    final res = 'admin.offerFetchFailed'.tr();
    return res == 'admin.offerFetchFailed' ? 'فشل في جلب العروض' : res;
  }

  static String get adminOfferCreateFailed {
    final res = 'admin.offerCreateFailed'.tr();
    return res == 'admin.offerCreateFailed' ? 'فشل في إنشاء العرض' : res;
  }

  static String get adminOfferUpdateFailed {
    final res = 'admin.offerUpdateFailed'.tr();
    return res == 'admin.offerUpdateFailed' ? 'فشل في تعديل العرض' : res;
  }

  static String get adminOfferDeleteFailed {
    final res = 'admin.offerDeleteFailed'.tr();
    return res == 'admin.offerDeleteFailed' ? 'فشل في حذف العرض' : res;
  }

  static String get adminPassengersTitle {
    final res = 'admin.passengersTitle'.tr();
    return res == 'admin.passengersTitle' ? 'قائمة المسافرين والمانفيست' : res;
  }

  static String get adminNoTripsYet {
    final res = 'admin.noTripsYet'.tr();
    return res == 'admin.noTripsYet' ? 'لا توجد رحلات مضافة بعد' : res;
  }

  static String get adminSelectTripLabel {
    final res = 'admin.selectTripLabel'.tr();
    return res == 'admin.selectTripLabel' ? 'اختر الرحلة:' : res;
  }

  static String get adminSearchPassengerHint {
    final res = 'admin.searchPassengerHint'.tr();
    return res == 'admin.searchPassengerHint'
        ? 'بحث باسم المسافر أو الهاتف...'
        : res;
  }

  static String get adminSendNotification {
    final res = 'admin.sendNotification'.tr();
    return res == 'admin.sendNotification' ? 'إرسال إشعار' : res;
  }

  static String get adminPassengersCount {
    final res = 'admin.passengersCount'.tr();
    return res == 'admin.passengersCount' ? 'عدد المسافرين' : res;
  }

  static String get adminCurrentSeats {
    final res = 'admin.currentSeats'.tr();
    return res == 'admin.currentSeats' ? 'المقاعد الحالية' : res;
  }

  static String get adminTripCapacity {
    final res = 'admin.tripCapacity'.tr();
    return res == 'admin.tripCapacity' ? 'سعة الرحلة' : res;
  }

  static String get adminNoPassengersMatchSearch {
    final res = 'admin.noPassengersMatchSearch'.tr();
    return res == 'admin.noPassengersMatchSearch'
        ? 'لا يوجد مسافرون مطابقون للبحث'
        : res;
  }

  static String get adminSeatsCount {
    final res = 'admin.seatsCount'.tr();
    return res == 'admin.seatsCount' ? 'مقاعد' : res;
  }

  static String get adminPickupPointLabel {
    final res = 'admin.pickupPointLabel'.tr();
    return res == 'admin.pickupPointLabel' ? 'نقطة التجمع:' : res;
  }

  static String get adminUnspecified {
    final res = 'admin.unspecified'.tr();
    return res == 'admin.unspecified' ? 'غير محددة' : res;
  }

  static String get adminSendUrgentNotification {
    final res = 'admin.sendUrgentNotification'.tr();
    return res == 'admin.sendUrgentNotification'
        ? 'إرسال تحديث/إشعار عاجل'
        : res;
  }

  static String get adminNotificationTitleLabel {
    final res = 'admin.notificationTitleLabel'.tr();
    return res == 'admin.notificationTitleLabel'
        ? 'عنوان الإشعار (مثلاً: تغيير موعد التحرك)'
        : res;
  }

  static String get adminNotificationMessageLabel {
    final res = 'admin.notificationMessageLabel'.tr();
    return res == 'admin.notificationMessageLabel'
        ? 'نص الرسالة أو التحديث للمسافرين...'
        : res;
  }

  static String get adminSendNow {
    final res = 'admin.sendNow'.tr();
    return res == 'admin.sendNow' ? 'إرسال الآن' : res;
  }

  static String get adminEnterTitleAndMessage {
    final res = 'admin.enterTitleAndMessage'.tr();
    return res == 'admin.enterTitleAndMessage'
        ? 'يرجى إدخال العنوان ونص الرسالة'
        : res;
  }

  // Admin Reviews
  static String get adminReviewsTitle {
    final res = 'admin.reviewsTitle'.tr();
    return res == 'admin.reviewsTitle' ? 'التقييمات وآراء العملاء' : res;
  }

  static String get adminCustomerFeedbackHeader {
    final res = 'admin.customerFeedbackHeader'.tr();
    return res == 'admin.customerFeedbackHeader' ? 'انطباعات العملاء' : res;
  }

  static String get adminCustomerFeedbackSub {
    final res = 'admin.customerFeedbackSub'.tr();
    return res == 'admin.customerFeedbackSub'
        ? 'تساعد التقييمات العالية في تحسين ترتيب رحلات شركتك في نتائج البحث.'
        : res;
  }

  static String get adminLatestReviews {
    final res = 'admin.latestReviews'.tr();
    return res == 'admin.latestReviews' ? 'أحدث التقييمات' : res;
  }

  static String get adminNoReviewsYet {
    final res = 'admin.noReviewsYet'.tr();
    return res == 'admin.noReviewsYet'
        ? 'لا توجد تقييمات مسجلة بعد للشركة'
        : res;
  }

  static String get adminTotalReviewsPrefix {
    final res = 'admin.totalReviewsPrefix'.tr();
    return res == 'admin.totalReviewsPrefix' ? 'إجمالي' : res;
  }

  static String get adminReviewUnit {
    final res = 'admin.reviewUnit'.tr();
    return res == 'admin.reviewUnit' ? 'تقييم' : res;
  }

  // Chat
  static String get adminChatsTitle {
    final res = 'admin.chatsTitle'.tr();
    return res == 'admin.chatsTitle' ? 'الشات والتواصل مع العملاء' : res;
  }

  static String get adminNoChatsYet {
    final res = 'admin.noChatsYet'.tr();
    return res == 'admin.noChatsYet'
        ? 'لا توجد محادثات جارية حالياً مع العملاء'
        : res;
  }

  static String get adminNoChatsYetSub {
    final res = 'admin.noChatsYetSub'.tr();
    return res == 'admin.noChatsYetSub'
        ? 'ستظهر استفسارات ورسائل العملاء هنا عند التواصل معكم'
        : res;
  }

  static String get adminTapToReply {
    final res = 'admin.tapToReply'.tr();
    return res == 'admin.tapToReply' ? 'اضغط للرد على المحادثة...' : res;
  }

  static String get userChatsTitle {
    final res = 'user.chatsTitle'.tr();
    return res == 'user.chatsTitle' ? 'محادثاتي' : res;
  }

  static String get userNoChatsYet {
    final res = 'user.noChatsYet'.tr();
    return res == 'user.noChatsYet' ? 'لا توجد محادثات جارية حالياً' : res;
  }

  static String get userNoChatsYetSub {
    final res = 'user.noChatsYetSub'.tr();
    return res == 'user.noChatsYetSub'
        ? 'يمكنك التواصل مع شركات الرحلات من صفحة تفاصيل الشركة أو تفاصيل الحجز'
        : res;
  }

  static String get userDefaultCompanyName {
    final res = 'user.defaultCompanyName'.tr();
    return res == 'user.defaultCompanyName' ? 'شركة رحلات' : res;
  }

  static String get userTapToOpenChat {
    final res = 'user.tapToOpenChat'.tr();
    return res == 'user.tapToOpenChat' ? 'اضغط لفتح المحادثة...' : res;
  }

  static String get chatDirectCustomerService {
    final res = 'chat.directCustomerService'.tr();
    return res == 'chat.directCustomerService'
        ? 'محادثة مباشرة مع خدمة العملاء'
        : res;
  }

  static String get chatTypeMessageHint {
    final res = 'chat.typeMessageHint'.tr();
    return res == 'chat.typeMessageHint' ? 'اكتب رسالتك هنا...' : res;
  }

  static String get chatAttachedImage {
    final res = 'chat.attachedImage'.tr();
    return res == 'chat.attachedImage' ? 'صورة مرفقة' : res;
  }

  static String get loginSuccessMessage {
    final res = 'messages.loginSuccessMessage'.tr();
    return res == 'messages.loginSuccessMessage'
        ? 'تم تسجيل الدخول بنجاح'
        : res;
  }

  static String get editProfileTitle {
    final res = 'profile.editProfileTitle'.tr();
    return res == 'profile.editProfileTitle' ? 'تعديل الملف الشخصي' : res;
  }

  static String get profileUpdatedSuccess {
    final res = 'profile.updatedSuccess'.tr();
    return res == 'profile.updatedSuccess'
        ? 'تم تحديث بياناتك الشخصية بنجاح! ✨'
        : res;
  }

  static String get changeProfilePhoto {
    final res = 'profile.changePhoto'.tr();
    return res == 'profile.changePhoto' ? 'تغيير الصورة الشخصية' : res;
  }

  static String get nameRequired {
    final res = 'validation.nameRequired'.tr();
    return res == 'validation.nameRequired'
        ? 'الرجاء إدخال الاسم بالكامل'
        : res;
  }

  static String get favoritesEmptySub {
    final res = 'user.favoritesEmptySub'.tr();
    return res == 'user.favoritesEmptySub'
        ? 'قم بإضافة الرحلات المميزة التي ترغب بزيارتها إلى قائمة المفضلة'
        : res;
  }

  static String get companyDetailsTitle {
    final res = 'company.detailsTitle'.tr();
    return res == 'company.detailsTitle' ? 'تفاصيل الشركة' : res;
  }

  static String get contactWithCompany {
    final res = 'company.contactWithCompany'.tr();
    return res == 'company.contactWithCompany' ? 'تواصل مع الشركة' : res;
  }

  static String get companyTourismType {
    final res = 'company.tourismType'.tr();
    return res == 'company.tourismType' ? 'شركة سياحة' : res;
  }

  static String get companyTabAbout {
    final res = 'company.tabAbout'.tr();
    return res == 'company.tabAbout' ? 'نبذة' : res;
  }

  static String get companyTabTrips {
    final res = 'company.tabTrips'.tr();
    return res == 'company.tabTrips' ? 'الرحلات' : res;
  }

  static String get companyTabReviews {
    final res = 'company.tabReviews'.tr();
    return res == 'company.tabReviews' ? 'التقييمات' : res;
  }

  static String get companyTabInfo {
    final res = 'company.tabInfo'.tr();
    return res == 'company.tabInfo' ? 'المعلومات' : res;
  }

  static String get companyContactInfo {
    final res = 'company.contactInfo'.tr();
    return res == 'company.contactInfo' ? 'معلومات التواصل' : res;
  }

  static String get noTripsAvailableForCompany {
    final res = 'company.noTripsAvailable'.tr();
    return res == 'company.noTripsAvailable'
        ? 'لا توجد رحلات متاحة لهذه الشركة حالياً'
        : res;
  }

  static String get noReviewsForCompany {
    final res = 'company.noReviews'.tr();
    return res == 'company.noReviews' ? 'لا توجد تقييمات للشركة حالياً' : res;
  }

  static String get bookingStatusConfirmed {
    final res = 'booking.statusConfirmed'.tr();
    return res == 'booking.statusConfirmed' ? 'مؤكدة' : res;
  }

  static String get bookingStatusRejected {
    final res = 'booking.statusRejected'.tr();
    return res == 'booking.statusRejected' ? 'مرفوضة' : res;
  }

  static String get bookingStatusCancelled {
    final res = 'booking.statusCancelled'.tr();
    return res == 'booking.statusCancelled' ? 'ملغاة' : res;
  }

  static String get bookingStatusPending {
    final res = 'booking.statusPending'.tr();
    return res == 'booking.statusPending' ? 'قيد الانتظار' : res;
  }

  static String get bookingAddedToFav {
    final res = 'booking.addedToFav'.tr();
    return res == 'booking.addedToFav' ? 'تمت إضافة الرحلة للمفضلة ❤️' : res;
  }

  static String get bookingRemovedFromFav {
    final res = 'booking.removedFromFav'.tr();
    return res == 'booking.removedFromFav'
        ? 'تمت إزالة الرحلة من المفضلة'
        : res;
  }

  static String get perPerson {
    final res = 'booking.perPerson'.tr();
    return res == 'booking.perPerson' ? 'للشخص' : res;
  }

  static String get bookingConfirmedSuccess {
    final res = 'booking.confirmedSuccess'.tr();
    return res == 'booking.confirmedSuccess'
        ? 'إرسال تفاصيل الحجز للشركة'
        : res;
  }

  static String get bookingSentToCompany {
    final res = 'booking.sentToCompany'.tr();
    return res == 'booking.sentToCompany'
        ? 'تم إرسال تفاصيل الحجز للشركة وبانتظار التأكيد'
        : res;
  }

  static String get searchDestinationLabel {
    final res = 'search.destinationLabel'.tr();
    return res == 'search.destinationLabel' ? 'الوجهة' : res;
  }

  static String get allLabel {
    final res = 'common.allLabel'.tr();
    return res == 'common.allLabel' ? 'الكل' : res;
  }

  static String get accommodationLabel {
    final res = 'trip.accommodationLabel'.tr();
    return res == 'trip.accommodationLabel' ? 'الإقامة' : res;
  }

  static String get durationLabel {
    final res = 'trip.durationLabel'.tr();
    return res == 'trip.durationLabel' ? 'المدة' : res;
  }

  static String get childrenLabel {
    final res = 'booking.childrenLabel'.tr();
    return res == 'booking.childrenLabel' ? 'أطفال' : res;
  }

  static String get companyTransferDetailsTitle {
    final res = 'booking.companyTransferDetailsTitle'.tr();
    return res == 'booking.companyTransferDetailsTitle'
        ? 'بيانات تحويل الشركة'
        : res;
  }

  static String get companyTransferPhoneNotice {
    final res = 'booking.companyTransferPhoneNotice'.tr();
    return res == 'booking.companyTransferPhoneNotice'
        ? 'يرجى التحويل إلى رقم فودافون كاش / انستا باي الخاص بالشركة:'
        : res;
  }

  static String get companyTransferConfirmationNotice {
    final res = 'booking.companyTransferConfirmationNotice'.tr();
    return res == 'booking.companyTransferConfirmationNotice'
        ? 'ثم أدخل بيانات حسابك ورقمك المحول منه بالأسفل ليقوم أدمن الشركة بتأكيد الحجز فور الاستلام.'
        : res;
  }

  static String get companyGatheringTitle {
    final res = 'booking.companyGatheringTitle'.tr();
    return res == 'booking.companyGatheringTitle'
        ? 'نقطة وموعد التجمع (تحددها الشركة)'
        : res;
  }

  static String get step1Title {
    final res = 'booking.step1Title'.tr();
    return res == 'booking.step1Title' ? 'الخطوة 1: تفاصيل الدفع بالحساب' : res;
  }

  static String get step2Title {
    final res = 'booking.step2Title'.tr();
    return res == 'booking.step2Title' ? 'الخطوة 2: تأكيد بيانات التحويل' : res;
  }

  static String get copyCompanyAccount {
    final res = 'booking.copyCompanyAccount'.tr();
    return res == 'booking.copyCompanyAccount' ? 'نسخ الحساب / الرقم' : res;
  }

  static String get bookingCopiedToClipboard {
    final res = 'booking.copiedToClipboard'.tr();
    return res == 'booking.copiedToClipboard'
        ? 'تم نسخ رقم الحساب إلى الحافظة بنجاح! 📋'
        : res;
  }

  static String get nextStepPayment {
    final res = 'booking.nextStepPayment'.tr();
    return res == 'booking.nextStepPayment'
        ? 'المتابعة لإدخال بيانات التحويل ➔'
        : res;
  }

  static String get previousStep {
    final res = 'booking.previousStep'.tr();
    return res == 'booking.previousStep' ? 'العودة للخطوة السابقة' : res;
  }

  static String get companyPaymentAccountsTitle {
    final res = 'company.paymentAccountsTitle'.tr();
    return res == 'company.paymentAccountsTitle'
        ? 'إدارة حسابات الدفع والتحويل'
        : res;
  }

  static String get addPaymentAccountButton {
    final res = 'company.addPaymentAccountButton'.tr();
    return res == 'company.addPaymentAccountButton'
        ? 'إضافة حساب دفع جديد'
        : res;
  }

  static String get accountProviderLabel {
    final res = 'company.accountProviderLabel'.tr();
    return res == 'company.accountProviderLabel' ? 'نوع المزود' : res;
  }

  static String get accountTitleLabel {
    final res = 'company.accountTitleLabel'.tr();
    return res == 'company.accountTitleLabel' ? 'عنوان الحساب' : res;
  }

  static String get accountNumberLabel {
    final res = 'company.accountNumberLabel'.tr();
    return res == 'company.accountNumberLabel' ? 'رقم المحفظة / الهاتف' : res;
  }

  static String get accountHandleLabel {
    final res = 'company.accountHandleLabel'.tr();
    return res == 'company.accountHandleLabel'
        ? 'عنوان انستا باي (InstaPay Handle)'
        : res;
  }

  static String get accountInstructionsLabel {
    final res = 'company.accountInstructionsLabel'.tr();
    return res == 'company.accountInstructionsLabel' ? 'تعليمات التحويل' : res;
  }

  static String get accountActiveStatus {
    final res = 'company.accountActiveStatus'.tr();
    return res == 'company.accountActiveStatus' ? 'الحساب مفعل' : res;
  }
}
