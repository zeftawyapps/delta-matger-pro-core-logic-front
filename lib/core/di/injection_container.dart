import 'package:get_it/get_it.dart';

// Auth Imports
import 'package:matger_pro_core_logic/core/auth/repos/auth_repo.dart';
import 'package:matger_pro_core_logic/core/auth/source/auth_source.dart';
import 'package:matger_pro_core_logic/core/auth/repos/test_repo.dart';
import 'package:matger_pro_core_logic/core/auth/source/test_page_source.dart';

// Organization Imports
import 'package:matger_pro_core_logic/core/orgnization/repo/organization_repo.dart';
import 'package:matger_pro_core_logic/core/orgnization/source/organization_source.dart';

// Commerce Imports (Category, Order, Product)
import 'package:matger_pro_core_logic/features/commrec/repo/category_repo.dart';
import 'package:matger_pro_core_logic/features/commrec/source/category_source.dart';
import 'package:matger_pro_core_logic/features/commrec/repo/order_repo.dart';
import 'package:matger_pro_core_logic/features/commrec/source/order_source.dart';
import 'package:matger_pro_core_logic/features/commrec/repo/product_repo.dart';
import 'package:matger_pro_core_logic/features/commrec/source/product_source.dart';
import 'package:matger_pro_core_logic/features/commrec/repo/offer_repo.dart';
import 'package:matger_pro_core_logic/features/commrec/source/offer_source.dart';

// Roles Imports
import 'package:matger_pro_core_logic/features/roles/source/role_source.dart';
import 'package:matger_pro_core_logic/features/roles/repo/role_repo.dart';

// Users Imports
import 'package:matger_pro_core_logic/features/users/source/user_source.dart';
import 'package:matger_pro_core_logic/features/users/repo/user_repo.dart';

// Locations Imports
import 'package:matger_pro_core_logic/features/locations/source/location_source.dart';
import 'package:matger_pro_core_logic/features/locations/repo/location_repo.dart';

// System Imports
import 'package:matger_pro_core_logic/core/system/source/system_source.dart';
import 'package:matger_pro_core_logic/core/system/repo/system_repo.dart';

// Workflow Imports
import 'package:matger_pro_core_logic/features/workflow/source/workflow_source.dart';
import 'package:matger_pro_core_logic/features/workflow/repo/workflow_repo.dart';

final GetIt sl = GetIt.instance; // sl stands for Service Locator

Future<void> initCoreLocator() async {
  // ==========================================
  // 1. Data Sources
  // ==========================================

  // Auth Source
  sl.registerLazySingleton<AuthSource>(() => AuthSource());
  sl.registerLazySingleton<TestPageSource>(() => TestPageSource());

  // Organization Source
  sl.registerLazySingleton<OrganizationSource>(() => OrganizationSource());

  // Commerce Sources
  sl.registerLazySingleton<CategorySource>(() => CategorySource());
  sl.registerLazySingleton<OrderSource>(() => OrderSource());
  sl.registerLazySingleton<ProductSource>(() => ProductSource());
  sl.registerLazySingleton<OfferSource>(() => OfferSource());
  sl.registerLazySingleton<LocationSource>(() => LocationSource());
  sl.registerLazySingleton<WorkflowSource>(() => WorkflowSource());
  sl.registerLazySingleton<SystemSource>(() => SystemSource());

  // ==========================================
  // 2. Repositories
  // ==========================================

  // Auth Repo
  sl.registerLazySingleton<AuthRepo>(() => AuthRepo(authSource: sl()));
  sl.registerLazySingleton<TestRepo>(() => TestRepo(landingPageSource: sl()));

  // Organization Repo
  sl.registerLazySingleton<OrganizationRepo>(
    () => OrganizationRepo(organizationSource: sl()),
  );

  // Commerce Repos
  sl.registerLazySingleton<CategoryRepo>(
    () => CategoryRepo(categorySource: sl()),
  );
  sl.registerLazySingleton<OrderRepo>(() => OrderRepo(orderSource: sl()));
  sl.registerLazySingleton<ProductRepo>(() => ProductRepo(productSource: sl()));
  sl.registerLazySingleton<OfferRepo>(() => OfferRepo(offerSource: sl()));
  sl.registerLazySingleton<LocationRepo>(
    () => LocationRepo(locationSource: sl()),
  );
  sl.registerLazySingleton<WorkflowRepo>(
    () => WorkflowRepo(source: sl()),
  );

  // Roles & Users Sources
  sl.registerLazySingleton<RoleSource>(() => RoleSource());
  sl.registerLazySingleton<UserSource>(() => UserSource());

  // Roles & Users Repos
  sl.registerLazySingleton<RoleRepo>(() => RoleRepo(roleSource: sl()));
  sl.registerLazySingleton<UserRepo>(() => UserRepo(userSource: sl()));

  // System Repo
  sl.registerLazySingleton<SystemRepo>(() => SystemRepo(systemSource: sl()));
}
