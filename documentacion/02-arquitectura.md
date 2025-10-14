# Arquitectura de la Aplicación

## Resumen Ejecutivo

GanaderaSoft es una aplicación web para la gestión integral de operaciones ganaderas, desarrollada con **Laravel 10** como framework backend y **API REST** para la comunicación con clientes. El sistema implementa un enfoque **offline-first** para garantizar la continuidad operativa en entornos rurales con conectividad limitada.

## Patrón Arquitectónico

### MVC (Model-View-Controller)

El sistema sigue el patrón **MVC** de Laravel, complementado con:

- **API-First Design**: Todas las funcionalidades se exponen a través de endpoints REST
- **Arquitectura por Capas**: Separación clara entre presentación, lógica de negocio y datos
- **Patrón Repository** (implícito en los modelos Eloquent)
- **Autenticación Stateless** con Laravel Sanctum

## Diagrama de Arquitectura General

```mermaid
graph TB
    subgraph "Cliente"
        A[Web Browser / Mobile App]
    end
    
    subgraph "API Gateway"
        B[nginx Web Server]
        C[Laravel API]
    end
    
    subgraph "Capa de Presentación"
        D[Rutas Públicas]
        E[Rutas Protegidas]
        F[Middleware Layer]
    end
    
    subgraph "Capa de Negocio"
        G[Controllers]
        H[Models - Eloquent ORM]
        I[Servicios de Negocio]
    end
    
    subgraph "Capa de Datos"
        J[(MySQL Database)]
        K[Migraciones]
        L[Seeders]
    end
    
    subgraph "Seguridad"
        M[Laravel Sanctum]
        N[Validación]
        O[CORS]
    end
    
    A -->|HTTP/HTTPS| B
    B -->|PHP-FPM| C
    C --> D
    C --> E
    D --> F
    E --> F
    F --> M
    F --> O
    M --> G
    G --> N
    G --> H
    H --> I
    I --> J
    K --> J
    L --> J
```

## Capas del Sistema

### 1. Capa de Presentación (API REST)

La capa de presentación expone todos los servicios a través de una API REST, sin renderizado de vistas HTML.

#### Diagrama de Rutas

```mermaid
graph LR
    subgraph "Rutas Públicas"
        A[POST /auth/register]
        B[POST /auth/login]
    end
    
    subgraph "Rutas Protegidas"
        C[Sanctum Middleware]
        D[GET /profile]
        E[CRUD /fincas]
        F[CRUD /animales]
        G[CRUD /rebanos]
        H[CRUD /propietarios]
    end
    
    A --> C
    B --> C
    C --> D
    C --> E
    C --> F
    C --> G
    C --> H
```

#### Controllers Principales

| Controller | Responsabilidad |
|-----------|----------------|
| `AuthController` | Autenticación (login, registro, logout) |
| `FincaController` | Gestión de fincas |
| `PropietarioController` | Gestión de propietarios |
| `RebanoController` | Gestión de rebaños |
| `AnimalController` | Gestión de animales |
| `InventarioBufaloController` | Gestión de inventarios de búfalos |
| `TipoAnimalController` | Gestión de tipos de animales |
| `ConfiguracionController` | Endpoints de configuración |
| `ComposicionRazaController` | Gestión de composición de razas |
| `EtapaController` | Gestión de etapas de vida |
| `PersonalFincaController` | Gestión de personal de fincas |
| `PesoCorporalController` | Registro de pesos corporales |
| `MedidasCorporalesController` | Medidas corporales de animales |
| `LactanciaController` | Control de lactancia |
| `LecheController` | Producción de leche |

### 2. Capa de Middleware

```mermaid
graph LR
    A[Request] --> B[CORS Handler]
    B --> C[Authentication]
    C --> D[Rate Limiting]
    D --> E[Validation]
    E --> F[Controller]
    F --> G[Response]
```

#### Middlewares Implementados

