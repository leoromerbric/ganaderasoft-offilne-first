# Implementación de Nuevas APIs de Configuración - Resumen

## APIs de Configuración Implementadas

### 1. APIs basadas en JSON (Datos Constantes)
Estas APIs leen datos desde archivos JSON almacenados en `resources/datos-constantes/`:

- **GET /api/configuracion/tipo-explotacion**
  - Valores: Intensiva, Extensiva, Compuesta, Otro
  
- **GET /api/configuracion/metodo-riego** 
  - Valores: Aspersión, Inundación, Surco con salida, Surco sin salida, Goteo, Otro
  
- **GET /api/configuracion/ph-suelo**
  - Valores: 1-7 con descripciones (Extremadamente ácido hasta Neutro)
  
- **GET /api/configuracion/textura-suelo**
  - Valores: Arcilla, Arcillo arenoso, Arcillo limoso, Franco, Franco arcillo arenoso, Franco limoso, Franco arenoso, Limoso, Otro
  
- **GET /api/configuracion/fuente-agua**
  - Valores: Superficial, Subterránea, Toma directa de río, Sistema de Riego, Otro
  
- **GET /api/configuracion/sexo**
  - Valores: M (Macho), H (Hembra)

### 2. APIs basadas en Base de Datos

- **Composición Raza**: `/api/composicion-raza`
  - GET, POST, PUT, DELETE para gestionar composiciones de raza
  - Incluye relaciones con finca y tipo de animal
  
- **Etapa**: `/api/etapas` 
  - GET, POST, PUT, DELETE para gestionar etapas de animales
  - Solo administradores pueden crear/editar/eliminar
  
- **Estado Salud**: `/api/estados-salud` (ya existía)

## Modificaciones a APIs Existentes

### Animal API
Se agregó soporte para gestionar relaciones etapa_animal y estado_animal:

- **POST /api/animales** - Ahora acepta `estado_inicial` y `etapa_inicial`
- **POST /api/animales/{animal}/estado-animal** - Crear nuevo estado para animal
- **PUT /api/animales/{animal}/estado-animal/{estado}** - Actualizar estado existente
- **POST /api/animales/{animal}/etapa-animal** - Crear nueva etapa para animal  
- **PUT /api/animales/{animal}/etapa-animal/{etapa}** - Actualizar etapa existente

### Finca API
Se agregó soporte completo para datos de terreno:

- **POST /api/fincas** - Ahora acepta objeto `terreno` opcional
- **GET /api/fincas/{id}** - Incluye datos de terreno si existen
- **PUT /api/fincas/{id}** - Permite actualizar datos de terreno

## Modelos Creados

1. **ComposicionRaza** - Gestiona las composiciones de raza
2. **Etapa** - Define las etapas de vida de los animales
3. **EtapaAnimal** - Relación many-to-many entre animales y etapas
4. **Terreno** - Datos del terreno asociado a una finca

## Controladores Creados

1. **ConfiguracionController** - Maneja todas las APIs de configuración JSON
2. **ComposicionRazaController** - CRUD para composiciones de raza
3. **EtapaController** - CRUD para etapas (solo admin)

## Colección Postman Actualizada

La colección `GanaderaSoft-API-Complete.postman_collection.json` fue actualizada con:

- Carpeta de Configuración con todos los endpoints nuevos
- Carpeta de Composición Raza con CRUD completo
- Carpeta de Etapas con CRUD completo
- Carpeta de Relaciones de Animal con endpoints de gestión
- Actualizaciones en endpoints de Finca y Animal existentes

## Ejemplos de Uso

### Crear Animal con Estado y Etapa Inicial
```json
POST /api/animales
{
    "id_Rebano": 1,
    "Nombre": "Toro123",
    "Sexo": "M",
    "fecha_nacimiento": "2024-01-01",
    "fk_composicion_raza": 1,
    "estado_inicial": {
        "estado_id": 1,
        "fecha_ini": "2024-01-01"
    },
    "etapa_inicial": {
        "etapa_id": 1,
        "fecha_ini": "2024-01-01"
    }
}
```

### Crear Finca con Datos de Terreno
```json
POST /api/fincas
{
    "Nombre": "Finca El Progreso",
    "Explotacion_Tipo": "Bovinos",
    "id_Propietario": 1,
    "terreno": {
        "Superficie": 10.5,
        "Relieve": "Plano",
        "Suelo_Textura": "Franco",
        "ph_Suelo": "6",
        "Fuente_Agua": "Superficial",
        "Riego_Metodo": "Aspersión"
    }
}
```

## Consideraciones de Seguridad

- Todas las APIs requieren autenticación Bearer token
- Los propietarios solo pueden gestionar sus propios recursos
- Solo administradores pueden gestionar etapas
- Se validan permisos en todas las operaciones

## Archivos de Configuración JSON

Los datos constantes están almacenados en:
- `resources/datos-constantes/tipo-explotacion.json`
- `resources/datos-constantes/metodo-riego.json`
- `resources/datos-constantes/ph-suelo.json`
- `resources/datos-constantes/textura-suelo.json`
- `resources/datos-constantes/fuente-agua.json`
- `resources/datos-constantes/sexo.json`

Estos archivos pueden ser modificados directamente sin necesidad de cambios en la base de datos.