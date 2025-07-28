# API Usage Examples

Este archivo contiene ejemplos prácticos de cómo usar la API de GanaderaSoft.

## Configuración Base

```bash
BASE_URL="http://localhost:8000/api"
```

## 1. Registro de Usuario

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

## 2. Inicio de Sesión

```bash
curl -X POST ${BASE_URL}/auth/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "email": "juan@example.com",
    "password": "password123"
  }'
```

## 3. Verificar Autenticación

```bash
TOKEN="tu_token_aquí"

curl -X GET ${BASE_URL}/user \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

## 4. Verificar Hash de Password

Los passwords son automáticamente hasheados usando `Illuminate\Support\Facades\Hash`:

- **Registro**: `Hash::make($request->password)` convierte "password123" en algo como "$2y$12$D9l8qyKj.ZY9eBm29HljC..."
- **Login**: `Auth::attempt()` compara automáticamente el password plano con el hash almacenado

## 5. Gestión de Fincas (requiere token)

### Listar fincas
```bash
curl -X GET ${BASE_URL}/fincas \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

### Crear finca
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

## 6. Cerrar Sesión

```bash
curl -X POST ${BASE_URL}/auth/logout \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ${TOKEN}"
```

## Notas Importantes

1. **Seguridad del Password**: Todos los passwords son hasheados usando bcrypt a través de Laravel Hash facade
2. **Tokens**: Los tokens de autenticación se generan automáticamente y deben incluirse en todas las requests protegidas
3. **Tipos de Usuario**: admin, propietario, tecnico - cada uno con diferentes permisos de acceso
4. **Validación**: Todos los campos son validados según las reglas definidas en los controladores

## Testing de Password Hash

Para verificar que el password hashing funciona correctamente:

1. Registra un usuario
2. Intenta iniciar sesión con el password correcto (debe funcionar)
3. Intenta iniciar sesión con un password incorrecto (debe fallar)

Ejemplo:
```bash
# Correcto
curl -X POST ${BASE_URL}/auth/login -H "Content-Type: application/json" -d '{"email":"test@example.com","password":"password123"}'
# Resultado: Login exitoso

# Incorrecto  
curl -X POST ${BASE_URL}/auth/login -H "Content-Type: application/json" -d '{"email":"test@example.com","password":"wrongpassword"}'
# Resultado: Credenciales inválidas
```