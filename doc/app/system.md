# دليل مطور الواجهة الأمامية (Frontend Developer Guide) - البيانات الأساسية (System Definitions)

هذا الدليل يوضح هيكلية البيانات (JSON) ونقاط النهاية (Endpoints) للدول، المحافظات، المدن، واللغات التي يعتمد عليها النظام.

---

## 1. اللغات (Languages)

### هيكل البيانات (JSON)
```json
{
  "code": "ar",
  "name": "Arabic",
  "nativeName": "العربية",
  "isDefault": true,
  "isActive": true,
  "direction": "rtl",
  "meta": {
    "createdAt": "2024-01-01T00:00:00Z"
  }
}
```

### نقاط النهاية (Endpoints)

| الوظيفة | الطريقة | المسار (Route) | الصلاحية |
| :--- | :--- | :--- | :--- |
| جلب كل اللغات المدعومة | `GET` | `/system/languages` | عام (Public) |
| إضافة لغة جديدة | `POST` | `/system/languages` | أدمن النظام |

---

## 2. الدول (Countries)

### هيكل البيانات (JSON)
```json
{
  "id": "EG",
  "name": {
    "ar": "مصر",
    "en": "Egypt"
  },
  "currency": "EGP",
  "phoneCode": "+20",
  "isActive": true
}
```

### نقاط النهاية (Endpoints)

| الوظيفة | الطريقة | المسار (Route) | الصلاحية |
| :--- | :--- | :--- | :--- |
| جلب كافة الدول النشطة | `GET` | `/locations/countries` | عام (Public) |

---

## 3. المحافظات (Governorates)

### هيكل البيانات (JSON)
```json
{
  "id": "cairo_id",
  "countryId": "EG",
  "name": {
    "ar": "القاهرة",
    "en": "Cairo"
  },
  "code": "CAI",
  "defaultShippingFee": 50,
  "isActive": true
}
```

### نقاط النهاية (Endpoints)

| الوظيفة | الطريقة | المسار (Route) | الصلاحية |
| :--- | :--- | :--- | :--- |
| جلب محافظات دولة معينة | `GET` | `/locations/countries/:countryId/governorates` | عام (Public) |
| جلب كافة المحافظات | `GET` | `/locations/governorates` | عام (Public) |

---

## 4. المدن (Cities)

### هيكل البيانات (JSON)
```json
{
  "id": "nasr_city_id",
  "governorateId": "cairo_id",
  "name": {
    "ar": "مدينة نصر",
    "en": "Nasr City"
  },
  "defaultShippingFee": 20,
  "isActive": true
}
```

### نقاط النهاية (Endpoints)

| الوظيفة | الطريقة | المسار (Route) | الصلاحية |
| :--- | :--- | :--- | :--- |
| جلب مدن محافظة معينة | `GET` | `/locations/governorates/:governorateId/cities` | عام (Public) |

---

## 5. معلومات النظام (System Information)

يُستخدم هذا القسم لمعرفة حالة النظام والتحقق مما إذا كان قد تمت تهيئته أم لا عند بداية تشغيل التطبيق.

### هيكل بيانات SystemInfo (JSON)
```json
{
  "appName": "Matger Pro",
  "orgName": "Main Org",
  "orgId": "org_id_123",
  "version": "1.0.0",
  "isBootstrapped": true,
  "defaultLanguage": "ar",
  "licenseKey": "MTGR-XXXX-YYYY",
  "licenseExpiryDate": "2025-12-31T23:59:59Z",
  "maintenanceMode": false,
  "logo": "url_to_logo_image"
}
```

### نقاط النهاية (Endpoints)

| الوظيفة | الطريقة | المسار (Route) | الملاحظات |
| :--- | :--- | :--- | :--- |
| جلب بيانات النظام | `GET` | `/system/info` | يُستخدم في الـ Splash Screen |

---

## 6. تهيئة النظام (System Bootstrap)

تتم هذه العملية مرة واحدة فقط عند تثبيت النظام لأول مرة.

### هيكل طلب التهيئة (BootstrapRequest)
```json
{
  "appName": "اسم التطبيق",
  "organizationName": "اسم المنظمة الرئيسية",
  "adminName": "اسم مدير النظام",
  "adminEmail": "admin@example.com",
  "adminPassword": "Password123!",
  "phone": "01000000000",
  "defaultLanguage": "ar",
  "licenseKey": "MTGR-PRO-LIC",
  "licenseExpiryDate": "2025-12-31",
  "logo": "ملف الصورة (اختياري)"
}
```

> [!IMPORTANT]
> **ملاحظة تقنية:** يجب إرسال طلب الـ Bootstrap بصيغة **`multipart/form-data`** لكي يتمكن النظام من استقبال ملف اللوجو.


### نقاط النهاية (Endpoints)

| الوظيفة | الطريقة | المسار (Route) | الملاحظات |
| :--- | :--- | :--- | :--- |
| تهيئة النظام لأول مرة | `POST` | `/system/bootstrap` | يتطلب `x-system-key` في الـ Header |

---

## 7. العمليات الإدارية (Seeding)

| الوظيفة | الطريقة | المسار (Route) | الملاحظات |
| :--- | :--- | :--- | :--- |
| تهيئة اللغات الافتراضية | `POST` | `/system/languages/seed` | يتطلب صلاحية أدمن |
| تهيئة بيانات المواقع | `POST` | `/locations/seed` | تهيئة الدول والمحافظات |

---

## 8. دليل التكامل البرمجي (Implementation Guide)

### استخدام الـ SystemRepo
يتم استدعاء خدمات النظام عبر الـ Service Locator (`sl`):

```dart
final systemRepo = sl<SystemRepo>();

// 1. التحقق من حالة النظام
final info = await systemRepo.getSystemInfo();
if (info.data?.isBootstrapped == false) {
  // التوجه لشاشة التهيئة
}

// 2. تهيئة النظام
await systemRepo.bootstrapSystem(bootstrapData, "MY_SYSTEM_KEY");
```

> [!IMPORTANT]
> يجب إرسال مفتاح النظام `x-system-key` في عملية الـ Bootstrap، وهو مفتاح سري يتم ضبطه في إعدادات السيرفر.

> [!NOTE]
> تم تحديث الكود الفعلي (Models, Sources, Repositories) وربطها في الـ `Locator` لتعمل بشكل متكامل مع هذه المسارات.
