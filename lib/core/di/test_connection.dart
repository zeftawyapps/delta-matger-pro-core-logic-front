import 'package:matger_pro_core_logic/core/di/injection_container.dart';
import 'package:matger_pro_core_logic/core/auth/repos/auth_repo.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';

/// ملف مخصص لاختبار الاتصال بالباك إند (API) بدون الحاجة لواجهة مستخدم (UI)
/// يمكنك تشغيل هذا الملف كـ Dart Script عادي
void main() async {
  print('===========================================');
  print('🚀 جاري تهيئة نظام الـ Dependency Injection...');

  // 1. تشغيل الحقن (تهيئة كل الـ Repositories في الذاكرة)
  await initCoreLocator();
  print('✅ تم تجهيز جميع المستودعات بنجاح!');

  // 2. سحب وحدة الاعتماد (AuthRepo) الذكية من الذاكرة
  final authRepo = sl<AuthRepo>();

  print('\n🔄 جاري اختبار الاتصال بسيرفر (Login API)...');

  // 3. اختبار دالة تسجيل الدخول
  // تأكد من تغيير هذه القيم لتطابق مستخدم موجود فعلياً في سيرفر Mongo الخاص بك
  final result = await authRepo.login(
    username: 'test_user',
    password: 'password123',
  );

  // 4. فحص النتيجة
  print('===========================================');
  if (result.status == StatusModel.success) {
    print('✅ [نجاح]: تم الاتصال بالسيرفر ورد بنجاح!');
    print('📦 البيانات المستلمة: ${result.data}');
  } else {
    print('❌ [فشل]: يوجد خطأ في الاتصال أو أن السيرفر رفض الطلب.');
    print('⚠️ رسالة الخطأ: ${result.message}');
  }
  print('===========================================');
}
