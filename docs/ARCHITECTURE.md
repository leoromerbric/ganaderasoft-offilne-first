# Arquitectura del Sistema GanaderaSoft

## Resumen Ejecutivo

GanaderaSoft es una aplicación web para la gestión integral de operaciones ganaderas, desarrollada con **Laravel 10** como framework backend y **API REST** para la comunicación con clientes. El sistema implementa un enfoque **offline-first** para garantizar la continuidad operativa en entornos rurales con conectividad limitada.

## Arquitectura General

### Patrón Arquitectónico

El sistema sigue el patrón **MVC (Model-View-Controller)** de Laravel, complementado con:

- **API-First Design**: Todas las funcionalidades se exponen a través de endpoints REST
- **Arquitectura por Capas**: Separación clara entre presentación, lógica de negocio y datos
- **Patrón Repository** (implícito en los modelos Eloquent)
- **Autenticación Stateless** con Laravel Sanctum

### Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENTE (Web/Mobile)                    │
├─────────────────────────────────────────────────────────────┤
│                     API REST Layer                         │
│  ┌───────────────┐ ┌───────────────┐ ┌──────────────────┐  │
│  │ Auth Routes   │ │ Public Routes │ │ Protected Routes │  │
│  └───────────────┘ └───────────────┘ └──────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                   MIDDLEWARE LAYER                         │
│  ┌────────────────┐ ┌─────────────────┐ ┌───────────────┐  │
│  │ CORS Handling  │ │ Authentication  │ │ Rate Limiting │  │
│  └────────────────┘ └─────────────────┘ └───────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                  CONTROLLER LAYER                          │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ API Controllers (AuthController, FincaController,   │   │
│  │ PropietarioController, RebanoController, etc.)      │   │
│  └──────────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────┤
│                   BUSINESS LOGIC                           │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Models (User, Finca, Animal, Rebano, etc.)          │   │
│  │ - Eloquent ORM                                       │   │
│  │ - Relationships                                      │   │
│  │ - Validations                                        │   │
│  │ - Scopes                                             │   │
│  └──────────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────┤
│                     DATA LAYER                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                MySQL Database                        │   │
│  │ ┌─────────────┐ ┌────────────┐ ┌─────────────────┐   │   │
│  │ │ Users       │ │ Fincas     │ │ Animals         │   │   │
│  │ │ Propietarios│ │ Rebanos    │ │ Inventarios     │   │   │
│  │ └─────────────┘ └────────────┘ └─────────────────┘   │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Componentes del Sistema

### 1. Capa de Presentación (API REST)

#### Rutas y Endpoints
- **Públicas**: Registro y login de usuarios
- **Protegidas**: Todas las operaciones CRUD con autenticación Sanctum

#### Controllers
- **AuthController**: Manejo de autenticación (login, registro, logout)
- **FincaController**: Gestión de fincas
- **PropietarioController**: Gestión de propietarios
- **RebanoController**: Gestión de rebaños
- **AnimalController**: Gestión de animales
- **InventarioBufaloController**: Gestión de inventarios
- **TipoAnimalController**: Gestión de tipos de animal

### 2. Capa de Lógica de Negocio

#### Modelos Principales

```php
// Jerarquía de entidades principales
User (1) ←→ (1) Propietario (1) ←→ (N) Finca (1) ←→ (N) Rebano (1) ←→ (N) Animal
                                   ↓
                               InventarioBufalo
```

**Relaciones Clave:**
- User ↔ Propietario (1:1)
- Propietario → Finca (1:N)
- Finca → Rebano (1:N)
- Finca → InventarioBufalo (1:N)
- Rebano → Animal (1:N)

#### Reglas de Negocio
- **Permisos por Rol**:
  - `admin`: Acceso completo a todas las entidades
  - `propietario`: Acceso solo a sus propios recursos
  - `tecnico`: Acceso de solo lectura (implementación futura)

- **Eliminación Suave**: Fincas, Rebanos y Animales usan soft delete (`archivado = true`)
- **Validaciones**: Campos requeridos, formatos, unicidad donde corresponde

### 3. Capa de Datos

#### Base de Datos MySQL
- **Motor de Almacenamiento**: InnoDB
- **Codificación**: utf8mb4_general_ci
- **Integridad Referencial**: Foreign keys con constraints

#### Tablas Principales
- `users`: Usuarios del sistema
- `propietario`: Información de propietarios
- `finca`: Fincas ganaderas
- `rebano`: Rebaños dentro de fincas
- `animal`: Animales individuales
- `Inventario_Bufalo`: Inventarios de búfalos
- `tipo_animal`: Catálogo de tipos de animal

## Patrones de Diseño Implementados

### 1. **Active Record** (Eloquent ORM)
```php
$animal = Animal::find(1);
$animal->update(['Nombre' => 'Nuevo Nombre']);
```

### 2. **Repository Pattern** (Implícito)
Los modelos Eloquent actúan como repositorios para acceso a datos.

