class OrganizationConfig {
  final String id;
  final VisualConfig? visual;
  final ThemesConfig? themes;
  final LayoutConfig? layout;
  final SystemLicenseConfig? systemLicense;
  final Map<String, dynamic>? features;
  final Map<String, dynamic>? productInput;
  final Map<String, dynamic>? b2bHomeLayout; // 🟢 الحقل الجديد لتخطيط الصفحة الرئيسية

  OrganizationConfig({
    required this.id,
    this.visual,
    this.themes,
    this.layout,
    this.systemLicense,
    this.features,
    this.productInput,
    this.b2bHomeLayout, // 🟢 إضافة للـ constructor
  });

  factory OrganizationConfig.fromJson(Map<String, dynamic> json) {
    return OrganizationConfig(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      visual: json['visual'] != null
          ? VisualConfig.fromJson(Map<String, dynamic>.from(json['visual']))
          : null,
      themes: json['themes'] != null
          ? ThemesConfig.fromJson(Map<String, dynamic>.from(json['themes']))
          : null,
      layout: json['layout'] != null
          ? LayoutConfig.fromJson(Map<String, dynamic>.from(json['layout']))
          : null,
      systemLicense: json['systemLicense'] != null
          ? SystemLicenseConfig.fromJson(
              Map<String, dynamic>.from(json['systemLicense']),
            )
          : null,
      features: json['features'] != null
          ? Map<String, dynamic>.from(json['features'])
          : null,
      productInput: json['productInput'] != null
          ? Map<String, dynamic>.from(json['productInput'])
          : null,
      b2bHomeLayout: json['b2bHomeLayout'] != null
          ? Map<String, dynamic>.from(json['b2bHomeLayout'])
          : null, // 🟢 قراءة الحقل الجديد
    );
  }

  ManagementFeaturesConfig? get feature {
    if (features == null || features!['feature'] == null) return null;
    return ManagementFeaturesConfig.fromJson(
      Map<String, dynamic>.from(features!['feature']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (visual != null) 'visual': visual!.toJson(),
      if (themes != null) 'themes': themes!.toJson(),
      if (layout != null) 'layout': layout!.toJson(),
      if (systemLicense != null) 'systemLicense': systemLicense!.toJson(),
      if (features != null) 'features': features,
      if (productInput != null) 'productInput': productInput,
      if (b2bHomeLayout != null) 'b2bHomeLayout': b2bHomeLayout, // 🟢 إرسال الحقل الجديد
    };
  }
}

class VisualConfig {
  final String? logoUrl;
  final String? faviconUrl;
  final String? fontFamily;

  VisualConfig({this.logoUrl, this.faviconUrl, this.fontFamily});

  factory VisualConfig.fromJson(Map<String, dynamic> json) {
    return VisualConfig(
      logoUrl: json['logoUrl'],
      faviconUrl: json['faviconUrl'],
      fontFamily: json['fontFamily'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (faviconUrl != null) 'faviconUrl': faviconUrl,
      if (fontFamily != null) 'fontFamily': fontFamily,
    };
  }
}

class ThemesConfig {
  final ThemeColors? light;
  final ThemeColors? dark;
  final WebsiteTheme? website;

  ThemesConfig({this.light, this.dark, this.website});

