# matger_pro_core_logic

A Flutter package containing all the Business Logic for the Matger platform.
Works as a **shared package** across multiple Flutter projects, providing: Repositories, Data Sources, Models, and configuration utilities.

---

## 🚀 Quick Start

### 1. Initialize Configuration

Call this at the very beginning of `main()` before anything else.

```dart
import 'package:matger_pro_core_logic/config/paoject_config.dart';
import 'package:matger_pro_core_logic/utls/storage/storage_helper.dart';
import 'package:matger_pro_core_logic/core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the API base URLs
  projectConfig(
    myBaseUrl: 'https://api.yourserver.com/api/v1',
    myImageUrl: 'https://api.yourserver.com',
  );

  // Initialize local storage
  await StorageHelper.init();

  // Register all repos in the Service Locator
  await initCoreLocator();

  runApp(const MyApp());
}
```

### 2. Set Token After Login

After a successful login, inject the token into all future requests automatically.

```dart
import 'package:matger_pro_core_logic/config/paoject_config.dart';

ProjectAPIHeader.setToken(user.token);
ProjectAPIHeader.setLanguage('en'); // or 'ar'
```

### 3. Use Repos via Service Locator

After `initCoreLocator()`, access any repo anywhere in your app.

```dart
import 'package:matger_pro_core_logic/core/di/injection_container.dart';

final authRepo   = sl<AuthRepo>();
final orgRepo    = sl<OrganizationRepo>();
final roleRepo   = sl<RoleRepo>();
final userRepo   = sl<UserRepo>();
final catRepo    = sl<CategoryRepo>();
final prodRepo   = sl<ProductRepo>();
final orderRepo  = sl<OrderRepo>();
```

---

## ⚙️ projectConfig

Configures the base URL and image URL for all API calls in the package.

```dart
projectConfig({
  String? myBaseUrl,    // Default: 'http://localhost:3000/api/v1'
  String? myImageUrl,   // Default: 'http://localhost:3000'
});
```

### ProjectAPIHeader

Static utility to set global request headers.

```dart
ProjectAPIHeader.setToken(String? token);    // Attach Bearer token
ProjectAPIHeader.setLanguage(String lang);   // 'en' | 'ar'
```

---

## 💉 Service Locator — `initCoreLocator()`

Located at `lib/core/di/injection_container.dart`. Registers all Sources and Repos using **GetIt** as `LazySingleton` — they are only created when first requested.

```
sl<AuthRepo>()           → Login / Register / Profile
sl<OrganizationRepo>()   → Organizations / Configs / Policies
sl<RoleRepo>()           → Role & Permission Management
sl<UserRepo>()           → User & Employee Management
sl<CategoryRepo>()       → Category Management
sl<ProductRepo>()        → Product Management
sl<OrderRepo>()          → Order Management
```

> Must call `initCoreLocator()` before using `sl<T>()`.

---

## 📐 RemoteBaseModel\<T\> — Response Format

Every Repo method returns `RemoteBaseModel<T>`. Always check `status` before accessing `data`.

```dart
final result = await sl<AuthRepo>().login(username: 'ahmed', password: '123456');

if (result.status == StatusModel.success) {
  final UserModel user = result.data!;
  ProjectAPIHeader.setToken(user.token);
} else {
  final String errorMsg = result.message ?? 'An error occurred';
}
```

---

## 📦 Repositories

### 🔐 AuthRepo

Handles authentication — login, registration, and profile fetching.

```dart
// Standard login
await sl<AuthRepo>().login(username: 'ahmed', password: '123456');

// Login scoped to a specific organization
await sl<AuthRepo>().loginOrg(orgName: 'my-org', username: 'ahmed', password: '123456');

// Register a new user
await sl<AuthRepo>().register(userData: { 'username': '...', 'email': '...' });

// Get the current logged-in user's profile
await sl<AuthRepo>().getProfile();
```

---

### 🏢 OrganizationRepo

Manages organizations, their configurations, and policies.

