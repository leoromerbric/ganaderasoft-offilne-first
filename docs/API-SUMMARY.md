# GanaderaSoft API - Complete Endpoint Summary

## Overview
GanaderaSoft API provides comprehensive REST endpoints for managing livestock operations. All endpoints follow RESTful conventions and require authentication via Laravel Sanctum tokens (except auth endpoints).

## Base URL
```
http://localhost:8000/api
```

## Authentication Headers
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}  (for protected endpoints)
```

## Complete Endpoint List

### 🔐 Authentication (4 endpoints)
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/auth/register` | Register new user | ❌ |
| POST | `/auth/login` | User login | ❌ |
| GET | `/profile` | Get user profile | ✅ |
| POST | `/auth/logout` | User logout | ✅ |

### 👨‍💼 Propietarios - Property Owners (5 endpoints)
| Method | Endpoint | Description | Auth Required | Admin Only |
|--------|----------|-------------|---------------|------------|
| GET | `/propietarios` | List property owners | ✅ | ❌ |
| POST | `/propietarios` | Create property owner | ✅ | ❌ |
| GET | `/propietarios/{id}` | Get property owner details | ✅ | ❌ |
| PUT | `/propietarios/{id}` | Update property owner | ✅ | ❌ |
| DELETE | `/propietarios/{id}` | Delete property owner | ✅ | ✅ |

**Query Parameters:**
- None

**Permissions:**
- Admin: Can manage all property owners
- Propietario: Can only view/manage their own record

### 🏡 Fincas - Farms (5 endpoints)
| Method | Endpoint | Description | Auth Required | Admin Only |
|--------|----------|-------------|---------------|------------|
| GET | `/fincas` | List farms | ✅ | ❌ |
| POST | `/fincas` | Create farm | ✅ | ❌ |
| GET | `/fincas/{id}` | Get farm details | ✅ | ❌ |
| PUT | `/fincas/{id}` | Update farm | ✅ | ❌ |
| DELETE | `/fincas/{id}` | Delete farm (soft delete) | ✅ | ❌ |

**Query Parameters:**
- `page`: Page number for pagination

**Permissions:**
- Admin: Can manage all farms
- Propietario: Can only manage their own farms

### 🐄 Rebaños - Herds (5 endpoints)
| Method | Endpoint | Description | Auth Required | Admin Only |
|--------|----------|-------------|---------------|------------|
| GET | `/rebanos` | List herds | ✅ | ❌ |
| POST | `/rebanos` | Create herd | ✅ | ❌ |
| GET | `/rebanos/{id}` | Get herd details | ✅ | ❌ |
| PUT | `/rebanos/{id}` | Update herd | ✅ | ❌ |
| DELETE | `/rebanos/{id}` | Delete herd (if no animals) | ✅ | ❌ |

**Query Parameters:**
- `page`: Page number for pagination

**Permissions:**
- Admin: Can manage all herds
- Propietario: Can only manage herds in their farms

### 🐂 Animales - Animals (5 endpoints)
| Method | Endpoint | Description | Auth Required | Admin Only |
|--------|----------|-------------|---------------|------------|
| GET | `/animales` | List animals with filters | ✅ | ❌ |
| POST | `/animales` | Create animal | ✅ | ❌ |
| GET | `/animales/{id}` | Get animal details with relationships | ✅ | ❌ |
| PUT | `/animales/{id}` | Update animal | ✅ | ❌ |
| DELETE | `/animales/{id}` | Delete animal (soft delete) | ✅ | ❌ |

**Query Parameters:**
- `rebano_id`: Filter by herd ID
- `sexo`: Filter by sex (M/F)
- `page`: Page number for pagination

**Permissions:**
- Admin: Can manage all animals
- Propietario: Can only manage animals in their herds

### 🦌 Inventarios Búfalo - Buffalo Inventories (5 endpoints)
| Method | Endpoint | Description | Auth Required | Admin Only |
|--------|----------|-------------|---------------|------------|
| GET | `/inventarios-bufalo` | List buffalo inventories | ✅ | ❌ |
| POST | `/inventarios-bufalo` | Create buffalo inventory | ✅ | ❌ |
| GET | `/inventarios-bufalo/{id}` | Get inventory details | ✅ | ❌ |
| PUT | `/inventarios-bufalo/{id}` | Update inventory | ✅ | ❌ |
| DELETE | `/inventarios-bufalo/{id}` | Delete inventory (hard delete) | ✅ | ❌ |

**Query Parameters:**
- `finca_id`: Filter by farm ID
- `page`: Page number for pagination

**Permissions:**
- Admin: Can manage all inventories
- Propietario: Can only manage inventories in their farms

