import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matger_core_logic/repo_bloc/test_bloc.dart';
import 'package:matger_core_logic/repo_bloc/auth_bloc.dart';
import 'package:matger_core_logic/models/app_settings.dart';
import 'package:matger_core_logic/core/auth/data/user_model.dart';
import 'package:matger_core_logic/utls/bloc/data_source_bloc_builder.dart';
import 'package:flutter/services.dart';
import 'test_components.dart';

import 'package:matger_core_logic/utls/bloc/remote_base_model.dart';
import 'package:matger_core_logic/repo_bloc/storage_bloc.dart';
import 'package:matger_core_logic/repo_bloc/organization_bloc.dart';
import 'package:matger_core_logic/core/orgnization/data/organization_model.dart';
import 'package:matger_core_logic/utls/storage/storage_helper.dart';
import 'test_colors.dart';
import 'package:matger_core_logic/repo_bloc/category_bloc.dart';
import 'package:matger_core_logic/features/commrec/data/category_model.dart';
import 'package:matger_core_logic/utls/test_widgets/utils/image_picker_widget.dart';
import 'package:matger_core_logic/repo_bloc/product_bloc.dart';
import 'package:matger_core_logic/repo_bloc/order_bloc.dart';
import 'package:matger_core_logic/features/commrec/data/product_model.dart';
import 'package:matger_core_logic/features/commrec/data/order_model.dart';
import 'package:matger_core_logic/core/di/injection_container.dart';

enum LogicModule {
  system,
  auth,
  categories,
  products,
  orders,
  organizations,
  storage,
}

class LogicTesterApp extends StatelessWidget {
  const LogicTesterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logic Hub Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: TestColors.scaffoldBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TestColors.primary,
          brightness: Brightness.dark,
          surface: TestColors.surface,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const LogicDashboard(),
    );
  }
}

class LogicDashboard extends StatefulWidget {
  const LogicDashboard({super.key});

  @override
  State<LogicDashboard> createState() => _LogicDashboardState();
}

class _LogicDashboardState extends State<LogicDashboard> {
  final List<String> _logs = [];
  LogicModule _activeModule = LogicModule.system;
  bool _isTerminalVisible = true;

  @override
  void initState() {
    super.initState();
    _addLog("🚀 Multi-Module Logic Hub Active.");
    sl<TestBloc>().loadSettings();
  }