```dart
await sl<OrganizationRepo>().getActiveOrganizations();
await sl<OrganizationRepo>().createOrganizationWithOwner(
  userData: { ... },
  organizationData: OrganizationData(...),
);

// Config
await sl<OrganizationRepo>().getOrganizationConfig(orgId);
await sl<OrganizationRepo>().getOrganizationConfigByName('org-slug');
await sl<OrganizationRepo>().updateOrganizationConfig(organizationId: orgId, config: config);
await sl<OrganizationRepo>().updateOrganizationConfigSection(
  organizationId: orgId,
  section: 'themes', // 'themes' | 'layout' | 'visual'
  sectionData: { ... },
);

// Config Sections (shorthand)
await sl<OrganizationRepo>().getOrganizationThemes(orgId);
await sl<OrganizationRepo>().updateOrganizationThemes(organizationId: orgId, themes: ThemesConfig(...));
await sl<OrganizationRepo>().getOrganizationLayout(orgId);
await sl<OrganizationRepo>().updateOrganizationLayout(organizationId: orgId, layout: LayoutConfig(...));
await sl<OrganizationRepo>().getOrganizationVisual(orgId);
await sl<OrganizationRepo>().updateOrganizationVisual(organizationId: orgId, visual: VisualConfig(...));

// Policy
await sl<OrganizationRepo>().getOrganizationPolicy(orgId);
await sl<OrganizationRepo>().updateOrganizationPolicy(organizationId: orgId, policy: OrganizationPolicy(...));
await sl<OrganizationRepo>().updateOrganizationPolicySection(
  organizationId: orgId,
  section: 'section-name',
  sectionData: { ... },
);
```

---

### 🎭 RoleRepo — Role & Permission Management

Manage custom roles with fine-grained permissions. Roles are then assigned to users.

```dart
// Get all system permissions (use to build a Checkboxes UI)
RemoteBaseModel<List<PermissionModel>> perms = await sl<RoleRepo>().getAllPermissions();

// List all roles, optionally filter by organization
RemoteBaseModel<List<RoleDataModel>> roles = await sl<RoleRepo>().getRoles(organizationId: 'org_123');

// Create a new role
await sl<RoleRepo>().createRole(
  name: 'manager_role',
  displayName: 'General Manager',
  description: 'Full administrative access',
  permissions: ['product:*', 'category:read'],
  organizationId: 'org_123',
);

// Get / Update / Delete a role
await sl<RoleRepo>().getRoleById(roleId);
await sl<RoleRepo>().updateRole(roleId: roleId, displayName: 'New Name', permissions: ['order:read']);
await sl<RoleRepo>().deleteRole(roleId); // Soft delete

// Copy a role to another organization
await sl<RoleRepo>().copyRole(roleId: roleId, targetOrganizationId: 'other-org');

// Check if a user has a specific permission
RemoteBaseModel<PermissionCheckResult> check = await sl<RoleRepo>().checkPermission(
  userRoles: ['manager_role'],
  permissionType: 'read',
  resource: 'product',
);
if (check.data?.hasPermission == true) { /* allow */ }
```

---

### 👥 UserRepo — User & Employee Management

Create and manage users/employees. Assign custom roles (system roles like `admin` cannot be assigned here).

```dart
// Create a new user/employee
await sl<UserRepo>().createNewUser(
  username: 'ahmed_ali',
  email: 'ahmed@example.com',
  password: 'StrongPass!1',
  phone: '+966500000000',
  roles: ['manager_role'], // Custom roles only
);

// List users
await sl<UserRepo>().getActiveProfiles();
await sl<UserRepo>().getProfilesByRole('manager_role');
await sl<UserRepo>().getProfileById(userId);

// Update
await sl<UserRepo>().updateProfile(userId: userId, phone: '+966599999999', isActive: true);
await sl<UserRepo>().updateMyProfile(bio: 'Sales Manager', website: 'https://...');

// Activate / Deactivate
await sl<UserRepo>().activateUser(userId);
await sl<UserRepo>().deactivateUser(userId);

// Role assignment
await sl<UserRepo>().addRoleToUser(userId: userId, roleName: 'manager_role');
await sl<UserRepo>().removeRoleFromUser(userId: userId, roleName: 'manager_role');

// Stats
await sl<UserRepo>().getProfileStats();
```

---

