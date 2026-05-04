# GUÍA DE IMPLEMENTACIÓN DE SEGURIDAD
## Ejemplos de Código para Mitigar Vulnerabilidades OWASP

---

## 1. IMPLEMENTAR HTTPS + CERTIFICATE PINNING

### Paso 1: Agregar Dependencias

```bash
flutter pub add http
flutter pub add http_certificate_pinning
flutter pub add flutter_secure_storage
```

### Paso 2: Crear Servicio de API Seguro

**Archivo: `lib/services/secure_api_service.dart`**

```dart
import 'package:http/http.dart' as http;
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'dart:convert';

class SecureApiService {
  // ✅ HTTPS en lugar de HTTP
  static const String baseUrl = 'https://api.vetapp.com';
  
  // Certificate Pinning - SHA256 hash del certificado
  static const String certificatePin = 
    'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=';
  
  static final http.Client _client = http.Client();

  /// Realiza una solicitud GET segura
  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    
    try {
      final response = await makeSecureRequest(
        url.toString(),
        certificatePath: 'assets/certificates/api.crt',
      );
      
      return http.Response(
        response['body'] ?? '',
        response['statusCode'] ?? 500,
      );
    } catch (e) {
      throw Exception('Error de seguridad en solicitud: $e');
    }
  }

  /// Realiza una solicitud POST segura
  static Future<http.Response> post(
    String endpoint, {
    required Map<String, dynamic> body,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'X-API-Version': '1.0',
    };

    try {
      // Usar http con validación SSL
      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Timeout en solicitud'),
      );

      _validateResponseStatus(response);
      return response;
    } catch (e) {
      throw Exception('Error en solicitud POST: $e');
    }
  }

  /// Validar estado de respuesta
  static void _validateResponseStatus(http.Response response) {
    if (response.statusCode == 401) {
      throw UnauthorizedException('Token expirado o inválido');
    }
    if (response.statusCode == 403) {
      throw ForbiddenException('Acceso denegado');
    }
    if (response.statusCode >= 500) {
      throw ServerException('Error del servidor');
    }
  }
}

// Excepciones personalizadas
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);
  
  @override
  String toString() => 'ForbiddenException: $message';
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
  
  @override
  String toString() => 'ServerException: $message';
}
```

### Paso 3: Configurar Asset de Certificado

**En `pubspec.yaml`:**

```yaml
assets:
  - assets/certificates/api.crt
```

---

## 2. IMPLEMENTAR AUTENTICACIÓN JWT

### Paso 1: Criar Modelo de Usuario

**Archivo: `lib/models/user_model.dart`**

```dart
class User {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullName': fullName,
    'role': role,
    'createdAt': createdAt.toIso8601String(),
  };
}
```

### Paso 2: Crear Servicio de Autenticación

**Archivo: `lib/services/auth_service.dart`**

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'secure_api_service.dart';
import '../models/user_model.dart';

