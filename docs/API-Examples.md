# API Usage Examples

Este archivo contiene ejemplos prácticos de cómo usar la API completa de GanaderaSoft.

## Configuración Base

```bash
BASE_URL="http://localhost:8000/api"
```

## 1. Flujo Completo: Registro y Configuración Inicial

### Paso 1: Registro de Usuario
```bash
curl -X POST ${BASE_URL}/auth/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "name": "Juan Pérez",
    "email": "juan@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "type_user": "propietario"
  }'
```

**Respuesta esperada:**
```json
{
  "success": true,
  "message": "Usuario registrado exitosamente",
  "data": {
    "user": {
      "id": 1,
      "name": "Juan Pérez",
      "email": "juan@example.com",
      "type_user": "propietario",
      "image": "user.png"
    },
    "token": "1|token_aquí",
    "token_type": "Bearer"
  }
}
```

### Paso 2: Crear Propietario
```bash
TOKEN="1|tu_token_aquí"

curl -X POST ${BASE_URL}/propietarios \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "id": 1,
    "Nombre": "Juan",
    "Apellido": "Pérez",
    "Telefono": "+57 300 123 4567"
  }'
```

### Paso 3: Crear Finca
```bash
curl -X POST ${BASE_URL}/fincas \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "Nombre": "Finca La Esperanza",
    "Explotacion_Tipo": "Bovinos",
    "id_Propietario": 1
  }'
```

### Paso 4: Crear Rebaño
```bash
curl -X POST ${BASE_URL}/rebanos \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "id_Finca": 1,
    "Nombre": "Rebaño Principal"
  }'
```

### Paso 5: Registrar Animal
```bash
curl -X POST ${BASE_URL}/animales \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "id_Rebano": 1,
    "Nombre": "Esperanza",
    "codigo_animal": "ESP-001",
    "Sexo": "F",
    "fecha_nacimiento": "2022-03-15",
    "Procedencia": "Finca San José",
    "fk_composicion_raza": 1
  }'
```

## 2. Gestión de Inventarios

### Crear Inventario de Búfalo
```bash
curl -X POST ${BASE_URL}/inventarios-bufalo \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "id_Finca": 1,
    "Num_Becerro": 15,
    "Num_Anojo": 12,
    "Num_Bubilla": 8,
    "Num_Bufalo": 25,
    "Fecha_Inventario": "2024-01-15"
  }'
```

### Consultar Inventarios por Finca
```bash
curl -X GET "${BASE_URL}/inventarios-bufalo?finca_id=1" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

## 3. Gestión de Animales

### Listar Animales con Filtros
```bash
# Todos los animales
curl -X GET ${BASE_URL}/animales \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"

# Animales por rebaño
curl -X GET "${BASE_URL}/animales?rebano_id=1" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"

# Animales por sexo
curl -X GET "${BASE_URL}/animales?sexo=F" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"

# Combinando filtros
curl -X GET "${BASE_URL}/animales?rebano_id=1&sexo=M" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

### Obtener Detalles Completos de un Animal
```bash
curl -X GET ${BASE_URL}/animales/1 \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

**Respuesta incluye relaciones:**
```json
{
  "success": true,
  "message": "Detalle de animal",
  "data": {
    "id_Animal": 1,
    "Nombre": "Esperanza",
    "codigo_animal": "ESP-001",
    "Sexo": "F",
    "fecha_nacimiento": "2022-03-15",
    "rebano": {
      "id_Rebano": 1,
      "Nombre": "Rebaño Principal",
      "finca": {
        "id_Finca": 1,
        "Nombre": "Finca La Esperanza",
        "propietario": {
          "id": 1,
          "Nombre": "Juan",
          "Apellido": "Pérez"
        }
      }
    },
    "pesosCorporales": [],
    "registrosCelo": [],
    "reproducciones": [],
    "servicios": []
  }
}
```

## 4. Gestión de Tipos de Animal (Solo Admin)

### Crear Tipo de Animal
```bash
# Requiere token de admin
ADMIN_TOKEN="1|admin_token_aquí"

curl -X POST ${BASE_URL}/tipos-animal \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  -d '{
    "tipo_animal_nombre": "Bovino Criollo"
  }'