### 🏷️ Tipos de Animal - Animal Types (5 endpoints)
| Method | Endpoint | Description | Auth Required | Admin Only |
|--------|----------|-------------|---------------|------------|
| GET | `/tipos-animal` | List animal types | ✅ | ❌ |
| POST | `/tipos-animal` | Create animal type | ✅ | ✅ |
| GET | `/tipos-animal/{id}` | Get animal type details | ✅ | ❌ |
| PUT | `/tipos-animal/{id}` | Update animal type | ✅ | ✅ |
| DELETE | `/tipos-animal/{id}` | Delete animal type | ✅ | ✅ |

**Query Parameters:**
- `search`: Search by type name
- `page`: Page number for pagination

**Permissions:**
- Admin: Full CRUD access
- Propietario/Tecnico: Read-only access

### 🏥 Estados de Salud - Health Status (5 endpoints)
| Method | Endpoint | Description | Auth Required | Admin Only |
|--------|----------|-------------|---------------|------------|
| GET | `/estados-salud` | List health statuses | ✅ | ❌ |
| POST | `/estados-salud` | Create health status | ✅ | ✅ |
| GET | `/estados-salud/{id}` | Get health status details | ✅ | ❌ |
| PUT | `/estados-salud/{id}` | Update health status | ✅ | ✅ |
| DELETE | `/estados-salud/{id}` | Delete health status | ✅ | ✅ |

**Query Parameters:**
- `search`: Search by status name
- `page`: Page number for pagination

**Permissions:**
- Admin: Full CRUD access
- Propietario/Tecnico: Read-only access

### 📋 Estados de Animal - Animal Health Records (5 endpoints)
| Method | Endpoint | Description | Auth Required | Admin Only |
|--------|----------|-------------|---------------|------------|
| GET | `/estados-animal` | List animal health records | ✅ | ❌ |
| POST | `/estados-animal` | Create animal health record | ✅ | ❌ |
| GET | `/estados-animal/{id}` | Get health record details | ✅ | ❌ |
| PUT | `/estados-animal/{id}` | Update health record | ✅ | ❌ |
| DELETE | `/estados-animal/{id}` | Delete health record | ✅ | ❌ |

**Query Parameters:**
- `animal_id`: Filter by animal ID
- `estado_id`: Filter by health status ID
- `active=true`: Only active health records (no end date)
- `page`: Page number for pagination

**Permissions:**
- Admin: Can manage all health records
- Propietario: Can only manage health records for their animals

## Summary Statistics

**Total Endpoints:** 54
- **Public Endpoints:** 2 (register, login)
- **Protected Endpoints:** 52
- **Admin-Only Operations:** 12
- **CRUD Resources:** 8 main entities
- **Query Filters:** 10+ different filter options

## Response Format

All endpoints return consistent JSON responses:

### Success Response
```json
{
    "success": true,
    "message": "Operation description",
    "data": {
        // Response data
    }
}
```

### Error Response
```json
{
    "success": false,
    "message": "Error description",
    "errors": {
        "field": ["Validation error message"]
    }
}
```

## HTTP Status Codes Used

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | OK | Successful GET, PUT operations |
| 201 | Created | Successful POST operations |
| 401 | Unauthorized | Missing or invalid token |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Resource conflict (e.g., cannot delete) |
| 422 | Unprocessable Entity | Validation errors |
| 500 | Internal Server Error | Server errors |

## Data Relationships

```
User ←→ Propietario ←→ Finca ←→ Rebano ←→ Animal
                   ↓                     ↓
            InventarioBufalo        EstadoAnimal
                                        ↓
                                  EstadoSalud
                                        
Animal → TipoAnimal (reference)
```

## Key Features

1. **Role-Based Access Control:** Admin, Propietario, Tecnico roles with different permissions
2. **Resource Ownership:** Propietarios can only access their own resources
3. **Soft Deletes:** Important entities use archiving instead of physical deletion
4. **Eager Loading:** Related data is automatically included where relevant
5. **Pagination:** All list endpoints include pagination (15 items per page)
6. **Filtering:** Advanced filtering capabilities on relevant endpoints
7. **Validation:** Comprehensive server-side validation on all inputs
8. **Health Tracking:** Complete health status management for animals
9. **Inventory Management:** Buffalo inventory tracking by farm
10. **Audit Trail:** Created/updated timestamps on all relevant entities

## Testing

Use the provided Postman collection (`GanaderaSoft-API-Complete.postman_collection.json`) for comprehensive API testing. The collection includes:

- All 54 endpoints organized by category
- Pre-request scripts for token management
- Environment variables for easy configuration
- Example request bodies for all POST/PUT operations
- Automated token saving after login/register

## Getting Started

1. **Register a user:** POST `/auth/register`
2. **Login to get token:** POST `/auth/login`
3. **Create propietario:** POST `/propietarios`
4. **Create finca:** POST `/fincas`
5. **Create rebano:** POST `/rebanos`
6. **Add animals:** POST `/animales`
7. **Track health:** POST `/estados-animal`
8. **Manage inventory:** POST `/inventarios-bufalo`

For detailed examples, see `API-Examples.md` and the complete API documentation in `README.md`.