### 🗂️ CategoryRepo

```dart
await sl<CategoryRepo>().createCategory(name: 'Electronics', shopId: orgId);
await sl<CategoryRepo>().getCategoriesByOrganization(orgId);
await sl<CategoryRepo>().updateCategory(categoryId: id, name: 'New Name', isActive: true);
await sl<CategoryRepo>().deleteCategory(categoryId);
```

---

### 📦 ProductRepo

```dart
await sl<ProductRepo>().createProduct(...);
await sl<ProductRepo>().getProducts();
await sl<ProductRepo>().getProductById(productId);
await sl<ProductRepo>().searchProducts(query: 'cake');
await sl<ProductRepo>().updateProduct(productId: id, ...);
await sl<ProductRepo>().updateStock(productId: id, quantity: 50);
await sl<ProductRepo>().deleteProduct(productId);
```

---

### 🛒 OrderRepo

```dart
await sl<OrderRepo>().createOrder(...);
await sl<OrderRepo>().getOrders();
await sl<OrderRepo>().getOrderById(orderId);
await sl<OrderRepo>().getOrdersByShop(shopId);
await sl<OrderRepo>().updateOrderStatus(orderId: id, status: 'confirmed');
```

---

## 🗄️ StorageHelper

A `SharedPreferences` wrapper for managing tokens and persistent data.

```dart
import 'package:matger_pro_core_logic/utls/storage/storage_helper.dart';

// Token
await StorageHelper.saveToken(token);
String? token = StorageHelper.getToken();
await StorageHelper.clearToken();

// Generic data
await StorageHelper.saveData('my_key', 'value');
String? val = StorageHelper.getData('my_key');
await StorageHelper.removeData('my_key');

// Last credentials (e.g. "Remember Me")
await StorageHelper.saveLastCredentials('username', 'password');
Map<String, String> creds = StorageHelper.getLastCredentials();

// Clear everything
await StorageHelper.clearAll();
```

---

## 🗺️ Project Structure

```
lib/
├── config/
│   └── paoject_config.dart             ← projectConfig + ProjectAPIHeader
├── consts/
│   └── end_points.dart                 ← All API endpoints
├── core/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── user_model.dart
│   │   │   ├── user_profile_model.dart
│   │   │   ├── role_model.dart
│   │   │   └── permission_model.dart
│   │   ├── source/auth_source.dart
│   │   └── repos/auth_repo.dart
│   ├── di/injection_container.dart     ← GetIt Locator (initCoreLocator)
│   └── orgnization/
│       ├── data/
│       │   ├── organization_model.dart
│       │   ├── organization_config.dart
│       │   └── organization_policy.dart
│       ├── source/organization_source.dart
│       └── repo/organization_repo.dart
├── features/
│   ├── commrec/
│   │   ├── data/   (category / product / order models)
│   │   ├── source/ (category / product / order sources)
│   │   └── repo/   (category / product / order repos)
│   ├── roles/
│   │   ├── data/role_data_model.dart
│   │   ├── source/role_source.dart
│   │   └── repo/role_repo.dart
│   └── users/
│       ├── source/user_source.dart
│       └── repo/user_repo.dart
├── models/
│   ├── entity_meta.dart
│   └── app_settings.dart
└── utls/storage/storage_helper.dart
```

---
---
---

# matger_pro_core_logic — النسخة العربية

حزمة Flutter تحتوي على كل منطق الأعمال الخاص بمنصة Matger.
تعمل كـ **shared package** بين مشاريع Flutter المتعددة، وتوفر: Repositories، Data Sources، Models، وأدوات التهيئة.

---

## 🚀 البداية السريعة

### 1. تهيئة الإعدادات

استدعِها في أول سطر من `main()` قبل أي شيء آخر.

```dart
import 'package:matger_pro_core_logic/config/paoject_config.dart';
import 'package:matger_pro_core_logic/utls/storage/storage_helper.dart';
import 'package:matger_pro_core_logic/core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تعيين روابط الـ API
  projectConfig(
    myBaseUrl: 'https://api.yourserver.com/api/v1',
    myImageUrl: 'https://api.yourserver.com',
  );

  // تهيئة التخزين المحلي
  await StorageHelper.init();

  // تسجيل كل الـ Repos في الـ Service Locator
  await initCoreLocator();

  runApp(const MyApp());
}
```

