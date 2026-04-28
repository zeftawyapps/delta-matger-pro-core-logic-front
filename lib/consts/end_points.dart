class EndPoints {
  static const String test = "/system/test-connection";
  static const String systemInfo = "/system/info";
  static const String bootstrap = "/system/bootstrap";

  // Categories
  static const String categories = "/categories";
  static const String activeCategories = "/categories/active";
  static String orgCategories(String organizationId) =>
      "/categories/organization/$organizationId";
  static String categoryById(String id) => "/categories/$id";
  static String categoryCount(String shopId) =>
      "/categories/shop/$shopId/count";

  // Products
  static const String products = "/products";
  static const String searchProducts = "/products/search";
  static String productById(String productId) => "/products/$productId";
  static String productsByCategory(String categoryId) =>
      "/products/category/$categoryId";
  static String updateStock(String productId) => "/products/$productId/stock";

  // Bulk Product Operations
  static const String bulkProducts = "/products/bulk";
  static const String bulkUpdateProducts = "/products/bulk/update";
  static const String bulkDeleteProducts = "/products/bulk/delete";
  static const String bulkVariants = "/products/bulk-variants";

  // Shared Pricing Tools
  static const String sharedPricingPreview = "/products/shared-pricing/preview";
  static const String sharedPricingApply = "/products/shared-pricing/apply";

  // Organizations
  static const String organizations = "/organizations";
  static const String activeOrganizations = "/organizations/active";
  static const String completeOrganizations = "/organizations/complete";
  static const String incompleteOrganizations = "/organizations/incomplete";
  static const String organizationStats = "/organizations/stats";
  static const String createOrgWithOwner = "/organizations/with-owner";
  static const String createOrgForExistingUser =
      "/organizations/for-existing-user";
  static const String searchOrgByLocation = "/organizations/search/location";
  static String organizationById(String id) => "/organizations/$id";
  static String activateOrganization(String id) =>
      "/organizations/$id/activate";
  static String deactivateOrganization(String id) =>
      "/organizations/$id/deactivate";
  static String setOrgTemplateStatus(String id) =>
      "/organizations/$id/template-status";
  static const String cloneOrganization = "/organizations/clone";

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
  static String ordersByOrg(String organizationId) => "/orders/$organizationId";
  static String shopOrders(String shopId) => "/orders/shop/$shopId";
  static String updateOrderStatus(String orderId) => "/orders/$orderId/status";

  // Workflow
  static String statusWorkflow(String entityType, String entryId) =>
      "/workflow/$entityType/$entryId/status";
  static String performWorkflowAction(String entityType, String entryId) =>
      "/workflow/$entityType/$entryId";
  static String claimWorkflowTask(String entityType, String entryId) =>
      "/workflow/$entityType/$entryId/claim";
  static String assignWorkflowTask(String entityType, String entryId) =>
      "/workflow/$entityType/$entryId/assign";

  // Workflow Configuration
  static String listWorkflowConfigs() => "/workflow/config";
  static String getWorkflowConfig(String orgId, String entityType) =>
      "/workflow/config/$orgId?entityType=$entityType";
  static String createWorkflowConfig(String orgId) => "/workflow/config/$orgId";
  static String addStepToWorkflow(String orgId) =>
      "/workflow/config/$orgId/create-step";
  static String updateWorkflowStep(String orgId, int stepNumber) =>
      "/workflow/config/$orgId/update-step/$stepNumber";
  static String deleteWorkflowStep(String orgId, int stepNumber) =>
      "/workflow/config/$orgId/delete-step/$stepNumber";
  static String seedWorkflowConfig(String orgId) =>
      "/workflow/config/$orgId/seed";

  // Workflow (Old compat? from documentation)
  static String trackingOrderStatus(String orderId) =>
      "/workflow/orders/$orderId/status";
  static String trackingOrderWorkflow(String orderId) =>
      "/workflow/orders/$orderId";

  // Auth
  static const String login = "/auth/login";
  static String orgLogin(String orgName) => "/auth/$orgName/login";
  static const String register = "/auth/register";
  static const String profile = "/auth/profile";
  static const String changePassword = "/auth/reset-password";

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
  static String deactivateUser(String userId) => "/profiles/$userId/deactivate";
  static String userRoles(String userId) => "/profiles/$userId/roles";
  static String removeUserRole(String userId, String roleName) =>
      "/profiles/$userId/roles/$roleName";

  // Search
  static const String searchProfiles = "/profiles/search";
  static String searchProfilesInOrg(String organizationId) =>
      "/profiles/organization/$organizationId/search";

  // Offers
  static const String offers = "/offers";
  static String offerById(String offerId) => "/offers/$offerId";
  static String orgOffers(String organizationId) =>
      "/offers/organization/$organizationId";

  // Languages
  static const String fetchLanguages = "/locations/languages";
  static const String languages = "/system/languages";
  static const String seedLanguages = "/system/languages/seed";

  // Locations
  static const String countries = "/locations/countries";
  static String governoratesOfCountry(String countryId) =>
      "/locations/countries/$countryId/governorates";
  static const String governorates = "/locations/governorates";
  static String citiesInGovernorate(String governorateId) =>
      "/locations/governorates/$governorateId/cities";
  static const String cities = "/locations/cities";
  static const String seedLocations = "/locations/governorates/seed";
}