- **CORS Handling**: Permite peticiones cross-origin
- **Authentication (Sanctum)**: Verifica tokens de autenticación
- **Rate Limiting**: Previene abuso de la API
- **Validation**: Valida datos de entrada

### 3. Capa de Lógica de Negocio

#### Diagrama de Modelos Principales

```mermaid
erDiagram
    User ||--o{ Finca : "gestiona"
    User {
        int id PK
        string name
        string email UK
        string password
        string type_user
        timestamp created_at
    }
    
    Propietario ||--o{ Finca : "posee"
    Propietario {
        int id PK
        string Nombre
        string Cedula UK
        string Telefono
    }
    
    Finca ||--o{ Rebano : "contiene"
    Finca {
        int id PK
        string Nombre
        string Explotacion_Tipo
        int id_Propietario FK
        int id_Usuario FK
    }
    
    Rebano ||--o{ Animal : "agrupa"
    Rebano {
        int id PK
        string Nombre
        int fk_id_Finca FK
    }
    
    Animal ||--o{ PesoCorporal : "tiene"
    Animal ||--o{ MedidasCorporales : "tiene"
    Animal ||--o{ Lactancia : "registra"
    Animal {
        int id PK
        string Nombre
        string Sexo
        date Fecha_Nacimiento
        int fk_id_Rebano FK
        int fk_tipo_animal_id FK
    }
    
    TipoAnimal ||--o{ Animal : "clasifica"
    TipoAnimal {
        int id PK
        string Nombre
        string Descripcion
    }
```

#### Relaciones entre Modelos

**One-to-Many:**
- User → Fincas
- Propietario → Fincas
- Finca → Rebaños
- Rebano → Animales
- Animal → PesosCorporales
- Animal → MedidasCorporales
- Animal → Lactancias

**Many-to-Many:**
- Animal ↔ Etapa (a través de `etapa_animal`)

**BelongsTo:**
- Finca → User
- Finca → Propietario
- Rebano → Finca
- Animal → Rebano
- Animal → TipoAnimal

### 4. Capa de Datos

#### Estructura de Base de Datos

```mermaid
graph TD
    A[MySQL 8.0] --> B[InnoDB Engine]
    B --> C[Tablas Principales]
    B --> D[Tablas de Relación]
    B --> E[Tablas de Configuración]
    
    C --> F[users]
    C --> G[propietarios]
    C --> H[finca]
    C --> I[rebano]
    C --> J[animal]
    
    D --> K[etapa_animal]
    D --> L[composicion_raza]
    D --> M[personal_finca]
    
    E --> N[tipo_animal]
    E --> O[estado_salud]
    E --> P[etapa]
```

## Patrones de Diseño Implementados

### 1. Repository Pattern (Eloquent)

```mermaid
graph LR
    A[Controller] --> B[Model]
    B --> C[Query Builder]
    C --> D[Database]
    D --> C
    C --> B
    B --> A
```

### 2. Factory Pattern

Utilizado para la creación de instancias de prueba:

```php
// database/factories/UserFactory.php
// database/factories/FincaFactory.php
```

### 3. Middleware Pattern

Pipeline de procesamiento de requests:

```mermaid
graph LR
    A[Request] --> B[Middleware 1]
    B --> C[Middleware 2]
    C --> D[Middleware 3]
    D --> E[Controller]
    E --> F[Response]
```

### 4. Service Provider Pattern

Inyección de dependencias y bootstrapping de la aplicación.

## Flujo de Autenticación

```mermaid
sequenceDiagram
    participant C as Cliente
    participant A as API
    participant S as Sanctum
    participant D as Database
    
    C->>A: POST /auth/register
    A->>D: Crear usuario
    D-->>A: Usuario creado
    A->>S: Generar token
    S-->>A: Token
    A-->>C: {token, user}
    
    C->>A: POST /auth/login
    A->>D: Verificar credenciales
    D-->>A: Credenciales válidas
    A->>S: Generar token
    S-->>A: Token
    A-->>C: {token, user}
    
    C->>A: GET /profile (Bearer token)
    A->>S: Validar token
    S-->>A: Token válido
    A->>D: Obtener perfil
    D-->>A: Datos de perfil
    A-->>C: {user}
```

