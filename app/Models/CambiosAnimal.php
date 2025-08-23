<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CambiosAnimal extends Model
{
    use HasFactory;

    protected $table = 'cambios_animal';
    protected $primaryKey = 'id_Cambio';

    protected $fillable = [
        'Fecha_Cambio',
        'Etapa_Cambio',
        'Peso',
        'Altura',
        'Comentario',
        'cambios_etapa_anid',
        'cambios_etapa_etid',
    ];

    protected $casts = [
        'Fecha_Cambio' => 'date',
        'Peso' => 'float',
        'Altura' => 'float',
    ];

    /**
     * Get the etapa animal relationship.
     */
    public function etapaAnimal()
    {
        return $this->belongsTo(EtapaAnimal::class, ['cambios_etapa_anid', 'cambios_etapa_etid'], ['etan_animal_id', 'etan_etapa_id']);
    }

    /**
     * Get the animal through etapa animal.
     */
    public function animal()
    {
        return $this->hasOneThrough(
            Animal::class,
            EtapaAnimal::class,
            ['etan_animal_id', 'etan_etapa_id'],
            'id_Animal',
            ['cambios_etapa_anid', 'cambios_etapa_etid'],
            'etan_animal_id'
        );
    }

    /**
     * Scope a query to filter by date range.
     */
    public function scopeByDateRange($query, $startDate, $endDate = null)
    {
        if ($endDate) {
            return $query->whereBetween('Fecha_Cambio', [$startDate, $endDate]);
        }
        return $query->where('Fecha_Cambio', '>=', $startDate);
    }

    /**
     * Scope a query to filter by animal.
     */
    public function scopeForAnimal($query, $animalId)
    {
        return $query->where('cambios_etapa_anid', $animalId);
    }

    /**
     * Scope a query to filter by etapa.
     */
    public function scopeForEtapa($query, $etapaId)
    {
        return $query->where('cambios_etapa_etid', $etapaId);
    }

    /**
     * Scope a query to filter by etapa cambio.
     */
    public function scopeByEtapaCambio($query, $etapaCambio)
    {
        return $query->where('Etapa_Cambio', $etapaCambio);
    }
}