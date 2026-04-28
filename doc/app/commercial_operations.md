# دليل مطور الواجهة الأمامية (Frontend Developer Guide) - العمليات التجارية والطلبات

هذا الدليل يوضح هيكلية البيانات (JSON)، نقاط النهاية (Endpoints)، والصلاحيات المطلوبة للمنتجات، الأصناف، العروض، والطلبات.

---

## 1. الأصناف (Categories)

### هيكل البيانات (JSON)
```json
{
  "id": "cat_unique_id",
  "name": { "ar": "إلكترونيات", "en": "Electronics" },
  "description": { "ar": "منتجات إلكترونية", "en": "Electronic products" },
  "organizationId": "org_id",
  "imageUrl": "url_to_image",
  "displayOrder": 1,
  "isActive": true,
  "productCount": 15,
  "meta": { "createdAt": "..." }
}
```

### نقاط النهاية والصلاحيات (Endpoints & Permissions)

| الوظيفة | الطريقة | المسار (Route) | الصلاحية المطلوبة |
| :--- | :--- | :--- | :--- |
| جلب كافة الأصناف النشطة | `GET` | `/categories/active` | عام (Public) |
| جلب أصناف منظمة معينة | `GET` | `/categories/organization/:orgId` | عام (Public) |
| إنشاء صنف جديد | `POST` | `/categories` | `category:add` |
| تحديث صنف | `PUT` | `/categories/:id` | `category:update` |
| حذف صنف (Soft Delete) | `DELETE` | `/categories/:id` | `category:delete` |

---

## 2. المنتجات (Products)

### هيكل البيانات (JSON)
```json
{
  "id": "prod_unique_id",
  "name": { "ar": "اسم المنتج", "en": "Product Name" },
  "price": 100,
  "oldPrice": 120,
  "discount": 15,
  "stockQuantity": 50,
  "categoryId": "cat_id",
  "organizationId": "org_id",
  "images": ["url1", "url2"],
  "priceOptions": [
    { 
      "unit": "kg", 
      "quantity": 1, 
      "price": 100, 
      "oldPrice": 120,
      "isDefault": true,
      "sizeDisplay": { "ar": "كيلو", "en": "KG" } 
    }
  ],
  "isActive": true,
  "isAvailable": true,
  "isNew": true,
  "isBestSeller": false,
  "isOnSale": true,
  "isJoker": false,
  "isSuperJoker": false,
  "rating": 4.5,
  "additionalData": {
    "description": { "ar": "وصف المنتج التفصيلي", "en": "Detailed product description" }
  },
  "meta": { "createdAt": "..." }
}
```

### نقاط النهاية والصلاحيات (Endpoints & Permissions)

| الوظيفة | الطريقة | المسار (Route) | الصلاحية المطلوبة |
| :--- | :--- | :--- | :--- |
| جلب قائمة المنتجات (Pagination) | `GET` | `/products` | عام (Public) |
| البحث عن المنتجات | `GET` | `/products/search` | عام (Public) |
| جلب منتجات صنف معين | `GET` | `/products/category/:catId` | عام (Public) |
| إنشاء منتج (مع صور) | `POST` | `/products` | `product:add` |
| تحديث منتج | `PUT` | `/products/:id` | `product:update` |
| تحديث المخزون فقط | `PATCH` | `/products/:id/stock` | `product:update` |
| حذف منتج | `DELETE` | `/products/:id` | `product:delete` |

---

## 3. العروض (Offers)

### هيكل البيانات (JSON)
```json
{
  "id": "offer_unique_id",
  "name": { "ar": "عرض العيد", "en": "Eid Offer" },
  "description": { "ar": "خصومات هائلة", "en": "Huge discounts" },
  "imageUrl": "url_to_banner",
  "targetType": "product", 
  "targetId": "prod_or_cat_id",
  "targetName": "اسم المنتج المستهدف",
  "discountPercentage": 20,
  "startDate": "2024-04-10T00:00:00Z",
  "endDate": "2024-04-20T00:00:00Z",
  "isActive": true,
  "isValid": true,
  "sortOrder": 0
}
```

### نقاط النهاية والصلاحيات (Endpoints & Permissions)

| الوظيفة | الطريقة | المسار (Route) | الصلاحية المطلوبة |
| :--- | :--- | :--- | :--- |
| جلب عروض منظمة معينة | `GET` | `/offers/organization/:orgId` | عام (Public) |
| إنشاء عرض جديد | `POST` | `/offers` | `offer:add` |
| تحديث عرض | `PUT` | `/offers/:id` | `offer:update` |
| حذف عرض | `DELETE` | `/offers/:id` | `offer:delete` |

---

## 4. الطلبات (Orders)

### هيكل البيانات (JSON)
```json
{
  "id": "order_unique_id",
  "organizationId": "org_id",
  "senderDetails": { "name": "أحمد", "phone": "010...", "address": "..." },
  "recipientDetails": { "name": "محمد", "phone": "011...", "address": "..." },
  "items": [
    { "id": "prod_id", "name": "منتج 1", "quantity": 2, "unitPrice": 50, "totalPrice": 100 }
  ],
  "totalOrderPrice": 100,
  "orderMode": "C2B",
  "status": "pending",
  "workFlow": {
    "currentStepIndex": 0,
    "stepInfo": { "stepKey": "pending", "stepName": { "ar": "قيد الانتظار" } }
  }
}
```

### نقاط النهاية والصلاحيات (Endpoints & Permissions)

| الوظيفة | الطريقة | المسار (Route) | الصلاحية المطلوبة |
| :--- | :--- | :--- | :--- |
| إنشاء طلب جديد | `POST` | `/orders/:orgId` | `order:add` |
| جلب بيانات طلب معين | `GET` | `/orders/:orderId` | `order:read` |
| تتبع حالة الطلب | `GET` | `/workflow/orders/:orderId/status` | `orders:read` |
| تنفيذ إجراء على الطلب (تغيير حالة) | `PUT` | `/workflow/orders/:orderId` | `orders:workflowAction` |

---

> [!NOTE]
> تم تحديث الكود الفعلي (Models, Sources, Repositories) ليتطابق مع هذا التوثيق.