```

### Buscar Tipos de Animal
```bash
curl -X GET "${BASE_URL}/tipos-animal?search=bovino" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

## 5. Operaciones de Actualización

### Actualizar Propietario
```bash
curl -X PUT ${BASE_URL}/propietarios/1 \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "Telefono": "+57 300 999 8888"
  }'
```

### Actualizar Animal
```bash
curl -X PUT ${BASE_URL}/animales/1 \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "Nombre": "Nueva Esperanza",
    "codigo_animal": "ESP-001-UPD"
  }'
```

### Mover Animal a Otro Rebaño
```bash
curl -X PUT ${BASE_URL}/animales/1 \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "id_Rebano": 2
  }'
```

## 6. Inicio de Sesión y Consultas

### Login
```bash
curl -X POST ${BASE_URL}/auth/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "email": "juan@example.com",
    "password": "password123"
  }'
```

### Verificar Perfil
```bash
curl -X GET ${BASE_URL}/profile \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

### Consultar Todas las Entidades del Propietario
```bash
# Fincas
curl -X GET ${BASE_URL}/fincas \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"

# Rebaños
curl -X GET ${BASE_URL}/rebanos \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"

# Animales
curl -X GET ${BASE_URL}/animales \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"

# Inventarios
curl -X GET ${BASE_URL}/inventarios-bufalo \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

## 7. Operaciones de Eliminación

### Eliminar Animal (Soft Delete)
```bash
curl -X DELETE ${BASE_URL}/animales/1 \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

### Eliminar Rebaño (Solo si no tiene animales)
```bash
curl -X DELETE ${BASE_URL}/rebanos/1 \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

### Eliminar Finca (Soft Delete)
```bash
curl -X DELETE ${BASE_URL}/fincas/1 \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

## 8. Manejo de Errores Comunes

### Error 401 - No Autorizado
```bash
# Request sin token
curl -X GET ${BASE_URL}/fincas \
  -H "Accept: application/json"

# Respuesta:
# {
#   "message": "Unauthenticated."
# }
```

### Error 403 - Sin Permisos
```bash
# Propietario intentando acceder a finca de otro
curl -X GET ${BASE_URL}/fincas/999 \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"

# Respuesta:
# {
#   "success": false,
#   "message": "No tiene permisos para ver esta finca"
# }
```

### Error 422 - Validación
```bash
# Datos inválidos
curl -X POST ${BASE_URL}/animales \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{
    "Sexo": "X",
    "fecha_nacimiento": "invalid-date"
  }'

# Respuesta:
# {
#   "success": false,
#   "message": "Datos de validación incorrectos",
#   "errors": {
#     "id_Rebano": ["El campo id rebano es obligatorio."],
#     "Sexo": ["El campo sexo seleccionado es inválido."]
#   }
# }
```

## 9. Testing de Seguridad de Passwords

### Verificar Hash de Passwords
```bash
# Registro con password
curl -X POST ${BASE_URL}/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "type_user": "propietario"
  }'

# Login correcto (debe funcionar)
curl -X POST ${BASE_URL}/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'

# Login incorrecto (debe fallar)
curl -X POST ${BASE_URL}/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "wrongpassword"
  }'
```

## 10. Paginación

### Navegar por Páginas
```bash
# Primera página (por defecto)
curl -X GET ${BASE_URL}/animales \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"

# Segunda página
curl -X GET "${BASE_URL}/animales?page=2" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

## Notas Importantes

1. **Tokens de Autenticación**: Los tokens se generan automáticamente y deben incluirse en todas las requests protegidas
2. **Permisos por Rol**: 
   - `admin`: Acceso completo
   - `propietario`: Solo sus recursos
   - `tecnico`: Acceso de solo lectura (implementación futura)
3. **Validaciones**: Todos los campos son validados según las reglas definidas
4. **Eliminación Suave**: Fincas, rebaños y animales se marcan como archivados, no se eliminan físicamente
5. **Relaciones**: Los endpoints de detalle incluyen relaciones automáticamente
6. **Paginación**: 15 elementos por página por defecto