## Flujo de Request CRUD

```mermaid
sequenceDiagram
    participant C as Cliente
    participant M as Middleware
    participant Ctrl as Controller
    participant V as Validator
    participant Mod as Model
    participant DB as Database
    
    C->>M: Request con Token
    M->>M: Verificar Token
    M->>Ctrl: Request Autorizado
    Ctrl->>V: Validar Datos
    
    alt Datos Válidos
        V->>Ctrl: OK
        Ctrl->>Mod: Operación CRUD
        Mod->>DB: Query
        DB-->>Mod: Resultado
        Mod-->>Ctrl: Modelo/Collection
        Ctrl-->>C: Response 200
    else Datos Inválidos
        V-->>Ctrl: Errores
        Ctrl-->>C: Response 422
    end
```

## Estrategia Offline-First

### Sincronización de Datos

```mermaid
graph TB
    A[Cliente Offline] --> B{¿Hay conexión?}
    B -->|No| C[Guardar en Local Storage]
    B -->|Sí| D[Enviar a API]
    C --> E[Queue Local]
    E --> F{¿Conexión restaurada?}
    F -->|Sí| D
    F -->|No| E
    D --> G[Procesar en Backend]
    G --> H[Responder al Cliente]
    H --> I[Actualizar Local Storage]
```

### Características Offline-First

1. **Almacenamiento Local**: IndexedDB o LocalStorage
2. **Queue de Sincronización**: Cola de operaciones pendientes
3. **Conflict Resolution**: Estrategia Last-Write-Wins
4. **Timestamps**: Control de versiones mediante `created_at` y `updated_at`

## Escalabilidad y Performance

### Optimizaciones Implementadas

```mermaid
graph LR
    A[Request] --> B[nginx Cache]
    B --> C{¿Cache Hit?}
    C -->|Sí| D[Response]
    C -->|No| E[Laravel Cache]
    E --> F{¿Cache Hit?}
    F -->|Sí| D
    F -->|No| G[Query Database]
    G --> H[Guardar en Cache]
    H --> D
```

### Estrategias de Escalabilidad

1. **Paginación**: Todos los listados paginados (15 items por página)
2. **Eager Loading**: Carga anticipada de relaciones
3. **Índices de Base de Datos**: En columnas de búsqueda frecuente
4. **Query Optimization**: Evitar N+1 queries
5. **Caché de Configuración**: Datos estáticos en archivos JSON

## Seguridad

### Capas de Seguridad

```mermaid
graph TB
    A[Request] --> B[Rate Limiting]
    B --> C[CORS Validation]
    C --> D[Token Authentication]
    D --> E[Input Validation]
    E --> F[SQL Injection Protection]
    F --> G[XSS Protection]
    G --> H[CSRF Protection]
    H --> I[Controller Logic]
```

### Medidas de Seguridad Implementadas

1. **Autenticación**: Laravel Sanctum con tokens Bearer
2. **Validación de Entrada**: Request validation en todos los endpoints
3. **Protección CSRF**: Para requests que modifican estado
4. **Rate Limiting**: Límite de requests por IP
5. **SQL Injection**: Prevención mediante Eloquent ORM
6. **Password Hashing**: bcrypt con salts automáticos
7. **HTTPS**: Recomendado para producción

## Deployment y DevOps

### Arquitectura de Contenedores

```mermaid
graph TB
    subgraph "Docker Compose"
        A[nginx Container]
        B[PHP-FPM Container]
        C[MySQL Container]
        D[PHPMyAdmin Container]
    end
    
    A -->|proxy_pass| B
    B -->|PDO| C
    D -->|MySQL Client| C
    
    E[Volumes] --> B
    E --> C
    
    F[Networks] --> A
    F --> B
    F --> C
    F --> D
```

