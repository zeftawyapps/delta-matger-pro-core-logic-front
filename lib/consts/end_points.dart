class EndPoints {
  static const String test = "/system/test-connection";

  // Categories
  static const String categories = "/categories";
  static const String activeCategories = "/categories/active";
  static String orgCategories(String organizationId) =>
      "/categories/organization/$organizationId";
  static String categoryCount(String shopId) =>
      "/categories/shop/$shopId/count";

  // Products
  static const String products = "/products";
  static const String searchProducts = "/products/search";
  static String productById(String productId) => "/products/$productId";
  static String updateStock(String productId) => "/products/$productId/stock";

  // Organizations
  static const String organizations = "/organizations";
  static const String activeOrganizations = "/organizations/active";
  static const String createOrgWithOwner = "/organizations/with-owner";

  // Organization Configs
  static String organizationConfigs(String organizationId) =>
      "/organization-configs/$organizationId";

  static String organizationConfigsByName(String orgName) =>
      "/organization-configs/name/$orgName";

  static String organizationConfigsSection(
    String organizationId,
    String section,
  ) => "/organization-configs/$organizationId/$section";

  // Organization Policies
  static String organizationPolicies(String organizationId) =>
      "/organization-policies/$organizationId";
  static String organizationPoliciesSection(
    String organizationId,
    String section,
  ) => "/organization-policies/$organizationId/$section";

  // Orders
  static const String orders = "/orders";
  static String orderById(String orderId) => "/orders/$orderId";
  static String shopOrders(String shopId) => "/orders/shop/$shopId";
  static String updateOrderStatus(String orderId) => "/orders/$orderId/status";

  // Auth
  static const String login = "/auth/login";
  static String orgLogin(String orgName) => "/auth/$orgName/login";
  static const String register = "/auth/register";
  static const String profile = "/auth/profile";

  // Roles
  static const String roles = "/roles";
  static const String allPermissions = "/roles/permissions/all";
  static const String checkPermission = "/roles/permissions/check";
  static String roleById(String roleId) => "/roles/$roleId";
  static String copyRole(String roleId) => "/roles/$roleId/copy";

  // Profiles (User Management)
  static const String profiles = "/profiles";
  static const String createNewUser = "/profiles/createNewUser";
  static const String activeProfiles = "/profiles/active";
  static const String profileStats = "/profiles/stats";
  static const String myProfile = "/profiles/me";
  static String profilesByRole(String role) => "/profiles/role/$role";
  static String profileById(String userId) => "/profiles/$userId";
  static String activateUser(String userId) => "/profiles/$userId/activate";
  static String deactivateUser(String userId) =>
      "/profiles/$userId/deactivate";
  static String userRoles(String userId) => "/profiles/$userId/roles";
  static String removeUserRole(String userId, String roleName) =>
      "/profiles/$userId/roles/$roleName";

  // Search
  static const String searchProfiles = "/profiles/search";
  static String searchProfilesInOrg(String organizationId) =>
      "/profiles/organization/$organizationId/search";
}