  void _addLog(String message) {
    setState(() {
      _logs.insert(
        0,
        "[${DateTime.now().toString().split(' ').last.split('.').first}] $message",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 110,
            decoration: const BoxDecoration(
              color: TestColors.sidebarBg,
              border: Border(right: BorderSide(color: TestColors.divider)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.hub_outlined,
                    color: TestColors.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 40),
                  TestNavIcon(
                    icon: Icons.dns_rounded,
                    label: "System",
                    isActive: _activeModule == LogicModule.system,
                    onTap: () =>
                        setState(() => _activeModule = LogicModule.system),
                  ),
                  TestNavIcon(
                    icon: Icons.lock_person_rounded,
                    label: "Auth",
                    isActive: _activeModule == LogicModule.auth,
                    onTap: () =>
                        setState(() => _activeModule = LogicModule.auth),
                  ),
                  TestNavIcon(
                    icon: Icons.category_rounded,
                    label: "Categories",
                    isActive: _activeModule == LogicModule.categories,
                    onTap: () =>
                        setState(() => _activeModule = LogicModule.categories),
                  ),
                  TestNavIcon(
                    icon: Icons.shopping_bag_rounded,
                    label: "Products",
                    isActive: _activeModule == LogicModule.products,
                    onTap: () =>
                        setState(() => _activeModule = LogicModule.products),
                  ),
                  TestNavIcon(
                    icon: Icons.receipt_long_rounded,
                    label: "Orders",
                    isActive: _activeModule == LogicModule.orders,
                    onTap: () =>
                        setState(() => _activeModule = LogicModule.orders),
                  ),
                  TestNavIcon(
                    icon: Icons.business_rounded,
                    label: "Organizations",
                    isActive: _activeModule == LogicModule.organizations,
                    onTap: () => setState(
                      () => _activeModule = LogicModule.organizations,
                    ),
                  ),
                  TestNavIcon(
                    icon: Icons.storage_rounded,
                    label: "Storage",
                    isActive: _activeModule == LogicModule.storage,
                    onTap: () {
                      setState(() => _activeModule = LogicModule.storage);
                      StorageBloc().loadStorageData();
                    },
                  ),
                  const SizedBox(height: 40),
                  IconButton(
                    onPressed: () => setState(() => _logs.clear()),
                    icon: const Icon(
                      Icons.cleaning_services_rounded,
                      color: TestColors.inactiveIcon,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Action Section
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: _buildCurrentModuleActions(),
                        ),
                      ),
                      // Inspector Section
                      Container(
                        width: 500,
                        height: double.infinity,
                        margin: const EdgeInsets.fromLTRB(0, 24, 24, 24),
                        decoration: BoxDecoration(
                          color: TestColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: TestColors.divider),
                        ),
                        child: _buildInspectorPanel(),
                      ),
                    ],
                  ),
                ),
                if (_isTerminalVisible) TestTerminalPanel(logs: _logs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: TestColors.scaffoldBg,
        border: Border(bottom: BorderSide(color: TestColors.divider)),
      ),
      child: Row(
        children: [
          const Icon(Icons.terminal_rounded, size: 18, color: Colors.white70),
          const SizedBox(width: 12),
          Text(
            _activeModule.name.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const Chip(
            label: Text("MODULAR V1", style: TextStyle(fontSize: 10)),
            backgroundColor: TestColors.primary,
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () =>
                setState(() => _isTerminalVisible = !_isTerminalVisible),
            icon: Icon(
              _isTerminalVisible
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded,
              color: _isTerminalVisible
                  ? TestColors.primary
                  : TestColors.inactiveIcon,
            ),
            tooltip: "Toggle Terminal",
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentModuleActions() {
    switch (_activeModule) {
      case LogicModule.system:
        return _buildGroup("SYSTEM ACTIONS", [
          TestActionCard(
            title: "Sync Config",
            desc: "Reload base system settings",
            icon: Icons.refresh,
            onTap: () => sl<TestBloc>().loadSettings(),
          ),
        ]);
      case LogicModule.categories:
        return _buildGroup("CATEGORY ACTIONS", [
          TestActionCard(
            title: "Create Category",
            desc: "Add a new category with an optional image",
            icon: Icons.add_photo_alternate_rounded,
            onTap: _showCreateCategoryDialog,
          ),
          TestActionCard(
            title: "Get Categories by Shop",
            desc: "Fetch categories for a shop ID",
            icon: Icons.list_alt_rounded,
            onTap: _showGetCategoriesDialog,
          ),
        ]);
      case LogicModule.products:
        return _buildGroup("PRODUCT ACTIONS", [
          TestActionCard(
            title: "Create Product",
            desc: "Add a new product",
            icon: Icons.add_shopping_cart_rounded,
            onTap: _showCreateProductDialog,
          ),
          TestActionCard(
            title: "Get Products",
            desc: "Fetch paginated products",
            icon: Icons.list_alt_rounded,
            onTap: () => ProductBloc().getProducts(),
          ),
        ]);
      case LogicModule.orders:
        return _buildGroup("ORDER ACTIONS", [
          TestActionCard(
            title: "Create Order",
            desc: "Add a new order",
            icon: Icons.shopping_cart_checkout_rounded,
            onTap: _showCreateOrderDialog,
          ),
          TestActionCard(
            title: "Get Shop Orders",
            desc: "Fetch orders by shop ID",
            icon: Icons.receipt_long_rounded,
            onTap: _showGetShopOrdersDialog,
          ),
        ]);
      case LogicModule.auth:
        return _buildGroup("AUTH ACTIONS", [
          TestActionCard(
            title: "Login Simulator",
            desc: "Auth flow simulation",
            icon: Icons.login,
            onTap: _showLoginDialog,
          ),
          TestActionCard(
            title: "Fetch Profile",
            desc: "Get user metadata using token",
            icon: Icons.person_search,
            onTap: () => AuthBloc().getProfile(),
          ),
        ]);
      case LogicModule.organizations:
        return _buildGroup("ORGANIZATION ACTIONS", [
          TestActionCard(
            title: "Create Org With Owner",
            desc: "Setup new organization and its owner",
            icon: Icons.business_rounded,
            onTap: _showCreateOrgDialog,
          ),
        ]);
      case LogicModule.storage:
        return _buildGroup("STORAGE MANAGEMENT", [
          TestActionCard(
            title: "Reload Storage",
            desc: "Sync UI with SharedPreferences",
            icon: Icons.sync_rounded,
            onTap: () => StorageBloc().loadStorageData(),
          ),
          TestActionCard(
            title: "Clear All Prefs",
            desc: "Wipe all local storage data",
            icon: Icons.delete_forever_rounded,
            onTap: () async {
              await StorageBloc().clearAll();
              _addLog("Local storage wiped clean.");
            },
          ),
        ]);
    }
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: Colors.white54,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }

  Widget _buildInspectorPanel() {
    return SingleChildScrollView(
      // Prevent RenderFlex overflow
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              "INSPECTOR",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 10,
                color: TestColors.primary,
              ),
            ),
          ),
          IndexedStack(
            index: _getModuleIndex(_activeModule),
            children: [
              // 0: System
              DataSourceBlocBuilder<AppSettings>(
                bloc: sl<TestBloc>().settingsBloc,
                success: (data) => _buildResultList(data?.toJson()),
                loading: () => _buildLoading(),
                failure: _buildErrorView,
              ),

              // 1: Auth (Displays Login Data + Profile)
              Column(
                children: [
                  DataSourceBlocBuilder<Map<String, dynamic>>(
                    bloc: AuthBloc().loginBloc,
                    success: (data) => _buildResultList(data),
                    loading: () => _buildLoading(),
                    failure: _buildErrorView,
                  ),
                  const Divider(color: Colors.white10),
                  DataSourceBlocBuilder<UserModel>(
                    bloc: AuthBloc().profileBloc,
                    success: (data) => _buildResultList(data?.toJson()),
                    loading: () => _buildLoading(),
                    failure: _buildErrorView,
                  ),
                ],
              ),

              // 2: Storage
              DataSourceBlocBuilder<Map<String, dynamic>>(
                bloc: StorageBloc().storageDataBloc,
                success: (data) => _buildResultList(data),
                loading: () => _buildLoading(),
                failure: _buildErrorView,
              ),

              // 3: Organizations
              DataSourceBlocBuilder<OrganizationData>(
                bloc: OrganizationBloc().createOrgBloc,
                success: (data) => _buildResultList(data?.toJson()),
                loading: () => _buildLoading(),
                failure: _buildErrorView,
              ),

              // 4: Categories
              Column(
                children: [
                  DataSourceBlocBuilder<CategoryData>(
                    bloc: CategoryBloc().categoryDataBloc,
                    success: (data) => _buildResultList(data?.toJson()),
                    loading: () => _buildLoading(),
                    failure: _buildErrorView,
                  ),
                  const Divider(color: Colors.white10),
                  DataSourceBlocBuilder<List<CategoryData>>(
                    bloc: CategoryBloc().categoriesListBloc,
                    success: (data) {
                      final m = {
                        "count": data?.length,
                        "items": data?.map((e) => e.toJson()).toList(),
                      };
                      return _buildResultList(m);
                    },
                    loading: () => _buildLoading(),
                    failure: _buildErrorView,
                  ),
                ],
              ),
              // 5: Products
              Column(
                children: [
                  DataSourceBlocBuilder<ProductData>(
                    bloc: ProductBloc().productDataBloc,
                    success: (data) => _buildResultList(data?.toJson()),
                    loading: () => _buildLoading(),
                    failure: _buildErrorView,
                  ),
                  const Divider(color: Colors.white10),
                  DataSourceBlocBuilder<List<ProductData>>(
                    bloc: ProductBloc().productsListBloc,
                    success: (data) {
                      final m = {
                        "count": data?.length,
                        "items": data?.map((e) => e.toJson()).toList(),
                      };
                      return _buildResultList(m);
                    },
                    loading: () => _buildLoading(),
                    failure: _buildErrorView,
                  ),
                ],
              ),

              // 6: Orders
              Column(
                children: [
                  DataSourceBlocBuilder<OrderData>(
                    bloc: OrderBloc().orderDataBloc,
                    success: (data) => _buildResultList(data?.toJson()),
                    loading: () => _buildLoading(),
                    failure: _buildErrorView,
                  ),
                  const Divider(color: Colors.white10),
                  DataSourceBlocBuilder<List<OrderData>>(
                    bloc: OrderBloc().ordersListBloc,
                    success: (data) {
                      final m = {
                        "count": data?.length,
                        "items": data?.map((e) => e.toJson()).toList(),
                      };
                      return _buildResultList(m);
                    },
                    loading: () => _buildLoading(),
                    failure: _buildErrorView,
                  ),
                ],
              ),
            ],
          ),
          _buildRawJsonForModule(),
        ],
      ),
    );
  }