### 2. تعيين الـ Token بعد الدخول

بعد نجاح الدخول، ضع الـ token في كل الطلبات القادمة تلقائياً.

```dart
import 'package:matger_pro_core_logic/config/paoject_config.dart';

ProjectAPIHeader.setToken(user.token);
ProjectAPIHeader.setLanguage('ar'); // أو 'en'
```

### 3. استخدام الـ Repos عبر Service Locator

بعد `initCoreLocator()` استخدم أي Repo في أي مكان بالتطبيق.

```dart
import 'package:matger_pro_core_logic/core/di/injection_container.dart';

final authRepo   = sl<AuthRepo>();
final orgRepo    = sl<OrganizationRepo>();
final roleRepo   = sl<RoleRepo>();
final userRepo   = sl<UserRepo>();
final catRepo    = sl<CategoryRepo>();
final prodRepo   = sl<ProductRepo>();
final orderRepo  = sl<OrderRepo>();
```

---

## ⚙️ projectConfig — التهيئة

يضبط الـ Base URL وعنوان الصور لجميع طلبات الـ API في الحزمة.

```dart
projectConfig({
  String? myBaseUrl,    // الافتراضي: 'http://localhost:3000/api/v1'
  String? myImageUrl,   // الافتراضي: 'http://localhost:3000'
});
```

### ProjectAPIHeader — ضبط الـ Headers

أداة ثابتة لضبط الـ headers العامة لجميع الطلبات.

```dart
ProjectAPIHeader.setToken(String? token);    // إضافة الـ Bearer token
ProjectAPIHeader.setLanguage(String lang);   // 'ar' | 'en'
```

---

## 💉 Service Locator — `initCoreLocator()`

موجود في `lib/core/di/injection_container.dart`. يسجل كل الـ Sources والـ Repos عبر **GetIt** بصيغة `LazySingleton` — تُنشأ فقط عند أول استخدام.

```
sl<AuthRepo>()           ← تسجيل / دخول / بروفايل
sl<OrganizationRepo>()   ← إدارة المنظمات والإعدادات
sl<RoleRepo>()           ← إدارة الأدوار والصلاحيات
sl<UserRepo>()           ← إدارة المستخدمين والموظفين
sl<CategoryRepo>()       ← إدارة التصنيفات
sl<ProductRepo>()        ← إدارة المنتجات
sl<OrderRepo>()          ← إدارة الطلبات
```

> يجب استدعاء `initCoreLocator()` قبل استخدام `sl<T>()`.

---

## 📐 صيغة الاستجابة — `RemoteBaseModel<T>`

كل دالة في الـ Repo ترجع `RemoteBaseModel<T>`. تحقق دائماً من `status` قبل استخدام `data`.

```dart
final result = await sl<AuthRepo>().login(username: 'ahmed', password: '123456');

if (result.status == StatusModel.success) {
  final UserModel user = result.data!;
  ProjectAPIHeader.setToken(user.token);
} else {
  final String errorMsg = result.message ?? 'حدث خطأ';
}
```

---

## 📦 مستودعات البيانات (Repositories)

### 🔐 AuthRepo — المصادقة

يتولى عمليات المصادقة — الدخول، التسجيل، وجلب الملف الشخصي.

```dart
// تسجيل الدخول العام
await sl<AuthRepo>().login(username: 'ahmed', password: '123456');

// دخول لمنظمة محددة
await sl<AuthRepo>().loginOrg(orgName: 'my-org', username: 'ahmed', password: '123456');

// تسجيل مستخدم جديد
await sl<AuthRepo>().register(userData: { 'username': '...', 'email': '...' });

// جلب بيانات المستخدم الحالي
await sl<AuthRepo>().getProfile();
```

---

### 🏢 OrganizationRepo — إدارة المنظمات

يدير المنظمات وإعداداتها وسياساتها.