### Pipeline de Deployment (Planificado)

```mermaid
graph LR
    A[Git Push] --> B[CI/CD Pipeline]
    B --> C[Run Tests]
    C --> D{Tests Pass?}
    D -->|No| E[Notify Developer]
    D -->|Yes| F[Build Docker Image]
    F --> G[Push to Registry]
    G --> H[Deploy to Staging]
    H --> I[Run Integration Tests]
    I --> J{Tests Pass?}
    J -->|No| E
    J -->|Yes| K[Deploy to Production]
```

## Monitoreo y Logging

### Sistema de Logs

```mermaid
graph LR
    A[Application] --> B[Monolog]
    B --> C[Daily Logs]
    B --> D[Error Logs]
    B --> E[API Logs]
    C --> F[Log Rotation]
    D --> F
    E --> F
```

### Niveles de Log

- **DEBUG**: Información detallada de debugging
- **INFO**: Eventos informativos
- **WARNING**: Advertencias que no son errores
- **ERROR**: Errores de runtime
- **CRITICAL**: Condiciones críticas

## Módulos del Sistema

### Módulos Core

```mermaid
graph TB
    A[Sistema GanaderaSoft] --> B[Módulo de Autenticación]
    A --> C[Módulo de Gestión de Fincas]
    A --> D[Módulo de Gestión de Animales]
    A --> E[Módulo de Inventarios]
    A --> F[Módulo de Reportes]
    A --> G[Módulo de Configuración]
    
    C --> H[Propietarios]
    C --> I[Terrenos]
    C --> J[Personal]
    
    D --> K[Rebaños]
    D --> L[Tipos de Animal]
    D --> M[Razas]
    D --> N[Estados de Salud]
    
    E --> O[Inventario General]
    E --> P[Inventario Búfalos]
    E --> Q[Inventario Vacunos]
```

## Interacción entre Módulos

```mermaid
sequenceDiagram
    participant U as Usuario
    participant A as Auth Module
    participant F as Finca Module
    participant An as Animal Module
    participant I as Inventario Module
    
    U->>A: Login
    A-->>U: Token
    U->>F: Crear Finca
    F->>F: Validar Propietario
    F-->>U: Finca Creada
    U->>An: Crear Animal
    An->>F: Verificar Finca
    F-->>An: Finca Válida
    An->>An: Validar Rebaño
    An-->>U: Animal Creado
    U->>I: Consultar Inventario
    I->>An: Obtener Animales
    An-->>I: Lista de Animales
    I-->>U: Reporte de Inventario
```

## Roadmap de Arquitectura

### Fase 1 (Actual)
- [x] API REST básica
- [x] Autenticación con Sanctum
- [x] CRUD de entidades principales
- [x] Base de datos relacional

### Fase 2 (Planificada)
- [ ] WebSockets para notificaciones en tiempo real
- [ ] Sistema de cache distribuido (Redis)
- [ ] Queue workers para tareas pesadas
- [ ] API Gateway con rate limiting avanzado

### Fase 3 (Futura)
- [ ] Microservicios
- [ ] Event Sourcing
- [ ] CQRS Pattern
- [ ] GraphQL API

## Conclusión

La arquitectura de GanaderaSoft está diseñada para ser:

- **Escalable**: Fácil de escalar horizontalmente
- **Mantenible**: Código organizado y bien documentado
- **Segura**: Múltiples capas de seguridad
- **Performante**: Optimizaciones en todos los niveles
- **Resiliente**: Estrategia offline-first
- **Extensible**: Fácil de agregar nuevas funcionalidades

---

**Última actualización:** Octubre 2025  
**Mantenido por:** Equipo de Desarrollo GanaderaSoft