class AuthService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEP_SHA256_MGFSHA1,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
  );

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  /// Login de usuario
  static Future<User> login(String email, String password) async {
    // Validar input
    if (!_isValidEmail(email)) {
      throw ValidationException('Email inválido');
    }
    if (password.length < 8) {
      throw ValidationException('Contraseña debe tener mínimo 8 caracteres');
    }

    try {
      final response = await SecureApiService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password, // En producción, hash en cliente
        },
        token: '', // No necesita token para login
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Guardar tokens de forma segura
        await _storage.write(
          key: _accessTokenKey,
          value: data['accessToken'],
        );
        await _storage.write(
          key: _refreshTokenKey,
          value: data['refreshToken'],
        );

        // Guardar usuario
        final user = User.fromJson(data['user']);
        await _storage.write(
          key: _userKey,
          value: jsonEncode(user.toJson()),
        );

        return user;
      } else {
        throw AuthenticationException('Credenciales inválidas');
      }
    } catch (e) {
      throw AuthenticationException('Error en login: $e');
    }
  }

  /// Obtener token de acceso
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Refresh de token
  static Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      
      if (refreshToken == null) {
        return false;
      }

      final response = await SecureApiService.post(
        '/auth/refresh',
        body: {'refreshToken': refreshToken},
        token: refreshToken,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        await _storage.write(
          key: _accessTokenKey,
          value: data['accessToken'],
        );
        
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Logout - Eliminar datos sensibles
  static Future<void> logout() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userKey);
  }

  /// Obtener usuario actual
  static Future<User?> getCurrentUser() async {
    final userData = await _storage.read(key: _userKey);
    
    if (userData == null) {
      return null;
    }

    try {
      return User.fromJson(jsonDecode(userData));
    } catch (e) {
      return null;
    }
  }

  /// Verificar si está autenticado
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Validaciones
  static bool _isValidEmail(String email) {
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return regex.hasMatch(email);
  }
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
  @override
  String toString() => 'AuthenticationException: $message';
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  @override
  String toString() => 'ValidationException: $message';
}
```

### Paso 3: Crear Screen de Login

**Archivo: `lib/screens/login_screen.dart`**

```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final user = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } on ValidationException catch (e) {
      setState(() => _errorMessage = e.message);
    } on AuthenticationException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                )
                : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 3. ALMACENAMIENTO SEGURO CON ENCRIPTACIÓN

### Archivo: `lib/services/secure_storage_service.dart`

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEP_SHA256_MGFSHA1,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_this_device_this_device_only,
    ),
  );

  // Generar clave segura (debe hacerse una sola vez)
  static final _encryptionKey = encrypt.Key.fromSecureRandom(32); // AES-256

  /// Guardar datos encriptados
  static Future<void> saveEncrypted(
    String key,
    dynamic value,
  ) async {
    try {
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));

      final stringValue = value is String ? value : jsonEncode(value);
      final encrypted = encrypter.encrypt(stringValue, iv: iv);

      final encryptedData = '${iv.base64}:${encrypted.base64}';

      await _storage.write(key: key, value: encryptedData);
    } catch (e) {
      throw Exception('Error al guardar datos encriptados: $e');
    }
  }

  /// Recuperar datos encriptados
  static Future<T?> getEncrypted<T>(
    String key, {
    required T Function(String) fromJson,
  }) async {
    try {
      final encryptedData = await _storage.read(key: key);

      if (encryptedData == null) {
        return null;
      }

      final parts = encryptedData.split(':');
      if (parts.length != 2) {
        throw Exception('Formato de datos encriptados inválido');
      }

      final iv = encrypt.IV.fromBase64(parts[0]);
      final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));

      final decrypted = encrypter.decrypt64(parts[1], iv: iv);
      return fromJson(decrypted);
    } catch (e) {
      throw Exception('Error al recuperar datos encriptados: $e');
    }
  }

  /// Eliminar datos
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Limpiar todo (para logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Verificar si existe una clave
  static Future<bool> contains(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }
}

