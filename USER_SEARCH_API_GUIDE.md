# (User Search API) - Front-end Documentation

هذا التوثيق موجه لفريق تطوير الواجهة الأمامية (Front-end) لاستخدام نقاط البحث الجديدة التي تم دمجها وتحسينها في النظام.

---

## 1. نظرة عامة (Overview)
تم إضافة دعم للبحث عن المستخدمين بطريقتين:
1.  **بحث شامل (Global Search):** للبحث في كافة المستخدمين (للمسؤولين).
2.  **بحث داخل منظمة (Organization Search):** للبحث عن الموظفين داخل منظمة محددة.

**ملاحظات هامة:**
*   البحث ليس شرطاً أن يكون متطابقاً تماماً (Partial Search).
*   تم إلغاء قيود الحد الأدنى للحروف؛ يمكنك البحث بحرف واحد أو حتى إرسال بحث فارغ لجلب القائمة الكاملة.
*   يتطلب التوثيق الأمني وجود `Authorization: Bearer {{token}}` (يتم التعامل معه تلقائياً في `UserSource`).

---

## 2. المسارات (Endpoints)

| الوصف | المسار (Endpoint) | الطريقة (Method) | المعلمات (Query Params) |
| :--- | :--- | :--- | :--- |
| البحث العام عن المستخدمين | `/profiles/search` | `GET` | `term` (اختياري) |
| البحث داخل منظمة | `/profiles/organization/:organizationId/search` | `GET` | `term` (اختياري) |

---

## 3. الاستخدام من خلال `UserRepo`

تم توفير الطريقتين في `UserRepo` لسهولة الوصول إليهما من خلال الـ BLoC أو الـ View.

### أ. البحث العام (Global Search)
```dart
final result = await userRepo.searchProfiles(term: 'moaz');

if (result.status == StatusModel.success) {
  List<UserProfileModel> users = result.data;
  // تعامل مع قائمة المستخدمين
} else {
  // تعامل مع الخطأ
}
```

### ب. البحث داخل منظمة (Organization Search)
```dart
final result = await userRepo.searchProfilesInOrg(
  organizationId: '65f12345abcde6789',
  term: 'emp',
);

if (result.status == StatusModel.success) {
  List<UserProfileModel> employees = result.data;
  // تعامل مع قائمة الموظفين
}
```

---

## 4. الفئات المستخدمة (Classes Reference)

### `UserSource`
*   `searchProfiles({String? term})`
*   `searchProfilesInOrg({required String organizationId, String? term})`

### `UserRepo`
*   `searchProfiles({String? term})`
*   `searchProfilesInOrg({required String organizationId, String? term})`

---

## 5. الصلاحيات المطلوبة (Permissions)
يجب أن يمتلك المستخدم الصلاحيات التالية في التوكن الخاص به:
*   **Feature:** `user`
*   **Job:** `read` (أو `user:*` أو `*:*`).

---

## 6. منطق الاستجابة (Response Logic)
*   في حال وجود نتائج: ستعود مصفوفة تحتوي على بيانات المستخدمين (`UserProfileModel`).
*   في حال عدم وجود نتائج: ستعود مصفوفة فارغة `[]` مع رسالة نجاح.