```dart
// قائمة المنظمات النشطة
await sl<OrganizationRepo>().getActiveOrganizations();

// إنشاء منظمة مع مالكها
await sl<OrganizationRepo>().createOrganizationWithOwner(
  userData: { ... },
  organizationData: OrganizationData(...),
);

// الإعدادات - Config
await sl<OrganizationRepo>().getOrganizationConfig(orgId);
await sl<OrganizationRepo>().getOrganizationConfigByName('org-slug');
await sl<OrganizationRepo>().updateOrganizationConfig(organizationId: orgId, config: config);
await sl<OrganizationRepo>().updateOrganizationConfigSection(
  organizationId: orgId,
  section: 'themes', // 'themes' | 'layout' | 'visual'
  sectionData: { ... },
);

// أقسام الإعدادات (مباشرة)
await sl<OrganizationRepo>().getOrganizationThemes(orgId);
await sl<OrganizationRepo>().updateOrganizationThemes(organizationId: orgId, themes: ThemesConfig(...));
await sl<OrganizationRepo>().getOrganizationLayout(orgId);
await sl<OrganizationRepo>().updateOrganizationLayout(organizationId: orgId, layout: LayoutConfig(...));
await sl<OrganizationRepo>().getOrganizationVisual(orgId);
await sl<OrganizationRepo>().updateOrganizationVisual(organizationId: orgId, visual: VisualConfig(...));

// السياسات - Policy
await sl<OrganizationRepo>().getOrganizationPolicy(orgId);
await sl<OrganizationRepo>().updateOrganizationPolicy(organizationId: orgId, policy: OrganizationPolicy(...));
await sl<OrganizationRepo>().updateOrganizationPolicySection(
  organizationId: orgId,
  section: 'section-name',
  sectionData: { ... },
);
```

---

### 🎭 RoleRepo — إدارة الأدوار والصلاحيات

إنشاء وإدارة أدوار مخصصة بصلاحيات محددة، تُعيَّن لاحقاً للمستخدمين.

```dart
// جلب جميع الصلاحيات (مناسب لعرض Checkboxes عند إنشاء الدور)
RemoteBaseModel<List<PermissionModel>> perms = await sl<RoleRepo>().getAllPermissions();

// قائمة الأدوار، اختياري: فلتر بالمنظمة
RemoteBaseModel<List<RoleDataModel>> roles = await sl<RoleRepo>().getRoles(organizationId: 'org_123');

// إنشاء دور جديد
await sl<RoleRepo>().createRole(
  name: 'manager_role',         // المعرف الفريد
  displayName: 'المدير العام',  // الاسم في الواجهة
  description: 'صلاحيات إدارية كاملة',
  permissions: ['product:*', 'category:read'],
  organizationId: 'org_123',
);

// جلب / تعديل / حذف دور
await sl<RoleRepo>().getRoleById(roleId);
await sl<RoleRepo>().updateRole(roleId: roleId, displayName: 'اسم جديد', permissions: ['order:read']);
await sl<RoleRepo>().deleteRole(roleId); // حذف ناعم (Soft Delete)

// نسخ دور لمنظمة أخرى
await sl<RoleRepo>().copyRole(roleId: roleId, targetOrganizationId: 'other-org');

// فحص صلاحية مستخدم
RemoteBaseModel<PermissionCheckResult> check = await sl<RoleRepo>().checkPermission(
  userRoles: ['manager_role'],
  permissionType: 'read',
  resource: 'product',
);
if (check.data?.hasPermission == true) { /* السماح بالإجراء */ }
```

---

### 👥 UserRepo — إدارة المستخدمين والموظفين

إنشاء وإدارة المستخدمين والموظفين. تعيين أدوار مخصصة فقط (الأدوار الأساسية مثل `admin` لا يمكن تعيينها هنا).