// Uso:
/*
// Guardar
await SecureStorageService.saveEncrypted(
  'user_preferences',
  {'theme': 'dark', 'language': 'es'},
);

// Recuperar
final prefs = await SecureStorageService.getEncrypted(
  'user_preferences',
  fromJson: (json) => jsonDecode(json),
);
*/
```

---

## 4. VALIDACIÓN DE ENTRADA

### Archivo: `lib/utils/validators.dart`

```dart
class InputValidator {
  // Expresiones regulares
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );

  static final _phoneRegex = RegExp(r'^\+?1?\d{9,15}$');

  static final _strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'
  );

  /// Validar email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  /// Validar contraseña fuerte
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 8) {
      return 'Mínimo 8 caracteres';
    }
    if (!_strongPasswordRegex.hasMatch(value)) {
      return 'Requiere: mayúscula, minúscula, número, símbolo';
    }
    return null;
  }

  /// Validar teléfono
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }
    if (!_phoneRegex.hasMatch(value)) {
      return 'Teléfono inválido';
    }
    return null;
  }

  /// Validar nombre
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.length < 2) {
      return 'Nombre muy corto';
    }
    if (value.length > 100) {
      return 'Nombre muy largo';
    }
    return null;
  }

  /// Validar fecha de cita (futura)
  static String? validateAppointmentDate(DateTime? date) {
    if (date == null) {
      return 'Selecciona una fecha';
    }
    final now = DateTime.now();
    if (date.isBefore(now)) {
      return 'No puedes agendar en el pasado';
    }
    final maxDate = now.add(const Duration(days: 90));
    if (date.isAfter(maxDate)) {
      return 'No se puede agendar con más de 90 días';
    }
    return null;
  }

  /// Validar precio
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'El precio es requerido';
    }
    try {
      final price = double.parse(value);
      if (price <= 0) {
        return 'El precio debe ser mayor a 0';
      }
      if (price > 100000) {
        return 'Precio muy alto';
      }
      return null;
    } catch (e) {
      return 'Precio inválido';
    }
  }

  /// Validar cantidad
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cantidad requerida';
    }
    try {
      final qty = int.parse(value);
      if (qty <= 0) {
        return 'Cantidad debe ser mayor a 0';
      }
      if (qty > 1000) {
        return 'Cantidad muy alta';
      }
      return null;
    } catch (e) {
      return 'Cantidad inválida';
    }
  }

  /// Sanitizar texto (remover caracteres peligrosos)
  static String sanitizeInput(String input) {
    return input
      .replaceAll(RegExp(r'[<>\"\'%;()&+]'), '')
      .trim();
  }
}
```

### Uso en UI:

```dart
TextField(
  controller: _emailController,
  decoration: InputDecoration(
    labelText: 'Email',
    errorText: InputValidator.validateEmail(_emailController.text),
  ),
)
```

---

## 5. CONTROL DE ACCESO BASADO EN ROLES (RBAC)

### Archivo: `lib/services/rbac_service.dart`

```dart
enum UserRole {
  admin,
  veterinarian,
  customer,
  guest
}

class RBACService {
  static UserRole _userRole = UserRole.guest;

  /// Establecer rol del usuario
  static void setUserRole(String roleString) {
    try {
      _userRole = UserRole.values.firstWhere(
        (role) => role.toString().split('.').last == roleString.toLowerCase(),
      );
    } catch (e) {
      _userRole = UserRole.guest;
    }
  }

  /// Obtener rol actual
  static UserRole getUserRole() => _userRole;

  /// Verificar permisos específicos
  static bool hasPermission(String permission) {
    final permissions = _getPermissionsForRole(_userRole);
    return permissions.contains(permission);
  }

  /// Verificar si tiene alguno de los roles
  static bool hasRole(List<UserRole> roles) {
    return roles.contains(_userRole);
  }

  /// Obtener permisos por rol
  static List<String> _getPermissionsForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return [
          'view_all_appointments',
          'manage_users',
          'manage_products',
          'view_reports',
          'manage_staff',
          'view_analytics',
        ];
      case UserRole.veterinarian:
        return [
          'view_assigned_appointments',
          'update_appointment_status',
          'view_patient_history',
          'create_prescription',
        ];
      case UserRole.customer:
        return [
          'view_own_appointments',
          'book_appointment',
          'view_products',
          'make_purchases',
          'view_adoption_listings',
          'submit_adoption_request',
        ];
      case UserRole.guest:
        return ['view_products'];
    }
  }

  /// Guards para rutas
  static bool canAccessRoute(String route, UserRole role) {
    final routePermissions = {
      '/admin': ['view_all_appointments'],
      '/appointments': ['view_own_appointments', 'view_all_appointments'],
      '/vet-panel': ['view_assigned_appointments'],
      '/store': ['view_products'],
      '/adoption': ['view_adoption_listings'],
    };

    final requiredPermission = routePermissions[route];
    if (requiredPermission == null) return true;

    return requiredPermission.any((perm) => hasPermission(perm));
  }
}
```

### Uso en Screens:

```dart
class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!RBACService.hasPermission('view_all_appointments')) {
      return const Scaffold(
        body: Center(
          child: Text('Acceso denegado'),
        ),
      );
    }

    return Scaffold(
      // Admin content
    );
  }
}
```

---

## 6. LOGGING SEGURO

### Archivo: `lib/utils/secure_logger.dart`

```dart
import 'package:logger/logger.dart';

