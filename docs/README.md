# GanaderaSoft API Documentation

Esta documentación describe cómo consumir la API de GanaderaSoft, un sistema de gestión ganadera diseñado para administrar fincas, propietarios y ganado.

## Contenido

- [Configuración Inicial](#configuración-inicial)
- [Autenticación](#autenticación)
- [Endpoints Disponibles](#endpoints-disponibles)
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

**Respuesta Exitosa (200):**
```json
{
    "success": true,
    "message": "Login exitoso",
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

#### GET `/profile` 🔒
Obtiene el perfil del usuario autenticado.

**Headers:**
```
Authorization: Bearer {token}
```

#### POST `/auth/logout` 🔒
Cierra sesión y revoca el token actual.

**Headers:**
```
Authorization: Bearer {token}
```

### 🏡 Gestión de Fincas

#### GET `/fincas` 🔒
Lista las fincas según los permisos del usuario.

**Parámetros de Query:**
- `page`: Número de página para paginación (opcional)

**Control de Acceso:**
- `admin`: Ve todas las fincas
- `propietario`: Ve solo sus fincas
- `tecnico`: Acceso limitado

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

**Control de Acceso:**
- `admin`: Puede crear fincas para cualquier propietario
- `propietario`: Solo puede crear fincas para sí mismo

#### GET `/fincas/{id}` 🔒
Obtiene detalles de una finca específica.

#### PUT `/fincas/{id}` 🔒
Actualiza una finca existente.

**Campos Opcionales:**
```json
{
    "Nombre": "string (máx. 25 caracteres)",
    "Explotacion_Tipo": "string (máx. 20 caracteres)",
    "id_Propietario": "integer (solo admin)"
}
```

#### DELETE `/fincas/{id}` 🔒
Elimina una finca (eliminación suave - se marca como archivada).

### 📊 Sistema

#### GET `/health`
Verifica el estado de la API.

#### GET `/test/database`
Prueba la conectividad con la base de datos.

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

### Ejemplo 1: Registro y Creación de Finca

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

# 2. Crear finca (usando el token obtenido)
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

### Ejemplo 2: Login y Consulta de Fincas

```bash
# 1. Login
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "email": "juan@example.com",
    "password": "password123"
  }'

# 2. Listar fincas
curl -X GET http://localhost:8000/api/fincas \
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