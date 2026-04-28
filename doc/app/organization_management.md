# 📘 Frontend Developer Guide - Organization Management System

هذا الدليل يوضح هيكلية البيانات (JSON)، نقاط النهاية (Endpoints)، والصلاحيات المطلوبة لكل عملية في نظام إدارة المنظمات والتهيئات المتقدم.

---

## 🏗️ 1. نموذج المنظمة الموحد (Unified Organization Model)

هذا الكائن هو الهيكل الأساسي الذي تتعامل معه في كافة عمليات الجلب والتحديث.

### هيكل البيانات (JSON structure)
```json
{
  "id": "65f2a...",
  "orgName": "brand-slug",
  "name": "الاسم الكامل للمنظمة/المتجر",
  "ownerId": "owner_user_id",
  "address": "العنوان التفصيلي",
  "phone": "+2010...",
  "email": "org@example.com",
  "countryId": "EG",
  "location": {
    "latitude": 30.044,
    "longitude": 31.235
  },
  "isActive": true,
  "isDataComplete": true,
  "isTemplate": false,
  "meta": {
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  }
}
```

---

## 🚀 2. العمليات ونقاط النهاية (Endpoints & API)

يتم الوصول لهذه العمليات عبر `OrganizationRepo` و `OrganizationSource` في الـ Core Logic.

### • الإنشاء والنسخ (Creation & Cloning)
| الوظيفة | الطريقة | المسار (Route) | المعاير المطلوبة | الصلاحية |
| :--- | :--- | :--- | :--- | :--- |
| إنشاء منظمة مع مالك جديد | `POST` | `/with-owner` | `userData`, `organizationData`, `templateOrgId?` | `controlPanel:add` |
| إنشاء منظمة لمستخدم موجود | `POST` | `/for-existing-user` | `userId`, `organizationData`, `templateOrgId?` | `controlPanel:add` |
| استنساخ إعدادات كاملة | `POST` | `/clone` | `templateOrgId`, `targetOrgId`, `overwrite?` | `controlPanel:add` |

### • جلب البيانات والفلترة (Read Operations)
| الوظيفة | الطريقة | المسار (Route) | وصف النتيجة |
| :--- | :--- | :--- | :--- |
| الإحصائيات العامة | `GET` | `/stats` | يعيد أرقام (Total, Active, Inactive, Templates) |
| المنظمات النشطة | `GET` | `/active` | قائمة المنظمات المفعلة |
| المنظمات المكتملة | `GET` | `/complete` | قائمة المنظمات التي استكملت بياناتها |
| المنظمات غير المكتملة | `GET` | `/incomplete` | قائمة المنظمات التي ينقصها بيانات |
| البحث الجغرافي | `GET` | `/search/location` | يتطلب `lat`, `lng`, `radius` في الـ Query |

### • الإدارة والتحكم (Admin & Status)
| الوظيفة | الطريقة | المسار (Route) | الصلاحية |
| :--- | :--- | :--- | :--- |
| تحديث البيانات | `PUT` | `/:id` | `organization:update` |
| تفعيل المنظمة | `PUT` | `/:id/activate` | `controlPanel:update` |
| تعطيل المنظمة | `PUT` | `/:id/deactivate` | `controlPanel:update` |
| ضبط كقالب (Template) | `PUT` | `/:id/template-status` | `controlPanel:update` |
| حذف المنظمة نهائياً | `DELETE`| `/:id` | `controlPanel:delete` |

---

## 🛠️ 3. التهيئة البرمجية (Core Logic Integration)

### استخدام الـ Repository
يمكنك الوصول لكافة العمليات من خلال `OrganizationRepo`:

```dart
final repo = OrganizationRepo();

// مثال: جلب الإحصائيات
final statsResult = await repo.getOrganizationStats();

// مثال: استنساخ إعدادات منظمة
final cloneResult = await repo.cloneOrganization(
  templateOrgId: "TEMPLATE_ID",
  targetOrgId: "NEW_ORG_ID",
  overwrite: true, // اختياري: true للإحلال، false للإضافة فقط
);
```

### نماذج الطلبات (Request Models)
تم توفير نماذج طلبات (Value Objects) لضمان دقة البيانات المبعوثة:
*   `CreateOrgWithOwnerRequest`
*   `OrganizationLocationSearchRequest`
*   `OrganizationStatsModel` (App Wrapper)

---

## 📱 4. تطبيق الإدارة (Flutter Admin App Integration)

يتم التعامل مع كافة العمليات السابقة من خلال `AdminOrganizationsBloc` الذي يوفر إدارة متكاملة للحالة (State Management).

### • ميثاق الحالات (State Mapping)
| حقل الحالة في الـ Bloc | نوع البيانات | الاستخدام |
| :--- | :--- | :--- |
| `listState` | `List<OrganizationModel>` | عرض القوائم (النشطة، المكتملة، البحث) |
| `itemState` | `OrganizationModel` | عمليات الإضافة، التحديث، والاستنساخ (Clone) |
| `feadState` | `OrganizationStatsModel` | عرض لوحة الإحصائيات (Stats) |

### • الدوال المتاحة في الـ Bloc
| الدالة | الوصف |
| :--- | :--- |
| `loadActiveOrganizations()` | جلب القائمة الرئيسية لجميع المنظمات المفعلة. |
| `loadCompleteOrganizations()` | فلترة المنظمات التي استكملت بياناتها بنجاح. |
| `loadOrganizationStats()` | جلب الأرقام والإحصائيات (Total, Active, etc) وتخزينها في `feadState`. |
| `searchByLocation(lat, lng, radius)` | البحث الجغرافي وتحديث الـ `listState` بالنتائج. |
| `cloneOrganization(templateId, targetId)` | استنساخ إعدادات منظمة كاملة وتحديث القائمة عند النجاح. |
| `activateOrganization(id)` / `deactivateOrganization(id)` | تغيير حالة التفعيل بشكل فوري مع تحديث القائمة. |
| `deleteOrganization(id)` | حذف المنظمة نهائياً وتحديث الواجهة. |

### • مثال عملي للإحصائيات (Stats)
```dart
// في الواجهة
context.read<AdminOrganizationsBloc>().loadOrganizationStats();

// في الـ UI Builder
BlocBuilder<AdminOrganizationsBloc, FeaturDataSourceState<OrganizationModel>>(
  builder: (context, state) {
    return state.feadState.when(
      success: (stats) => Text("Total: ${stats.total}"),
      loading: () => CircularProgressIndicator(),
      error: (e) => Text("Error: ${e.message}"),
      init: () => SizedBox(),
    );
  },
);
```

---

> [!TIP]
> جميع العمليات في الـ Core Logic تعيد `RemoteBaseModel` الذي يحتوي على `StatusModel` (Success/Error) ورسالة الخطأ إن وجدت بشكل موحد.

> [!IMPORTANT]
> عند إنشاء منظمة جديدة، يفضل دائماً تمرير `templateOrgId` لضمان استنساخ الأدوار (Roles) ومسارات العمل (Workflows) الافتراضية تلقائياً.
