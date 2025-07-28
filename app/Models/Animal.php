<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Animal extends Model
{
    use HasFactory;

    protected $table = 'animal';
    protected $primaryKey = 'id_Animal';

    protected $fillable = [
        'id_Rebano',
        'Nombre',
        'codigo_animal',
        'Sexo',
        'fecha_nacimiento',
        'Procedencia',
        'fk_composicion_raza',
        'archivado',
    ];

    protected $casts = [
        'archivado' => 'boolean',
        'fecha_nacimiento' => 'date',
    ];

    /**
     * Get the rebano that owns the animal.
     */
    public function rebano()
    {
        return $this->belongsTo(Rebano::class, 'id_Rebano', 'id_Rebano');
    }

    /**
     * Get the composicion raza for the animal.
     */
    public function composicionRaza()
    {
        return $this->belongsTo(ComposicionRaza::class, 'fk_composicion_raza', 'id_Composicion');
    }

    /**
     * Get the finca through rebano.
     */
    public function finca()
    {
        return $this->hasOneThrough(Finca::class, Rebano::class, 'id_Rebano', 'id_Finca', 'id_Rebano', 'id_Finca');
    }

    /**
     * Get the peso corporal records for the animal.
     */
    public function pesosCorporales()
    {
        return $this->hasMany(PesoCorporal::class, 'id_Animal', 'id_Animal');
    }

    /**
     * Get the registro celo records for the animal.
     */
    public function registrosCelo()
    {
        return $this->hasMany(RegistroCelo::class, 'id_Animal', 'id_Animal');
    }

    /**
     * Get the reproduccion records for the animal.
     */
    public function reproducciones()
    {
        return $this->hasMany(ReproduccionAnimal::class, 'id_Animal', 'id_Animal');
    }

    /**
     * Get the servicio records for the animal.
     */
    public function servicios()
    {
        return $this->hasMany(ServicioAnimal::class, 'id_Animal', 'id_Animal');
    }

    /**
     * Scope a query to only include active animals.
     */
    public function scopeActive($query)
    {
        return $query->where('archivado', false);
    }

    /**
     * Scope a query to only include animals of a specific rebano.
     */
    public function scopeForRebano($query, $rebanoId)
    {
        return $query->where('id_Rebano', $rebanoId);
    }

    /**
     * Scope a query to only include animals of a specific finca.
     */
    public function scopeForFinca($query, $fincaId)
    {
        return $query->whereHas('rebano', function ($q) use ($fincaId) {
            $q->where('id_Finca', $fincaId);
        });
    }

    /**
     * Scope a query to filter by sex.
     */
    public function scopeBySex($query, $sex)
    {
        return $query->where('Sexo', $sex);
    }
}