class SecureLogger {
  static final Logger _logger = Logger(
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log de evento (no sensible)
  static void logEvent(String event, [Map<String, dynamic>? data]) {
    // Filtrar datos sensibles
    final safeData = _filterSensitiveData(data ?? {});
    _logger.i('EVENT: $event', {
      ...safeData,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log de error
  static void logError(String error, [Object? exception, StackTrace? trace]) {
    _logger.e(error, error: exception, stackTrace: trace);
  }

  /// Log de advertencia
  static void logWarning(String warning, [Map<String, dynamic>? data]) {
    final safeData = _filterSensitiveData(data ?? {});
    _logger.w(warning, error: safeData);
  }

  /// Filtrar datos sensibles
  static Map<String, dynamic> _filterSensitiveData(
    Map<String, dynamic> data,
  ) {
    const sensitiveKeys = [
      'password',
      'token',
      'accessToken',
      'refreshToken',
      'credit_card',
      'ssn',
      'apiKey',
      'secret',
      'auth',
    ];

    final filtered = <String, dynamic>{};

    data.forEach((key, value) {
      final isPassword = sensitiveKeys.any(
        (sensitive) => key.toLowerCase().contains(sensitive.toLowerCase()),
      );

      if (isPassword) {
        filtered[key] = '***REDACTED***';
      } else {
        filtered[key] = value;
      }
    });

    return filtered;
  }

  /// Verificar si está en modo debug (para logs más detallados)
  static bool isDebugMode() {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());
    return inDebug;
  }
}

// Uso:
/*
SecureLogger.logEvent('User logged in');
SecureLogger.logError('Login failed', exception);
SecureLogger.logWarning('Suspicious activity', {
  'userId': '12345',
  'ipAddress': '192.168.1.1',
});
*/
```

---

## 7. DETECCIÓN DE DISPOSITIVO COMPROMETIDO

### Archivo: `lib/services/device_security_service.dart`

```dart
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class DeviceSecurityService {
  /// Verificar si el dispositivo está rooteado o jailbreaked
  static Future<bool> isDeviceCompromised() async {
    try {
      final isJailbroken = await FlutterJailbreakDetection.jailbroken;
      return isJailbroken;
    } catch (e) {
      // Si hay error verificando, asumir que está comprometido
      return true;
    }
  }

  /// Ejecutar verificaciones de seguridad al iniciar
  static Future<void> performSecurityChecks() async {
    final isCompromised = await isDeviceCompromised();

    if (isCompromised) {
      _handleCompromisedDevice();
    }
  }

  /// Manejar dispositivo comprometido
  static void _handleCompromisedDevice() {
    // Opciones:
    // 1. Mostrar advertencia y permitir uso limitado
    // 2. Bloquear acceso completamente
    // 3. Restrngir funcionalidades sensibles

    // Recomendación: Opción 3 para datos financieros/médicos
    SecureLogger.logWarning(
      'Security Alert: Device appears to be jailbroken/rooted',
    );
    // Implementar restricción de funcionalidades
  }
}

// En main.dart:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeviceSecurityService.performSecurityChecks();
  runApp(const MyApp());
}
```

---

## PRÓXIMOS PASOS

1. **Implementar en orden:**
   - Semana 1: HTTPS + Certificate Pinning
   - Semana 2: Autenticación JWT
   - Semana 3: Almacenamiento Seguro
   - Semana 4: Control de Acceso
   - Semana 5: Validaciones + Logging

2. **Testing:**
   - Unit tests para servicios de seguridad
   - Integration tests con API real
   - Penetration testing antes de producción

3. **Documentación:**
   - Actualizar README con instrucciones de seguridad
   - Crear runbook de respuesta a incidentes
   - Documentar flujos de autenticación

---

**Generated:** 4 de Mayo, 2026