  factory ThemesConfig.fromJson(Map<String, dynamic> json) {
    return ThemesConfig(
      light: json['light'] != null
          ? ThemeColors.fromJson(Map<String, dynamic>.from(json['light']))
          : null,
      dark: json['dark'] != null
          ? ThemeColors.fromJson(Map<String, dynamic>.from(json['dark']))
          : null,
      website: json['website'] != null
          ? WebsiteTheme.fromJson(Map<String, dynamic>.from(json['website']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (light != null) 'light': light!.toJson(),
      if (dark != null) 'dark': dark!.toJson(),
      if (website != null) 'website': website!.toJson(),
    };
  }
}

class ThemeColors {
  final Map<String, dynamic>? rawJson;
  final String? primary;
  final String? onPrimary;
  final String? secondary;
  final String? onSecondary;
  final String? background;
  final String? onBackground;
  final String? surface;
  final String? onSurface;
  final String? error;
  final String? success;
  final String? warning;

  // الحقول التفصيلية المضافة حديثاً
  final String? accent;
  final String? surfaceVariant;
  final String? darkBackground;
  final String? darkSurface;
  final String? darkAccent;
  final String? textPrimary;
  final String? textSecondary;
  final String? textHint;
  final String? textOnDark;
  final String? textOnPrimary;
  final String? buttonPrimary;
  final String? buttonSecondary;
  final String? buttonText;
  final String? buttonTextOnDark;
  final String? inputBackground;
  final String? inputBorder;
  final String? inputFocus;
  final String? info;
  final String? decorative;
  final String? decorativeLight;
  final String? decorativeDark;
  final String? overlay;
  final String? divider;
  final String? shadow;
  final String? icon;
  final String? iconOnDark;
  final String? herbGreen;
  final String? darkGreen;

  ThemeColors({
    this.rawJson,
    this.primary,
    this.onPrimary,
    this.secondary,
    this.onSecondary,
    this.background,
    this.onBackground,
    this.surface,
    this.onSurface,
    this.error,
    this.success,
    this.warning,
    this.accent,
    this.surfaceVariant,
    this.darkBackground,
    this.darkSurface,
    this.darkAccent,
    this.textPrimary,
    this.textSecondary,
    this.textHint,
    this.textOnDark,
    this.textOnPrimary,
    this.buttonPrimary,
    this.buttonSecondary,
    this.buttonText,
    this.buttonTextOnDark,
    this.inputBackground,
    this.inputBorder,
    this.inputFocus,
    this.info,
    this.decorative,
    this.decorativeLight,
    this.decorativeDark,
    this.overlay,
    this.divider,
    this.shadow,
    this.icon,
    this.iconOnDark,
    this.herbGreen,
    this.darkGreen,
  });

  factory ThemeColors.fromJson(Map<String, dynamic> json) {
    return ThemeColors(
      rawJson: json,
      primary: json['primary']?.toString(),
      onPrimary: json['onPrimary']?.toString(),
      secondary: json['secondary']?.toString(),
      onSecondary: json['onSecondary']?.toString(),
      background: json['background']?.toString(),
      onBackground: json['onBackground']?.toString(),
      surface: json['surface']?.toString(),
      onSurface: json['onSurface']?.toString(),
      error: json['error']?.toString(),
      success: json['success']?.toString(),
      warning: json['warning']?.toString(),
      accent: json['accent']?.toString(),
      surfaceVariant: json['surfaceVariant']?.toString(),
      darkBackground: json['darkBackground']?.toString(),
      darkSurface: json['darkSurface']?.toString(),
      darkAccent: json['darkAccent']?.toString(),
      textPrimary: json['textPrimary']?.toString(),
      textSecondary: json['textSecondary']?.toString(),
      textHint: json['textHint']?.toString(),
      textOnDark: json['textOnDark']?.toString(),
      textOnPrimary: json['textOnPrimary']?.toString(),
      buttonPrimary: json['buttonPrimary']?.toString(),
      buttonSecondary: json['buttonSecondary']?.toString(),
      buttonText: json['buttonText']?.toString(),
      buttonTextOnDark: json['buttonTextOnDark']?.toString(),
      inputBackground: json['inputBackground']?.toString(),
      inputBorder: json['inputBorder']?.toString(),
      inputFocus: json['inputFocus']?.toString(),
      info: json['info']?.toString(),
      decorative: json['decorative']?.toString(),
      decorativeLight: json['decorativeLight']?.toString(),
      decorativeDark: json['decorativeDark']?.toString(),
      overlay: json['overlay']?.toString(),
      divider: json['divider']?.toString(),
      shadow: json['shadow']?.toString(),
      icon: json['icon']?.toString(),
      iconOnDark: json['iconOnDark']?.toString(),
      herbGreen: json['herbGreen']?.toString(),
      darkGreen: json['darkGreen']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (rawJson != null) ...rawJson!,
      if (primary != null) 'primary': primary,
      if (onPrimary != null) 'onPrimary': onPrimary,
      if (secondary != null) 'secondary': secondary,
      if (onSecondary != null) 'onSecondary': onSecondary,
      if (background != null) 'background': background,
      if (onBackground != null) 'onBackground': onBackground,
      if (surface != null) 'surface': surface,
      if (onSurface != null) 'onSurface': onSurface,
      if (error != null) 'error': error,
      if (success != null) 'success': success,
      if (warning != null) 'warning': warning,
      if (accent != null) 'accent': accent,
      if (surfaceVariant != null) 'surfaceVariant': surfaceVariant,
      if (darkBackground != null) 'darkBackground': darkBackground,
      if (darkSurface != null) 'darkSurface': darkSurface,
      if (darkAccent != null) 'darkAccent': darkAccent,
      if (textPrimary != null) 'textPrimary': textPrimary,
      if (textSecondary != null) 'textSecondary': textSecondary,
      if (textHint != null) 'textHint': textHint,
      if (textOnDark != null) 'textOnDark': textOnDark,
      if (textOnPrimary != null) 'textOnPrimary': textOnPrimary,
      if (buttonPrimary != null) 'buttonPrimary': buttonPrimary,
      if (buttonSecondary != null) 'buttonSecondary': buttonSecondary,
      if (buttonText != null) 'buttonText': buttonText,
      if (buttonTextOnDark != null) 'buttonTextOnDark': buttonTextOnDark,
      if (inputBackground != null) 'inputBackground': inputBackground,
      if (inputBorder != null) 'inputBorder': inputBorder,
      if (inputFocus != null) 'inputFocus': inputFocus,
      if (info != null) 'info': info,
      if (decorative != null) 'decorative': decorative,
      if (decorativeLight != null) 'decorativeLight': decorativeLight,
      if (decorativeDark != null) 'decorativeDark': decorativeDark,
      if (overlay != null) 'overlay': overlay,
      if (divider != null) 'divider': divider,
      if (shadow != null) 'shadow': shadow,
      if (icon != null) 'icon': icon,
      if (iconOnDark != null) 'iconOnDark': iconOnDark,
      if (herbGreen != null) 'herbGreen': herbGreen,
      if (darkGreen != null) 'darkGreen': darkGreen,
    };
  }

  int? _parseColor(String? colorString) {
    if (colorString == null) return null;
    colorString = colorString.replaceAll('#', '');
    if (colorString.length == 6) {
      return int.tryParse("FF" + colorString, radix: 16);
    }
    return int.tryParse(colorString, radix: 16);
  }

  int? get primaryValue => _parseColor(primary);
  int? get onPrimaryValue => _parseColor(onPrimary);
  int? get secondaryValue => _parseColor(secondary);
  int? get onSecondaryValue => _parseColor(onSecondary);
  int? get backgroundValue => _parseColor(background);
  int? get onBackgroundValue => _parseColor(onBackground);
  int? get surfaceValue => _parseColor(surface);
  int? get onSurfaceValue => _parseColor(onSurface);
  int? get errorValue => _parseColor(error);
  int? get successValue => _parseColor(success);
  int? get warningValue => _parseColor(warning);
}

class WebsiteTheme {
  final String? headerBackground;
  final String? footerBackground;
  final String? footerText;
  final String? heroOverlay;

  WebsiteTheme({
    this.headerBackground,
    this.footerBackground,
    this.footerText,
    this.heroOverlay,
  });

  factory WebsiteTheme.fromJson(Map<String, dynamic> json) {
    return WebsiteTheme(
      headerBackground: json['headerBackground'],
      footerBackground: json['footerBackground'],
      footerText: json['footerText'],
      heroOverlay: json['heroOverlay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (headerBackground != null) 'headerBackground': headerBackground,
      if (footerBackground != null) 'footerBackground': footerBackground,
      if (footerText != null) 'footerText': footerText,
      if (heroOverlay != null) 'heroOverlay': heroOverlay,
    };
  }
}

class LayoutConfig {
  final String? appTitle;
  final List<String>? topNavIds;
  final List<String>? desktopOrder;
  final List<String>? mobileOrder;
  final bool? showSearch;
  final bool? showCart;
  final bool? showUser;
  final bool? showNavLinks;
  final num? navbarBorderRadius;
  final num? navbarHorizontalPadding;
  final num? navbarVerticalPadding;
  final num? navbarMaxWidth;
  final num? scrollThreshold;

  LayoutConfig({
    this.appTitle,
    this.topNavIds,
    this.desktopOrder,
    this.mobileOrder,
    this.showSearch,
    this.showCart,
    this.showUser,
    this.showNavLinks,
    this.navbarBorderRadius,
    this.navbarHorizontalPadding,
    this.navbarVerticalPadding,
    this.navbarMaxWidth,
    this.scrollThreshold,
  });

  factory LayoutConfig.fromJson(Map<String, dynamic> json) {
    return LayoutConfig(
      appTitle: json['appTitle'],
      topNavIds: json['topNavIds'] != null
          ? List<String>.from(json['topNavIds'])
          : null,
      desktopOrder: json['desktopOrder'] != null
          ? List<String>.from(json['desktopOrder'])
          : null,
      mobileOrder: json['mobileOrder'] != null
          ? List<String>.from(json['mobileOrder'])
          : null,
      showSearch: json['showSearch'],
      showCart: json['showCart'],
      showUser: json['showUser'],
      showNavLinks: json['showNavLinks'],
      navbarBorderRadius: json['navbarBorderRadius'],
      navbarHorizontalPadding: json['navbarHorizontalPadding'],
      navbarVerticalPadding: json['navbarVerticalPadding'],
      navbarMaxWidth: json['navbarMaxWidth'],
      scrollThreshold: json['scrollThreshold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (appTitle != null) 'appTitle': appTitle,
      if (topNavIds != null) 'topNavIds': topNavIds,
      if (desktopOrder != null) 'desktopOrder': desktopOrder,
      if (mobileOrder != null) 'mobileOrder': mobileOrder,
      if (showSearch != null) 'showSearch': showSearch,
      if (showCart != null) 'showCart': showCart,
      if (showUser != null) 'showUser': showUser,
      if (showNavLinks != null) 'showNavLinks': showNavLinks,
      if (navbarBorderRadius != null) 'navbarBorderRadius': navbarBorderRadius,
      if (navbarHorizontalPadding != null)
        'navbarHorizontalPadding': navbarHorizontalPadding,
      if (navbarVerticalPadding != null)
        'navbarVerticalPadding': navbarVerticalPadding,
      if (navbarMaxWidth != null) 'navbarMaxWidth': navbarMaxWidth,
      if (scrollThreshold != null) 'scrollThreshold': scrollThreshold,
    };
  }
}

class SystemLicenseConfig {
  final bool isVerified;
  final String licenseType;
  final DateTime? expiryDate;
  final int maxUsersLimit;
  final List<String> specialPermissions;
  final String? brandNameAlias;

  SystemLicenseConfig({
    required this.isVerified,
    required this.licenseType,
    this.expiryDate,
    required this.maxUsersLimit,
    required this.specialPermissions,
    this.brandNameAlias,
  });

  factory SystemLicenseConfig.fromJson(Map<String, dynamic> json) {
    return SystemLicenseConfig(
      isVerified: json['isVerified'] ?? false,
      licenseType: json['licenseType'] ?? 'Basic',
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
      maxUsersLimit: json['maxUsersLimit'] ?? 5,
      specialPermissions: json['specialPermissions'] != null
          ? List<String>.from(json['specialPermissions'])
          : [],
      brandNameAlias: json['brandNameAlias'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isVerified': isVerified,
      'licenseType': licenseType,
      if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String(),
      'maxUsersLimit': maxUsersLimit,
      'specialPermissions': specialPermissions,
      if (brandNameAlias != null) 'brandNameAlias': brandNameAlias,
    };
  }
}

class ManagementFeaturesConfig {
  final Map<String, ScreenFeatureConfig> configs;

  ManagementFeaturesConfig({
    required this.configs,
  });

  factory ManagementFeaturesConfig.fromJson(Map<String, dynamic> json) {
    final Map<String, ScreenFeatureConfig> configs = {};
    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        configs[key] = ScreenFeatureConfig.fromJson(value);
      }
    });
    return ManagementFeaturesConfig(configs: configs);
  }

  Map<String, dynamic> toJson() {
    return configs.map((key, value) => MapEntry(key, value.toJson()));
  }

  // 🟢 Getters for backward compatibility
  ScreenFeatureConfig? get categories => configs['categories'];
  ScreenFeatureConfig? get products => configs['products'];
  ScreenFeatureConfig? get users => configs['users'];
  ScreenFeatureConfig? get offers => configs['offers'];
  ScreenFeatureConfig? get orderPaths => configs['orderPaths'];
}

class ScreenFeatureConfig {
  final double? childAspectRatio;
  final int? crossAxisCountSmall;
  final int? crossAxisCountMedium;
  final int? crossAxisCountLarge;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final List<double>? padding; // Stored as [top, right, bottom, left]
  final int? debounceMs;
  final bool? canAdd;
  final bool? shrinkWrap;
  final bool? showAddInGrid; // 🟢 الحقل الجديد

  ScreenFeatureConfig({
    this.childAspectRatio,
    this.crossAxisCountSmall,
    this.crossAxisCountMedium,
    this.crossAxisCountLarge,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.padding,
    this.debounceMs,
    this.canAdd,
    this.shrinkWrap,
    this.showAddInGrid, // 🟢 إضافة للـ constructor
  });

  factory ScreenFeatureConfig.fromJson(Map<String, dynamic> json) {
    return ScreenFeatureConfig(
      childAspectRatio: json['childAspectRatio']?.toDouble(),
      crossAxisCountSmall: json['crossAxisCountSmall'],
      crossAxisCountMedium: json['crossAxisCountMedium'],
      crossAxisCountLarge: json['crossAxisCountLarge'],
      crossAxisSpacing: json['crossAxisSpacing']?.toDouble(),
      mainAxisSpacing: json['mainAxisSpacing']?.toDouble(),
      padding: json['padding'] != null
          ? List<double>.from(json['padding'])
          : null,
      debounceMs: json['debounceMs'],
      canAdd: json['canAdd'],
      shrinkWrap: json['shrinkWrap'],
      showAddInGrid: json['showAddInGrid'], // 🟢 قراءة الحقل الجديد
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (childAspectRatio != null) 'childAspectRatio': childAspectRatio,
      if (crossAxisCountSmall != null)
        'crossAxisCountSmall': crossAxisCountSmall,
      if (crossAxisCountMedium != null)
        'crossAxisCountMedium': crossAxisCountMedium,
      if (crossAxisCountLarge != null)
        'crossAxisCountLarge': crossAxisCountLarge,
      if (crossAxisSpacing != null) 'crossAxisSpacing': crossAxisSpacing,
      if (mainAxisSpacing != null) 'mainAxisSpacing': mainAxisSpacing,
      if (padding != null) 'padding': padding,
      if (debounceMs != null) 'debounceMs': debounceMs,
      if (canAdd != null) 'canAdd': canAdd,
      if (shrinkWrap != null) 'shrinkWrap': shrinkWrap,
      if (showAddInGrid != null) 'showAddInGrid': showAddInGrid, // 🟢 إرسال الحقل الجديد
    };
  }
}
