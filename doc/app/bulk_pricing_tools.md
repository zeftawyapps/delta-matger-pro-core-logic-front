# دليل العمليات الجماعية وأدوات تتوحيد الأسعار (Bulk Operations & Pricing Tools)

يوفر هذا الدليل شرحاً لنقاط النهاية (Endpoints) المتقدمة التي تسمح بإدارة كميات كبيرة من المنتجات أو تحديث الأسعار بشكل موحد للمنظمة، مع توضيح **جسم الطلب (Request Body)** لكل عملية.

---

## 1. العمليات الجماعية للمنتجات (Bulk Product Operations)

| الوظيفة | الطريقة | المسار (Route) | جسم الطلب (Request Body) |
| :--- | :--- | :--- | :--- |
| إنشاء منتجات متعددة | `POST` | `/api/v1/products/bulk` | `[ { "productId": "p1", "name": { "ar": "منتج 1" }, ... }, { ... } ]` |
| تحديث جماعي للمنتجات | `PATCH` | `/api/v1/products/bulk/update` | `[ { "productId": "p1", "price": 120 }, { "productId": "p2", "stockQuantity": 10 } ]` |
| حذف جماعي للمنتجات | `DELETE` | `/api/v1/products/bulk/delete` | `{ "productIds": ["p1", "p2", "p3"] }` |
| إنشاء مشتقات جماعية | `POST` | `/api/v1/products/bulk-variants` | `{ "template": { "price": 100, "categoryId": "cat1" }, "variantNames": ["أحمر", "أزرق"] }` |

---

## 2. أدوات توحيد وتحديث الأسعار (Shared Pricing Tools)

| الوظيفة | الطريقة | المسار (Route) | جسم الطلب (Request Body) |
| :--- | :--- | :--- | :--- |
| معالجة الأسعار (Preview) | `POST` | `/api/v1/products/shared-pricing/preview` | `{ "productIds": ["p1", "p2"], "priceOptions": [...], "mode": "replace" }` |
| تطبيق السعر الموحد | `POST` | `/api/v1/products/shared-pricing/apply` | `{ "productIds": ["p1", "p2"], "priceOptions": [...], "mode": "replace" }` |

### تفاصيل كائن خيارات السعر (Price Options Object):
```json
{
  "unit": "100ml",
  "price": 50,
  "oldPrice": 60,
  "quantity": 1,
  "isDefault": true,
  "sizeDisplay": { "ar": "١٠٠ ملي" }
}
```

---

> [!NOTE]
> تم تنفيذ كافة الدوال المطلوبة وتحديث النماذج (`Models`) لضمان إرسال `productId` بشكل صحيح في العمليات الجماعية بما يتوافق مع جسم الطلب المطلوب.
