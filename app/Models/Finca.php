<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Finca extends Model
{
    use HasFactory;

    protected $table = 'finca';
    protected $primaryKey = 'id_Finca';

    protected $fillable = [
        'id_Propietario',
        'Nombre',
        'Explotacion_Tipo',
        'archivado',
    ];

    protected $casts = [
        'archivado' => 'boolean',
    ];

    /**
     * Get the propietario that owns the finca.
     */
    public function propietario()
    {
        return $this->belongsTo(Propietario::class, 'id_Propietario', 'id');
    }

    /**
     * Get the user that owns the finca through propietario.
     */
    public function user()
    {
        return $this->hasOneThrough(User::class, Propietario::class, 'id', 'id', 'id_Propietario', 'id');
    }

    /**
     * Scope a query to only include active fincas.
     */
    public function scopeActive($query)
    {
        return $query->where('archivado', false);
    }

    /**
     * Scope a query to only include fincas of a specific propietario.
     */
    public function scopeForPropietario($query, $propietarioId)
    {
        return $query->where('id_Propietario', $propietarioId);
    }

    /**
     * Get the inventario bufalo for the finca.
     */
    public function inventariosBufalo()
    {
        return $this->hasMany(InventarioBufalo::class, 'id_Finca', 'id_Finca');
    }

    /**
     * Get the personal for the finca.
     */
    public function personalFinca()
    {
        return $this->hasMany(PersonalFinca::class, 'id_Finca', 'id_Finca');
    }
}