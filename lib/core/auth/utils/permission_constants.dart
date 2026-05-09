
class SystemFeatures {
  static const String controlPanel = 'controlPanel';
  static const String superAdmin = 'superAdmin';
  static const String commerce = 'commerce';
  static const String user = 'user';
  static const String role = 'role';
  static const String permission = 'permission';
  static const String system = 'system';
  static const String screenDashboard = 'screen.dashboard';
  static const String screenReports = 'screen.reports';
  static const String screenUsers = 'screen.users';
  static const String screenSettings = 'screen.settings';
  static const String screenOrders = 'screen.orders';
  static const String screenProducts = 'screen.products';
  static const String screenProfile = 'screen.profile';
  static const String screenCategories = 'screen.categories';
  static const String screenOffers = 'screen.offers';
  static const String screenPolicies = 'screen.policies';
  static const String product = 'product';
  static const String category = 'category';
  static const String order = 'order';
  static const String organization = 'organization';
  static const String offer = 'offer';
  static const String orgnizationownerData = 'orgnizationownerData';

  static const Map<String, Map<String, String>> translations = {
    controlPanel: {'ar': 'لوحة التحكم الأساسية', 'en': 'Core Control Panel'},
    superAdmin: {'ar': 'الإدارة العليا', 'en': 'Super Admin'},
    commerce: {'ar': 'التجارة الإلكترونية', 'en': 'E-Commerce'},
    user: {'ar': 'المستخدمين', 'en': 'Users'},
    role: {'ar': 'الأدوار والصلاحيات', 'en': 'Roles and Permissions'},
    permission: {'ar': 'الصلاحيات', 'en': 'Permissions'},
    system: {'ar': 'إعدادات النظام', 'en': 'System Settings'},
    screenDashboard: {'ar': 'لوحة البيانات والتحليلات', 'en': 'Dashboard and Analytics'},
    screenReports: {'ar': 'شاشة التقارير الحيوية', 'en': 'Vital Reports Screen'},
    screenUsers: {'ar': 'إدارة مستخدمي النظام', 'en': 'User Management Screen'},
    screenSettings: {'ar': 'الإعدادات العامة للنظام', 'en': 'System General Settings'},
    screenOrders: {'ar': 'إدارة طلبات البيع', 'en': 'Sales Orders Screen'},
    screenProducts: {'ar': 'إدارة مخزون المنتجات', 'en': 'Product Inventory Screen'},
    screenProfile: {'ar': 'الملف الشخصي للمستخدم', 'en': 'User Profile Screen'},
    screenCategories: {'ar': 'إدارة تصنيفات المتجر', 'en': 'Store Categories Screen'},
    screenOffers: {'ar': 'إدارة عروض المتجر', 'en': 'Store Offers Screen'},
    product: {'ar': 'المنتجات', 'en': 'Products'},
    category: {'ar': 'التصنيفات', 'en': 'Categories'},
    order: {'ar': 'الطلبات', 'en': 'Orders'},
    organization: {'ar': 'المنظمات', 'en': 'Organizations'},
    offer: {'ar': 'العروض', 'en': 'Offers'},
    orgnizationownerData: {'ar': 'بيانات مالك المنظمة', 'en': 'Organization Owner Data'},
    screenPolicies: {'ar': 'سياسات المتجر', 'en': 'Store Policies'},
  };
}

class SystemJobs {
  static const String all = '*';
  static const String read = 'read';
  static const String add = 'add';
  static const String update = 'update';
  static const String delete = 'delete';
  static const String manage = 'manage';
  static const String stream = 'stream';
  static const String admin = 'admin';
  static const String workflowAction = 'workflowAction';
  static const String workflowAssigner = 'workflowAssigner';
  static const String view = 'view';

  static const Map<String, Map<String, String>> translations = {
    all: {'ar': 'الكل (صلاحية كاملة)', 'en': 'All (Full Access)'},
    read: {'ar': 'عرض وقراءة', 'en': 'Read'},
    add: {'ar': 'إضافة جديد', 'en': 'Add New'},
    update: {'ar': 'تعديل', 'en': 'Update'},
    delete: {'ar': 'حذف', 'en': 'Delete'},
    manage: {'ar': 'إدارة كاملة', 'en': 'Full Management'},
    stream: {'ar': 'متابعة حية', 'en': 'Live Stream'},
    admin: {'ar': 'صلاحية أدمن', 'en': 'Admin Access'},
    workflowAction: {'ar': 'إجراءات سير العمل', 'en': 'Workflow Actions'},
    workflowAssigner: {'ar': 'تعيين المهام', 'en': 'Task Assignment'},
    view: {'ar': 'دخول الشاشة (لـ Screens)', 'en': 'Enter Screen (for Screens)'},
  };
}
