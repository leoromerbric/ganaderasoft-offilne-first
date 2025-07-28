<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\FincaController;
use App\Http\Controllers\Api\PropietarioController;
use App\Http\Controllers\Api\RebanoController;
use App\Http\Controllers\Api\AnimalController;
use App\Http\Controllers\Api\InventarioBufaloController;
use App\Http\Controllers\Api\TipoAnimalController;
use App\Http\Controllers\Api\EstadoSaludController;
use App\Http\Controllers\Api\EstadoAnimalController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Public auth routes
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
});

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // User profile routes
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    
    // Core entity CRUD routes
    Route::apiResource('fincas', FincaController::class);
    Route::apiResource('propietarios', PropietarioController::class);
    Route::apiResource('rebanos', RebanoController::class);
    Route::apiResource('animales', AnimalController::class);
    Route::apiResource('inventarios-bufalo', InventarioBufaloController::class);
    Route::apiResource('tipos-animal', TipoAnimalController::class);
    Route::apiResource('estados-salud', EstadoSaludController::class);
    Route::apiResource('estados-animal', EstadoAnimalController::class);
});
