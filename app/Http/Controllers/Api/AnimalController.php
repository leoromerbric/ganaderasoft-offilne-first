<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Animal;
use App\Models\Rebano;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Validator;

class AnimalController extends Controller
{
    /**
     * Display a listing of animals.
     */
    public function index(Request $request)
    {
        $user = $request->user();
        
        // Build query with filters
        $query = Animal::with(['rebano.finca.propietario', 'composicionRaza'])
            ->active();
            
        // Apply filters
        if ($request->has('rebano_id')) {
            $query->forRebano($request->rebano_id);
        }
        
        if ($request->has('sexo')) {
            $query->bySex($request->sexo);
        }
        
        // If user is admin, show all animals
        if ($user->isAdmin()) {
            $animals = $query->paginate(15);
        } else {
            // If user is propietario, show only animals from their fincas
            $propietario = $user->propietario;
            if (!$propietario) {
                return response()->json([
                    'success' => false,
                    'message' => 'Usuario no es propietario'
                ], Response::HTTP_FORBIDDEN);
            }
            
            $animals = $query->whereHas('rebano.finca', function ($q) use ($propietario) {
                $q->where('id_Propietario', $propietario->id);
            })->paginate(15);
        }

        return response()->json([
            'success' => true,
            'message' => 'Lista de animales',
            'data' => $animals
        ]);
    }

    /**
     * Store a newly created animal.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'id_Rebano' => 'required|exists:rebano,id_Rebano',
            'Nombre' => 'nullable|string|max:25',
            'codigo_animal' => 'nullable|string|max:20|unique:animal,codigo_animal',
            'Sexo' => 'required|in:M,F',
            'fecha_nacimiento' => 'required|date',
            'Procedencia' => 'nullable|string|max:50',
            'fk_composicion_raza' => 'required|integer'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        $user = $request->user();
        
        // Check permissions: admin can create for any rebano, propietario only for their rebanos
        if (!$user->isAdmin()) {
            $propietario = $user->propietario;
            if (!$propietario) {
                return response()->json([
                    'success' => false,
                    'message' => 'Usuario no es propietario'
                ], Response::HTTP_FORBIDDEN);
            }
            
            $rebano = Rebano::with('finca')->find($request->id_Rebano);
            if (!$rebano || $rebano->finca->id_Propietario != $propietario->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'No tiene permisos para crear animal en este rebaño'
                ], Response::HTTP_FORBIDDEN);
            }
        }

        $animal = Animal::create([
            'id_Rebano' => $request->id_Rebano,
            'Nombre' => $request->Nombre,
            'codigo_animal' => $request->codigo_animal,
            'Sexo' => $request->Sexo,
            'fecha_nacimiento' => $request->fecha_nacimiento,
            'Procedencia' => $request->Procedencia,
            'fk_composicion_raza' => $request->fk_composicion_raza,
            'archivado' => false
        ]);

        $animal->load(['rebano.finca.propietario', 'composicionRaza']);

        return response()->json([
            'success' => true,
            'message' => 'Animal creado exitosamente',
            'data' => $animal
        ], Response::HTTP_CREATED);
    }

    /**
     * Display the specified animal.
     */
    public function show(Request $request, $id)
    {
        $animal = Animal::with([
            'rebano.finca.propietario', 
            'composicionRaza',
            'pesosCorporales',
            'registrosCelo',
            'reproducciones',
            'servicios'
        ])->find($id);

        if (!$animal) {
            return response()->json([
                'success' => false,
                'message' => 'Animal no encontrado'
            ], Response::HTTP_NOT_FOUND);
        }

        $user = $request->user();
        
        // Check permissions: admin can see all, propietario only their own
        if (!$user->isAdmin()) {
            $propietario = $user->propietario;
            if (!$propietario || $animal->rebano->finca->id_Propietario != $propietario->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'No tiene permisos para ver este animal'
                ], Response::HTTP_FORBIDDEN);
            }
        }

        return response()->json([
            'success' => true,
            'message' => 'Detalle de animal',
            'data' => $animal
        ]);
    }

    /**
     * Update the specified animal.
     */
    public function update(Request $request, $id)
    {
        $animal = Animal::find($id);

        if (!$animal) {
            return response()->json([
                'success' => false,
                'message' => 'Animal no encontrado'
            ], Response::HTTP_NOT_FOUND);
        }

        $validator = Validator::make($request->all(), [
            'id_Rebano' => 'sometimes|exists:rebano,id_Rebano',
            'Nombre' => 'nullable|string|max:25',
            'codigo_animal' => 'nullable|string|max:20|unique:animal,codigo_animal,' . $id . ',id_Animal',
            'Sexo' => 'sometimes|in:M,F',
            'fecha_nacimiento' => 'sometimes|date',
            'Procedencia' => 'nullable|string|max:50',
            'fk_composicion_raza' => 'sometimes|integer'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Datos de validación incorrectos',
                'errors' => $validator->errors()
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        $user = $request->user();
        
        // Check permissions: admin can update all, propietario only their own
        if (!$user->isAdmin()) {
            $propietario = $user->propietario;
            if (!$propietario || $animal->rebano->finca->id_Propietario != $propietario->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'No tiene permisos para actualizar este animal'
                ], Response::HTTP_FORBIDDEN);
            }
            
            // If changing rebano, check permissions on new rebano
            if ($request->has('id_Rebano')) {
                $newRebano = Rebano::with('finca')->find($request->id_Rebano);
                if (!$newRebano || $newRebano->finca->id_Propietario != $propietario->id) {
                    return response()->json([
                        'success' => false,
                        'message' => 'No tiene permisos para mover el animal a ese rebaño'
                    ], Response::HTTP_FORBIDDEN);
                }
            }
        }

        $animal->update($request->only([
            'id_Rebano', 'Nombre', 'codigo_animal', 'Sexo', 
            'fecha_nacimiento', 'Procedencia', 'fk_composicion_raza'
        ]));
        
        $animal->load(['rebano.finca.propietario', 'composicionRaza']);

        return response()->json([
            'success' => true,
            'message' => 'Animal actualizado exitosamente',
            'data' => $animal
        ]);
    }

    /**
     * Remove the specified animal (soft delete).
     */
    public function destroy(Request $request, $id)
    {
        $animal = Animal::find($id);

        if (!$animal) {
            return response()->json([
                'success' => false,
                'message' => 'Animal no encontrado'
            ], Response::HTTP_NOT_FOUND);
        }

        $user = $request->user();
        
        // Check permissions: admin can delete all, propietario only their own
        if (!$user->isAdmin()) {
            $propietario = $user->propietario;
            if (!$propietario || $animal->rebano->finca->id_Propietario != $propietario->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'No tiene permisos para eliminar este animal'
                ], Response::HTTP_FORBIDDEN);
            }
        }

        // Soft delete by setting archivado = true
        $animal->update(['archivado' => true]);

        return response()->json([
            'success' => true,
            'message' => 'Animal eliminado exitosamente'
        ]);
    }
}