### 3. **Factory Pattern** (Responses)
Respuestas estandarizadas en formato JSON:
```php
return response()->json([
    'success' => true,
    'message' => 'Operación exitosa',
    'data' => $data
]);
```

### 4. **Middleware Pattern**
- Autenticación (`auth:sanctum`)
- CORS handling
- Rate limiting (futuro)

### 5. **Observer Pattern** (Futuro)
Para auditoría y eventos del sistema.

## Seguridad

### Autenticación
- **Laravel Sanctum**: Tokens de acceso personal
- **Hash de Passwords**: bcrypt por defecto
- **Validación de Tokens**: En cada request protegido

### Autorización
- **Role-Based Access Control (RBAC)**
- **Resource-Based Permissions**: Los propietarios solo acceden a sus recursos
- **Validación de Ownership**: Verificación en cada operación

### Validación de Datos
- **Laravel Validator**: Validaciones server-side
- **Sanitización**: Prevención de inyecciones
- **Reglas Personalizadas**: Según requerimientos de negocio

## Offline-First Strategy

### Implementación Planificada
1. **Service Workers**: Cache de API responses
2. **LocalStorage/IndexedDB**: Almacenamiento local
3. **Sync Queue**: Cola de sincronización cuando hay conexión
4. **Conflict Resolution**: Estrategias para resolver conflictos

### Consideraciones de Diseño
- **Timestamps**: `created_at` y `updated_at` para sincronización
- **Soft Deletes**: Facilita sincronización de eliminaciones
- **UUIDs** (futuro): Para evitar conflictos de IDs

## Escalabilidad y Performance

### Optimizaciones Actuales
- **Eager Loading**: Carga de relaciones con `with()`
- **Paginación**: 15 elementos por página por defecto
- **Índices de Base de Datos**: Primary keys y foreign keys
- **Query Scopes**: Filtros reutilizables en modelos

### Escalabilidad Horizontal (Futuro)
- **Load Balancers**: Nginx/HAProxy
- **Database Clustering**: MySQL Master-Slave
- **Cache Layer**: Redis para sesiones y cache
- **Queue System**: Para tareas asíncronas

## Monitoreo y Logging

### Logging Actual
- **Laravel Log**: Errores y warnings automáticos
- **Query Logging**: Para debugging en desarrollo

### Monitoreo Futuro
- **Application Performance Monitoring (APM)**
- **Health Checks**: Endpoints de estado del sistema
- **Metrics Collection**: Métricas de uso y performance

## Deployment y DevOps

### Containerización
```dockerfile
# Dockerfile actual
FROM php:8.1-apache
# Configuración de Apache y PHP
# Instalación de dependencias
# Configuración de Laravel
```

### Orchestración
```yaml
# docker-compose.yml
services:
  app: # Laravel application
  db:  # MySQL database
  nginx: # Reverse proxy
```

### CI/CD Pipeline (Planificado)
1. **Source Control**: Git hooks
2. **Testing**: PHPUnit tests
3. **Build**: Docker image creation
4. **Deploy**: Automated deployment

## Testing Strategy

### Estructura de Testing
```
tests/
├── Feature/     # Integration tests
│   ├── AuthTest.php
│   ├── FincaTest.php
│   └── AnimalTest.php
├── Unit/        # Unit tests
│   ├── Models/
│   └── Services/
└── TestCase.php # Base test class
```

### Tipos de Tests
- **Feature Tests**: Endpoints completos
- **Unit Tests**: Modelos y servicios
- **Integration Tests**: Interacciones entre componentes

## Documentación y APIs

### Documentación de API
- **README.md**: Documentación principal
- **Postman Collection**: Para testing y ejemplos
- **OpenAPI/Swagger** (futuro): Documentación interactiva

### Estándares de Código
- **PSR-4**: Autoloading
- **PSR-12**: Coding style
- **Laravel Conventions**: Naming y estructura

## Roadmap y Evolución

### Versión Actual (v1.0)
- ✅ CRUD básico para entidades principales
- ✅ Autenticación y autorización
- ✅ API REST completa

### Próximas Versiones
- **v1.1**: Funcionalidades offline-first
- **v1.2**: Reportes y analytics
- **v1.3**: Notificaciones y alertas
- **v2.0**: Mobile app nativa
- **v2.1**: IoT integration (sensores, GPS)

## Conclusión

GanaderaSoft implementa una arquitectura robusta y escalable basada en Laravel, con enfoque en APIs REST y preparación para capacidades offline. El diseño modular facilita el mantenimiento y la extensión de funcionalidades, mientras que las mejores prácticas de seguridad y performance aseguran un sistema confiable para la gestión ganadera.

La arquitectura permite evolución gradual hacia un sistema más complejo con capacidades avanzadas de IoT, analytics y mobile-first, manteniendo la compatibilidad y estabilidad del sistema base.