  Widget _buildRawJsonForModule() {
    switch (_activeModule) {
      case LogicModule.auth:
        return TestRawResultBox(
          bloc: AuthBloc().loginBloc,
          title: "AUTH RAW RESPONSE",
        );
      case LogicModule.categories:
        return TestRawResultBox(
          bloc: CategoryBloc().rawDataBloc,
          title: "CATEGORY RAW RESPONSE",
        );
      case LogicModule.organizations:
        return TestRawResultBox(
          bloc: OrganizationBloc().rawDataBloc,
          title: "ORG RAW RESPONSE",
        );
      case LogicModule.products:
        return TestRawResultBox(
          bloc: ProductBloc().rawDataBloc,
          title: "PRODUCT RAW RESPONSE",
        );
      case LogicModule.orders:
        return TestRawResultBox(
          bloc: OrderBloc().rawDataBloc,
          title: "ORDER RAW RESPONSE",
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildResultList(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.layers_clear_outlined,
                size: 40,
                color: Colors.white10,
              ),
              SizedBox(height: 16),
              Text(
                "No Data Available",
                style: TextStyle(color: Colors.white24, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    // Flatten keys if nested to show everything in one list
    final Map<String, dynamic> flattenedData = {};
    void flatten(Map<String, dynamic> source, {String prefix = ""}) {
      source.forEach((key, value) {
        final newKey = prefix.isEmpty ? key : "$prefix ❯ $key";
        if (value is Map<String, dynamic>) {
          flatten(value, prefix: newKey);
        } else if (value is List) {
          flattenedData[newKey] = value.join(", ");
        } else {
          flattenedData[newKey] = value;
        }
      });
    }

    flatten(data);

    return ListView(
      padding: const EdgeInsets.all(24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: flattenedData.entries
          .map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.key.toUpperCase(),
                          style: const TextStyle(
                            color: TestColors.inactiveText,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          "${e.value}",
                          style: const TextStyle(
                            color: TestColors.textAcent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: e.value.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${e.key.split('❯').last.trim()} copied",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.copy_rounded,
                      size: 14,
                      color: Colors.white24,
                    ),
                    tooltip: "Copy Value",
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  void _showLoginDialog() {
    final lastCreds = StorageHelper.getLastCredentials();
    final u = TextEditingController(text: lastCreds["username"]);
    final p = TextEditingController(text: lastCreds["password"]);
    bool isObscure = true;

    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Authentication Trigger"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: u,
                  decoration: const InputDecoration(
                    labelText: "User",
                    hintText: "admin",
                  ),
                ),
                TextField(
                  controller: p,
                  decoration: InputDecoration(
                    labelText: "Pass",
                    hintText: "Password@123",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                        color: Colors.white24,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: isObscure,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text("CANCEL"),
              ),
              ElevatedButton(
                onPressed: () {
                  final user = u.text.isEmpty ? "admin" : u.text;
                  final pass = p.text.isEmpty ? "Password@123" : p.text;

                  // Save credentials for next time
                  StorageHelper.saveLastCredentials(user, pass);

                  _addLog("Dispatching Login Tool...");
                  AuthBloc().login(user, pass);
                  Navigator.pop(c);
                },
                child: const Text("DISPATCH"),
              ),
            ],
          );
        },
      ),
    );
  }

  int _getModuleIndex(LogicModule module) {
    switch (module) {
      case LogicModule.system:
        return 0;
      case LogicModule.storage:
        return 2;
      case LogicModule.organizations:
        return 3;
      case LogicModule.categories:
        return 4;
      case LogicModule.products:
        return 5;
      case LogicModule.orders:
        return 6;
      case LogicModule.auth:
        return 1;
    }
  }

  void _showCreateOrgDialog() {
    final usernameController = TextEditingController(text: "new_owner");
    final emailController = TextEditingController(text: "owner@example.com");
    final passwordController = TextEditingController(text: "Password@123");
    final phoneController = TextEditingController(text: "+201112223334");
    final nameController = TextEditingController(text: "Organization Owner");
    final addressController = TextEditingController(text: "Cairo, Egypt");

    final orgNameController = TextEditingController(
      text: "New Organization Name",
    );
    final orgAddressController = TextEditingController(text: "Cairo, Egypt");
    final orgPhoneController = TextEditingController(text: "+201112223334");
    final orgEmailController = TextEditingController(text: "org@example.com");

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Create Organization With Owner"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "User Data",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              const Divider(),
              const Text(
                "Organization Data",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: orgNameController,
                decoration: const InputDecoration(labelText: "Org Name"),
              ),
              TextField(
                controller: orgAddressController,
                decoration: const InputDecoration(labelText: "Org Address"),
              ),
              TextField(
                controller: orgPhoneController,
                decoration: const InputDecoration(labelText: "Org Phone"),
              ),
              TextField(
                controller: orgEmailController,
                decoration: const InputDecoration(labelText: "Org Email"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              OrganizationBloc().createOrganizationWithOwner(
                userData: {
                  "username": usernameController.text,
                  "email": emailController.text,
                  "password": passwordController.text,
                  "phone": phoneController.text,
                  "name": nameController.text,
                  "address": addressController.text,
                },
                organizationData: OrganizationData(
                  organizationId: "",
                  name: orgNameController.text,
                  ownerId: "",
                  address: orgAddressController.text,
                  phone: orgPhoneController.text,
                  email: orgEmailController.text,
                  location: LocationData(latitude: 30.0444, longitude: 31.2357),
                ),
              );
              Navigator.pop(c);
              _addLog("Creating Organization: ${orgNameController.text}");
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(ErrorStateModel error, VoidCallback callback) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "SERVER ERROR",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    error.message ?? "An unexpected error occurred",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: callback,
              style: ElevatedButton.styleFrom(
                backgroundColor: TestColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                "TRY AGAIN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() => const Center(
    child: CircularProgressIndicator(strokeWidth: 2, color: TestColors.primary),
  );

  void _showCreateCategoryDialog() {
    final nameController = TextEditingController(text: "New Category");
    final descController = TextEditingController(text: "Category Description");
    final shopIdController = TextEditingController(text: "shop_123");
    ImageFileModel? selectedImage;

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Create Category"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Category Name"),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: shopIdController,
                decoration: const InputDecoration(labelText: "Shop ID"),
              ),
              const SizedBox(height: 16),
              const Text(
                "Category Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ImagePecker(
                placeholderAsset:
                    "assets/placeholder.png", // Ensure you have a placeholder or handle it
                height: 150,
                width: 150,
                backgroundColor: TestColors.surface,
                iconColor: TestColors.primary,
                enableCrop: false,
                onImageSelected: (imageModel) {
                  selectedImage = imageModel;
                  _addLog(
                    "Image selected for category: ${imageModel.readableFileSize}",
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              CategoryBloc().createCategory(
                name: nameController.text,
                shopId: shopIdController.text,
                description: descController.text,
                imageBytes: selectedImage?.bytes,
                imageName: selectedImage?.xFile?.name,
              );
              Navigator.pop(c);
              _addLog("Creating Category: ${nameController.text}");
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void _showGetCategoriesDialog() {
    final shopIdController = TextEditingController(text: "shop_123");
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Get Categories By Shop"),
        content: TextField(
          controller: shopIdController,
          decoration: const InputDecoration(labelText: "Shop ID"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              CategoryBloc().getCategoriesByShop(shopIdController.text);
              Navigator.pop(c);
              _addLog("Fetching categories for shop: ${shopIdController.text}");
            },
            child: const Text("Fetch"),
          ),
        ],
      ),
    );
  }

  void _showCreateProductDialog() {
    final nameController = TextEditingController(text: "New Product");
    final categoryIdController = TextEditingController(text: "cat_123");
    final shopIdController = TextEditingController(text: "shop_123");
    final priceController = TextEditingController(text: "99.99");
    ImageFileModel? selectedImage;

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Create Product"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Product Name"),
              ),
              TextField(
                controller: categoryIdController,
                decoration: const InputDecoration(labelText: "Category ID"),
              ),
              TextField(
                controller: shopIdController,
                decoration: const InputDecoration(labelText: "Shop ID"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                "Product Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ImagePecker(
                placeholderAsset: "assets/placeholder.png",
                height: 150,
                width: 150,
                backgroundColor: TestColors.surface,
                iconColor: TestColors.primary,
                enableCrop: false,
                onImageSelected: (imageModel) {
                  selectedImage = imageModel;
                  _addLog(
                    "Image selected for product: ${imageModel.readableFileSize}",
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              ProductBloc().createProduct(
                name: nameController.text,
                categoryId: categoryIdController.text,
                shopId: shopIdController.text,
                price: double.tryParse(priceController.text) ?? 0.0,
                imageBytes: selectedImage?.bytes,
                imageName: selectedImage?.xFile?.name,
              );
              Navigator.pop(c);
              _addLog("Creating Product: ${nameController.text}");
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void _showCreateOrderDialog() {
    final orgIdController = TextEditingController(text: "shop_123");
    final totalAmountController = TextEditingController(text: "250.0");

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Create Order"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: orgIdController,
                decoration: const InputDecoration(labelText: "Organization ID"),
              ),
              TextField(
                controller: totalAmountController,
                decoration: const InputDecoration(labelText: "Total Amount"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              OrderBloc().createOrder(
                organizationId: orgIdController.text,
                totalAmount: double.tryParse(totalAmountController.text) ?? 0.0,
                items: [
                  OrderItemData(productId: "prod_1", quantity: 2, price: 100),
                  OrderItemData(productId: "prod_2", quantity: 1, price: 50),
                ],
              );
              Navigator.pop(c);
              _addLog("Creating Order...");
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void _showGetShopOrdersDialog() {
    final shopIdController = TextEditingController(text: "shop_123");
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Get Orders By Shop"),
        content: TextField(
          controller: shopIdController,
          decoration: const InputDecoration(labelText: "Shop ID"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              OrderBloc().getShopOrders(shopIdController.text);
              Navigator.pop(c);
              _addLog("Fetching orders for shop: ${shopIdController.text}");
            },
            child: const Text("Fetch"),
          ),
        ],
      ),
    );
  }
}
