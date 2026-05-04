# Informe de Vulnerabilidades OWASP Mobile Top 10

## Alcance

La aplicación evaluada es **Vet App Mobile**, una app Flutter orientada exclusivamente a **clientes** de una clínica veterinaria.

Funcionalidades presentes en la app:
- Tienda de productos
- Carrito de compra y checkout
- Solicitud de cita veterinaria
- Historial de citas
- Catálogo y solicitud de adopción

No se ha identificado ningún panel de administración, ni vistas de veterinarios, ni backoffice interno.

## Metodología de análisis

### SAST
Herramientas ubicadas en el proyecto o recomendadas para análisis estático:
- `flutter analyze` a través del analizador de Dart de VS Code o de CI
- `flutter_lints` configurado en [vet_app_mobile/pubspec.yaml](../vet_app_mobile/pubspec.yaml)
- Revisión manual de código fuente en `lib/`
- SonarQube/SonarLint para inspección estática adicional

### DAST
Herramientas recomendadas para pruebas dinámicas:
- OWASP ZAP contra un entorno desplegado de pruebas
- Postman o Insomnia para validar comportamientos de endpoints expuestos
- Pruebas manuales sobre una build instalada en dispositivo o emulador

### Otras comprobaciones
- Dependency scanning con `flutter pub outdated` y revisión de dependencias
- Revisión de configuración de red, logging y almacenamiento local

## Hallazgos OWASP Mobile

### M1. Uso Incorrecto de la Plataforma
- Riesgo: medio-alto
- Evidencia: la configuración de API vive en [vet_app_mobile/lib/services/api_config.dart](../vet_app_mobile/lib/services/api_config.dart) y exige HTTPS
- Observación: sigue faltando certificate pinning y validación de backend reforzada

### M2. Inseguridad en el Almacenamiento de Datos
- Riesgo: alto
- Evidencia: no existe almacenamiento seguro para credenciales, tokens o datos sensibles
- Observación: no se usa FlutterSecureStorage ni un cifrado local dedicado

### M3. Comunicación Insegura
- Riesgo: medio
- Evidencia: [vet_app_mobile/lib/services/api_service.dart](../vet_app_mobile/lib/services/api_service.dart) usa base HTTPS por entorno y bloquea esquemas no seguros
- Impacto: el riesgo residual depende del backend real y de la ausencia de certificate pinning

### M4. Autenticación y Autorización Débiles
- Riesgo: crítico
- Evidencia: no hay login, sesión, ni control de acceso por rol
- Impacto: cualquier usuario puede acceder a las funciones disponibles en la app

### M5. Validación Insuficiente de Entrada
- Riesgo: medio
- Evidencia: la app valida formularios en cliente en [vet_app_mobile/lib/screens/appointment_screen.dart](../vet_app_mobile/lib/screens/appointment_screen.dart) y [vet_app_mobile/lib/screens/checkout_screen.dart](../vet_app_mobile/lib/screens/checkout_screen.dart)
- Observación: la validación del cliente no sustituye la validación del servidor

### M6. Logging Inseguro o Inexistente
- Riesgo: medio
- Evidencia: no existe un sistema de auditoría ni de eventos de seguridad
- Impacto: baja trazabilidad ante incidentes

### M7. Control de Acceso Deficiente
- Riesgo: crítico
- Evidencia: no hay segregación de permisos en rutas o datos
- Impacto: ausencia total de control de acceso efectivo

### M8. Funcionalidad de Seguridad Débil
- Riesgo: alto
- Evidencia: faltan medidas como MFA, bloqueo de sesión y gestión segura de secretos

### M9. Cifrado Débil o Inexistente
- Riesgo: crítico
- Evidencia: no se observa cifrado en reposo ni protección criptográfica de datos locales

### M10. Ofuscación y Protección del Código
- Riesgo: medio
- Evidencia: no se observan pasos de ofuscación de Dart ni endurecimiento adicional del binario

## Resumen de severidad

| Categoría | Severidad |
|---|---|
| M1 | Media-Alta |
| M2 | Alta |
| M3 | Crítica |
| M4 | Crítica |
| M5 | Media |
| M6 | Media |
| M7 | Crítica |
| M8 | Alta |
| M9 | Crítica |
| M10 | Media |

## Conclusión

La app **sí cumple el alcance funcional de cliente-only**, pero **no cumple todavía con un nivel de seguridad alineado con OWASP Mobile para producción**.

El estado actual es adecuado como **MVP funcional** y como base para una entrega académica. Para subir el nivel de conformidad todavía faltan:
- Añadir autenticación y autorización
- Incorporar almacenamiento seguro
- Implementar certificate pinning
- Ejecutar DAST en un entorno de pruebas
- Integrar SAST de forma continua en CI
