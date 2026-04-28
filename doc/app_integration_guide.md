# Integration Guide: Commercial & Workflow Repositories

This guide details how to interact with the core logic for Products and Workflow in the Matger Pro application. It outlines the repository methods, required request models, and return types.

---

## 1. Product Module (`ProductRepo`)

### 1.1 Standard CRUD Operations
| Method | Input Data | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `createProduct` | Single fields (name, price, etc.) | `RemoteBaseModel<ProductData>` | Create a new product with optional images. |
| `updateProduct` | `Map<String, dynamic> data` | `RemoteBaseModel<ProductData>` | Update specific fields of a product. |
| `deleteProduct` | `String productId` | `RemoteBaseModel<bool>` | Delete a product instance. |
| `getProducts` | `page`, `limit` | `RemoteBaseModel<List<ProductData>>` | Paginated product list. |

### 1.2 Bulk & Advanced Operations
| Method | Input Model | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `bulkCreateProducts` | `BulkCreateProductsRequest` | `RemoteBaseModel<List<ProductData>>` | Create multiple products in one request. |
| `bulkUpdateProducts` | `BulkUpdateProductsRequest` | `RemoteBaseModel<List<ProductData>>` | Update multiple products (e.g., change price for a set). |
| `bulkVariants` | `BulkVariantsRequest` | `RemoteBaseModel<List<ProductData>>` | Generate variants from a template product. |
| `sharedPricingApply`| `SharedPricingRequest` | `RemoteBaseModel<bool>` | Apply price options to multiple products. |

---

## 2. Workflow Module (`WorkflowRepo`)

### 2.1 Execution & Tracking
| Method | Input Model / Data | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `performAction` | `WorkflowExecuteActionRequest` | `RemoteBaseModel<dynamic>` | Execute a transition (Approve, Reject, etc.). |
| `getStatus` | `entityType`, `entryId` | `RemoteBaseModel<dynamic>` | Get current step and available actions. |
| `claimTask` | `WorkflowClaimTaskRequest` | `RemoteBaseModel<dynamic>` | Take ownership of a claimable task. |
| `assignTask` | `WorkflowAssignTaskRequest` | `RemoteBaseModel<dynamic>` | (Admin) Assign task to a user. |

### 2.2 Management
| Method | Input Model | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `seedConfig` | `WorkflowSeedRequest` | `RemoteBaseModel<dynamic>` | Initialize default workflow for an organization. |
| `createConfig` | `WorkflowConfigRequest` | `RemoteBaseModel<dynamic>` | Define full custom workflow structure. |

---

## 3. Request Models Reference

These classes are used to structure the data sent to the repository. They are located in `lib/features/commrec/request_body/` and `lib/features/workflow/request_body/`.

### Product Request Bodies
- **`BulkCreateProductsRequest`**:
  - `organizationId`: String
  - `products`: `List<ProductData>`
- **`BulkUpdateProductsRequest`**:
  - `organizationId`: String
  - `productIds`: `List<String>`
  - `updateData`: `Map<String, dynamic>` (e.g., `{'price': 150}`)
- **`SharedPricingRequest`**:
  - `organizationId`: String
  - `productIds`: `List<String>`
  - `priceOptions`: `List<PriceOption>`
  - `mode`: String (`'replace'` or `'merge'`)

### Workflow Request Bodies
- **`WorkflowExecuteActionRequest`**:
  - `actionName`: String (e.g., `'approve'`)
  - `expectedStepNumber`: int? (Validation check)
  - `targetUserId`: String? (For explicit next-step assignment)
- **`WorkflowAssignTaskRequest`**:
  - `targetUserId`: String (Required)
  - `expectedStepNumber`: int? 

---

## 4. Usage Examples (Dart Code)

### Example: Updating Prices in Bulk
```dart
final repo = ProductRepo();

final request = BulkUpdateProductsRequest(
  organizationId: "ORG_123",
  productIds: ["PROD_A", \"PROD_B\"],
  updateData: {\"price\": 200.0, \"isOnSale\": true},
);

final result = await repo.bulkUpdateProducts(request: request);

if (result.status == StatusModel.success) {\n  print(\"Products updated: ${result.data?.length}\");
} else {
  print(\"Error: ${result.message}\");
}
```

### Example: Approving an Order (Workflow)
```dart
final workflowRepo = WorkflowRepo();

final action = WorkflowExecuteActionRequest(
  actionName: "approve",
  expectedStepNumber: 1,
);

final result = await workflowRepo.performAction(
  entityType: "orders",
  entryId: "ORDER_ID_789",
  request: action,
);

if (result.status == StatusModel.success) {
  // Trigger UI refresh or snackbar
}
```