```dart
// إنشاء مستخدم أو موظف جديد
await sl<UserRepo>().createNewUser(
  username: 'ahmed_ali',
  email: 'ahmed@example.com',
  password: 'StrongPass!1',
  phone: '+966500000000',
  roles: ['manager_role'], // أدوار مخصصة فقط
);

// قائمة المستخدمين
await sl<UserRepo>().getActiveProfiles();
await sl<UserRepo>().getProfilesByRole('manager_role');
await sl<UserRepo>().getProfileById(userId);

// تحديث البيانات
await sl<UserRepo>().updateProfile(userId: userId, phone: '+966599999999', isActive: true);
await sl<UserRepo>().updateMyProfile(bio: 'مدير المبيعات', website: 'https://...');

// تفعيل / إيقاف حساب
await sl<UserRepo>().activateUser(userId);
await sl<UserRepo>().deactivateUser(userId);

// إضافة / إزالة دور
await sl<UserRepo>().addRoleToUser(userId: userId, roleName: 'manager_role');
await sl<UserRepo>().removeRoleFromUser(userId: userId, roleName: 'manager_role');

// إحصائيات
await sl<UserRepo>().getProfileStats();
```

---

### 🗂️ CategoryRepo — التصنيفات

```dart
await sl<CategoryRepo>().createCategory(name: 'ملابس', shopId: orgId);
await sl<CategoryRepo>().getCategoriesByOrganization(orgId);
await sl<CategoryRepo>().updateCategory(categoryId: id, name: 'اسم جديد', isActive: true);
await sl<CategoryRepo>().deleteCategory(categoryId);
```

---

### 📦 ProductRepo — المنتجات

```dart
await sl<ProductRepo>().createProduct(...);
await sl<ProductRepo>().getProducts();
await sl<ProductRepo>().getProductById(productId);
await sl<ProductRepo>().searchProducts(query: 'كيك');
await sl<ProductRepo>().updateProduct(productId: id, ...);
await sl<ProductRepo>().updateStock(productId: id, quantity: 50);
await sl<ProductRepo>().deleteProduct(productId);
```

---

### 🛒 OrderRepo — الطلبات

```dart
await sl<OrderRepo>().createOrder(...);
await sl<OrderRepo>().getOrders();
await sl<OrderRepo>().getOrderById(orderId);
await sl<OrderRepo>().getOrdersByShop(shopId);
await sl<OrderRepo>().updateOrderStatus(orderId: id, status: 'confirmed');
```

---

## 🗄️ StorageHelper — التخزين المحلي

غلاف لـ `SharedPreferences` لإدارة الـ token والبيانات الدائمة.

```dart
import 'package:matger_pro_core_logic/utls/storage/storage_helper.dart';

// الـ Token
await StorageHelper.saveToken(token);
String? token = StorageHelper.getToken();
await StorageHelper.clearToken();

// بيانات عامة
await StorageHelper.saveData('my_key', 'value');
String? val = StorageHelper.getData('my_key');
await StorageHelper.removeData('my_key');

// حفظ بيانات آخر دخول (لخاصية "تذكرني")
await StorageHelper.saveLastCredentials('username', 'password');
Map<String, String> creds = StorageHelper.getLastCredentials();

// مسح الكل
await StorageHelper.clearAll();
```

---

## 🗺️ هيكل المشروع

```
lib/
├── config/
│   └── paoject_config.dart             ← projectConfig + ProjectAPIHeader
├── consts/
│   └── end_points.dart                 ← كل نقاط الـ API
├── core/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── user_model.dart
│   │   │   ├── user_profile_model.dart
│   │   │   ├── role_model.dart
│   │   │   └── permission_model.dart
│   │   ├── source/auth_source.dart
│   │   └── repos/auth_repo.dart
│   ├── di/injection_container.dart     ← GetIt Locator (initCoreLocator)
│   └── orgnization/
│       ├── data/
│       │   ├── organization_model.dart
│       │   ├── organization_config.dart
│       │   └── organization_policy.dart
│       ├── source/organization_source.dart
│       └── repo/organization_repo.dart
├── features/
│   ├── commrec/
│   │   ├── data/   (category / product / order models)
│   │   ├── source/ (category / product / order sources)
│   │   └── repo/   (category / product / order repos)
│   ├── roles/
│   │   ├── data/role_data_model.dart
│   │   ├── source/role_source.dart
│   │   └── repo/role_repo.dart
│   └── users/
│       ├── source/user_source.dart
│       └── repo/user_repo.dart
├── models/
│   ├── entity_meta.dart
│   └── app_settings.dart
└── utls/storage/storage_helper.dart
```
