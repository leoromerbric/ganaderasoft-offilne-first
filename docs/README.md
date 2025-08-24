# GanaderaSoft API Documentation

Esta documentación describe cómo consumir la API de GanaderaSoft, un sistema de gestión ganadera diseñado para administrar fincas, propietarios, rebaños, animales y inventarios.

## Contenido

- [Configuración Inicial](#configuración-inicial)
- [Autenticación](#autenticación)
- [Endpoints Disponibles](#endpoints-disponibles)
  - [Autenticación](#-autenticación)
  - [Propietarios](#-gestión-de-propietarios)
  - [Fincas](#-gestión-de-fincas)
  - [Rebaños](#-gestión-de-rebaños)
  - [Animales](#-gestión-de-animales)
  - [Inventario de Búfalo](#-inventario-de-búfalo)
  - [Tipos de Animal](#-tipos-de-animal)
- [Colección de Postman](#colección-de-postman)
- [Ejemplos de Uso](#ejemplos-de-uso)
- [Códigos de Error](#códigos-de-error)

## Configuración Inicial

### URL Base
```
http://localhost:8000/api
```

### Headers Requeridos
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token} (para endpoints protegidos)
```

## Autenticación

La API utiliza Laravel Sanctum para la autenticación mediante tokens Bearer. Los passwords son hasheados de forma segura usando `Illuminate\Support\Facades\Hash`.

### Proceso de Autenticación
1. Registrar usuario o iniciar sesión
2. Obtener el token de acceso
3. Incluir el token en el header `Authorization: Bearer {token}` para endpoints protegidos

## Endpoints Disponibles

### 🔐 Autenticación

#### POST `/auth/register`
Registra un nuevo usuario en el sistema.

**Campos Requeridos:**
```json
{
    "name": "string (máx. 255 caracteres)",
    "email": "string (email válido, único)",
    "password": "string (mín. 8 caracteres)",
    "password_confirmation": "string (debe coincidir con password)",
    "type_user": "string (admin|propietario|tecnico)"
}
```

**Respuesta Exitosa (201):**
```json
{
    "success": true,
    "message": "Usuario registrado exitosamente",
    "data": {
        "user": {
            "id": 1,
            "name": "Nombre Usuario",
            "email": "usuario@example.com",
            "type_user": "propietario",
            "image": "user.png"
        },
        "token": "1|token_string_here",
        "token_type": "Bearer"
    }
}
```

#### POST `/auth/login`
Autentica un usuario y devuelve un token de acceso.

**Campos Requeridos:**
```json
{
    "email": "string",
    "password": "string"
}
```

#### GET `/profile` 🔒
Obtiene el perfil del usuario autenticado.

#### POST `/auth/logout` 🔒
Cierra sesión y revoca el token actual.

### 👨‍💼 Gestión de Propietarios

#### GET `/propietarios` 🔒
Lista los propietarios según los permisos del usuario.

**Control de Acceso:**
- `admin`: Ve todos los propietarios
- `propietario`: Ve solo su propio registro

#### POST `/propietarios` 🔒
Crea un nuevo propietario.

**Campos Requeridos:**
```json
{
    "id": "integer (ID del usuario)",
    "Nombre": "string (máx. 255 caracteres)",
    "Apellido": "string (máx. 255 caracteres)",
    "Telefono": "string (máx. 20 caracteres, opcional)",
    "id_Personal": "integer (opcional)"
}
```

#### GET `/propietarios/{id}` 🔒
Obtiene detalles de un propietario específico.

#### PUT `/propietarios/{id}` 🔒
Actualiza un propietario existente.

#### DELETE `/propietarios/{id}` 🔒
Elimina un propietario (solo admin).

### 🏡 Gestión de Fincas

#### GET `/fincas` 🔒
Lista las fincas según los permisos del usuario.

**Control de Acceso:**
- `admin`: Ve todas las fincas
- `propietario`: Ve solo sus fincas

#### POST `/fincas` 🔒
Crea una nueva finca.

**Campos Requeridos:**
```json
{
    "Nombre": "string (máx. 25 caracteres)",
    "Explotacion_Tipo": "string (máx. 20 caracteres)",
    "id_Propietario": "integer (debe existir)"
}
```

#### GET `/fincas/{id}` 🔒
Obtiene detalles de una finca específica.

#### PUT `/fincas/{id}` 🔒
Actualiza una finca existente.

#### DELETE `/fincas/{id}` 🔒
Elimina una finca (eliminación suave).

### 🐄 Gestión de Rebaños

#### GET `/rebanos` 🔒
Lista los rebaños según los permisos del usuario.

**Control de Acceso:**
- `admin`: Ve todos los rebaños
- `propietario`: Ve solo rebaños de sus fincas

#### POST `/rebanos` 🔒
Crea un nuevo rebaño.

**Campos Requeridos:**
```json
{
    "id_Finca": "integer (debe existir)",
    "Nombre": "string (máx. 25 caracteres)"
}
```

#### GET `/rebanos/{id}` 🔒
Obtiene detalles de un rebaño específico.

#### PUT `/rebanos/{id}` 🔒
Actualiza un rebaño existente.

#### DELETE `/rebanos/{id}` 🔒
Elimina un rebaño (no se puede si tiene animales).

### 🐂 Gestión de Animales

#### GET `/animales` 🔒
Lista los animales según los permisos del usuario.

**Parámetros de Query Opcionales:**
- `rebano_id`: Filtrar por rebaño
- `sexo`: Filtrar por sexo (M/F)

**Control de Acceso:**
- `admin`: Ve todos los animales
- `propietario`: Ve solo animales de sus fincas

#### POST `/animales` 🔒
Crea un nuevo animal.

**Campos Requeridos:**
```json
{
    "id_Rebano": "integer (debe existir)",
    "Nombre": "string (máx. 25 caracteres, opcional)",
    "codigo_animal": "string (máx. 20 caracteres, único, opcional)",
    "Sexo": "string (M|F)",
    "fecha_nacimiento": "date (YYYY-MM-DD)",
    "Procedencia": "string (máx. 50 caracteres, opcional)",
    "fk_composicion_raza": "integer"
}
```

#### GET `/animales/{id}` 🔒
Obtiene detalles completos de un animal incluyendo peso, celo, reproducción y servicios.

#### PUT `/animales/{id}` 🔒
Actualiza un animal existente.

#### DELETE `/animales/{id}` 🔒
Elimina un animal (eliminación suave).

### 🦌 Inventario de Búfalo

#### GET `/inventarios-bufalo` 🔒
Lista los inventarios de búfalo según los permisos del usuario.

**Parámetros de Query Opcionales:**
- `finca_id`: Filtrar por finca

#### POST `/inventarios-bufalo` 🔒
Crea un nuevo inventario de búfalo.

**Campos Requeridos:**
```json
{
    "id_Finca": "integer (debe existir)",
    "Num_Becerro": "integer (min: 0, opcional)",
    "Num_Anojo": "integer (min: 0, opcional)",
    "Num_Bubilla": "integer (min: 0, opcional)",
    "Num_Bufalo": "integer (min: 0, opcional)",
    "Fecha_Inventario": "date (YYYY-MM-DD)"
}
```

#### GET `/inventarios-bufalo/{id}` 🔒
Obtiene detalles de un inventario específico.

#### PUT `/inventarios-bufalo/{id}` 🔒
Actualiza un inventario existente.

#### DELETE `/inventarios-bufalo/{id}` 🔒
Elimina un inventario (eliminación física).

### 🏷️ Tipos de Animal

#### GET `/tipos-animal` 🔒
Lista todos los tipos de animal disponibles.

**Parámetros de Query Opcionales:**
- `search`: Buscar por nombre

#### POST `/tipos-animal` 🔒
Crea un nuevo tipo de animal (solo admin).

**Campos Requeridos:**
```json
{
    "tipo_animal_nombre": "string (máx. 40 caracteres, solo letras, números y espacios)"
}
```

#### GET `/tipos-animal/{id}` 🔒
Obtiene detalles de un tipo de animal específico.

#### PUT `/tipos-animal/{id}` 🔒
Actualiza un tipo de animal (solo admin).

#### DELETE `/tipos-animal/{id}` 🔒
Elimina un tipo de animal (solo admin).

### 🏥 Estados de Salud

#### GET `/estados-salud` 🔒
Lista todos los estados de salud disponibles.

**Parámetros de Query Opcionales:**
- `search`: Buscar por nombre

#### POST `/estados-salud` 🔒
Crea un nuevo estado de salud (solo admin).

**Campos Requeridos:**
```json
{
    "estado_nombre": "string (máx. 40 caracteres, solo letras, números y espacios)"
}
```

#### GET `/estados-salud/{id}` 🔒
Obtiene detalles de un estado de salud específico con historial de uso.

#### PUT `/estados-salud/{id}` 🔒
Actualiza un estado de salud (solo admin).

#### DELETE `/estados-salud/{id}` 🔒
Elimina un estado de salud (solo admin, no permitido si está en uso).

### 📋 Estados de Animal

#### GET `/estados-animal` 🔒
Lista los estados de salud de animales según los permisos del usuario.

**Parámetros de Query Opcionales:**
- `animal_id`: Filtrar por animal específico
- `estado_id`: Filtrar por estado de salud
- `active=true`: Solo estados activos (sin fecha fin)

**Control de Acceso:**
- `admin`: Ve todos los estados de animales
- `propietario`: Ve solo estados de sus animales

#### POST `/estados-animal` 🔒
Registra un nuevo estado de salud para un animal.

**Campos Requeridos:**
```json
{
    "esan_fecha_ini": "date (YYYY-MM-DD)",
    "esan_fecha_fin": "date (YYYY-MM-DD, opcional, debe ser >= fecha_ini)",
    "esan_fk_estado_id": "integer (debe existir en estados_salud)",
    "esan_fk_id_animal": "integer (debe existir)"
}
```

#### GET `/estados-animal/{id}` 🔒
Obtiene detalles completos de un estado de animal específico.

#### PUT `/estados-animal/{id}` 🔒
Actualiza un estado de animal existente.

#### DELETE `/estados-animal/{id}` 🔒
Elimina un registro de estado de animal.

## Colección de Postman

En esta carpeta encontrarás:

### 📁 Archivos Incluidos
- `GanaderaSoft-API.postman_collection.json` - Colección completa con todos los endpoints
- `GanaderaSoft-Environment.postman_environment.json` - Variables de entorno para Postman

### 🚀 Cómo Importar

1. **Abrir Postman**
2. **Importar Colección:**
   - Click en "Import"
   - Seleccionar el archivo `GanaderaSoft-API.postman_collection.json`
3. **Importar Entorno:**
   - Click en "Import"
   - Seleccionar el archivo `GanaderaSoft-Environment.postman_environment.json`
4. **Seleccionar Entorno:**
   - En la esquina superior derecha, seleccionar "GanaderaSoft Environment"

### ⚙️ Configuración del Entorno

La colección incluye variables de entorno pre-configuradas:

- `base_url`: URL base de la API (default: http://localhost:8000)
- `auth_token`: Token de autenticación (se establece automáticamente tras login/register)

## Ejemplos de Uso

### Ejemplo 1: Registro Completo de Usuario y Propietario

```bash
# 1. Registrar usuario
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "name": "Juan Pérez",
    "email": "juan@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "type_user": "propietario"
  }'

# 2. Crear propietario (usando el token obtenido)
curl -X POST http://localhost:8000/api/propietarios \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui" \
  -d '{
    "id": 1,
    "Nombre": "Juan",
    "Apellido": "Pérez",
    "Telefono": "+57 300 123 4567"
  }'

# 3. Crear finca
curl -X POST http://localhost:8000/api/fincas \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui" \
  -d '{
    "Nombre": "Finca La Esperanza",
    "Explotacion_Tipo": "Bovinos",
    "id_Propietario": 1
  }'
```

### Ejemplo 2: Gestión de Rebaños y Animales

```bash
# 1. Crear rebaño
curl -X POST http://localhost:8000/api/rebanos \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui" \
  -d '{
    "id_Finca": 1,
    "Nombre": "Rebaño Principal"
  }'

# 2. Crear animal
curl -X POST http://localhost:8000/api/animales \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui" \
  -d '{
    "id_Rebano": 1,
    "Nombre": "Esperanza",
    "codigo_animal": "ESP-001",
    "Sexo": "F",
    "fecha_nacimiento": "2022-03-15",
    "Procedencia": "Finca San José",
    "fk_composicion_raza": 1
  }'

# 3. Listar animales de un rebaño específico
curl -X GET "http://localhost:8000/api/animales?rebano_id=1" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui"
```

### Ejemplo 3: Inventario de Búfalo

```bash
# 1. Crear inventario
curl -X POST http://localhost:8000/api/inventarios-bufalo \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui" \
  -d '{
    "id_Finca": 1,
    "Num_Becerro": 15,
    "Num_Anojo": 12,
    "Num_Bubilla": 8,
    "Num_Bufalo": 25,
    "Fecha_Inventario": "2024-01-15"
  }'

# 2. Consultar inventarios de una finca
curl -X GET "http://localhost:8000/api/inventarios-bufalo?finca_id=1" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui"
```

### Ejemplo 4: Gestión de Tipos de Animal (Admin)

```bash
# 1. Crear tipo de animal (solo admin)
curl -X POST http://localhost:8000/api/tipos-animal \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|admin_token_aqui" \
  -d '{
    "tipo_animal_nombre": "Bovino Criollo"
  }'

# 2. Buscar tipos de animal
curl -X GET "http://localhost:8000/api/tipos-animal?search=bovino" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui"
```

### Ejemplo 5: Login y Consulta Completa

```bash
# 1. Login
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "email": "juan@example.com",
    "password": "password123"
  }'

# 2. Consultar perfil completo
curl -X GET http://localhost:8000/api/profile \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui"

# 3. Listar todas las fincas del propietario
curl -X GET http://localhost:8000/api/fincas \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui"

# 4. Obtener detalles completos de un animal
curl -X GET http://localhost:8000/api/animales/1 \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|token_aqui"
```

## Códigos de Error

| Código | Significado | Descripción |
|--------|-------------|-------------|
| 200 | OK | Solicitud exitosa |
| 201 | Created | Recurso creado exitosamente |
| 401 | Unauthorized | Token inválido o faltante |
| 403 | Forbidden | Sin permisos para el recurso |
| 404 | Not Found | Recurso no encontrado |
| 422 | Unprocessable Entity | Errores de validación |
| 500 | Internal Server Error | Error interno del servidor |

### Estructura de Respuesta de Error

```json
{
    "success": false,
    "message": "Descripción del error",
    "errors": {
        "campo": ["Mensaje de error específico"]
    }
}
```

## Tipos de Usuario

### 👨‍💼 Admin
- Acceso completo a todos los recursos
- Puede gestionar fincas de cualquier propietario
- Puede cambiar la propiedad de las fincas

### 🏡 Propietario
- Puede gestionar solo sus propias fincas
- No puede cambiar la propiedad de las fincas
- Acceso limitado a recursos del sistema

### 🔧 Técnico
- Acceso limitado para soporte técnico
- Permisos específicos según configuración

## Seguridad

### Hashing de Passwords
Los passwords son hasheados de forma segura utilizando:
- `Illuminate\Support\Facades\Hash::make()` para crear hashes
- `Auth::attempt()` para validación segura durante el login
- Algoritmo bcrypt por defecto de Laravel

### Autenticación
- Laravel Sanctum para gestión de tokens
- Tokens de acceso personal
- Revocación de tokens en logout

## Notas Importantes

1. **Eliminación Suave**: Las fincas no se eliminan físicamente, se marcan como archivadas
2. **Paginación**: Los listados incluyen paginación automática (15 elementos por página)
3. **Validación**: Todos los campos son validados según las reglas definidas
4. **Relaciones**: Las respuestas incluyen relaciones con propietarios y usuarios
5. **Tokens**: Los tokens se establecen automáticamente en las requests de Postman tras login/register exitoso

---

Para más información o soporte, contacta al equipo de desarrollo de GanaderaSoft.