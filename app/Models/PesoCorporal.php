<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PesoCorporal extends Model
{
    use HasFactory;

    protected $table = 'peso_corporal';
    protected $primaryKey = 'id_Peso';

    protected $fillable = [
        'Fecha_Peso',
        'Peso',
        'Comentario',
        'peso_etapa_anid',
        'peso_etapa_etid',
    ];

    protected $casts = [
        'Fecha_Peso' => 'date',
        'Peso' => 'float',
    ];

    /**
     * Get the etapa animal relationship.
     */
    public function etapaAnimal()
    {
        return $this->belongsTo(EtapaAnimal::class, ['peso_etapa_anid', 'peso_etapa_etid'], ['etan_animal_id', 'etan_etapa_id']);
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
            ['peso_etapa_anid', 'peso_etapa_etid'],
            'etan_animal_id'
        );
    }

    /**
     * Scope a query to filter by date range.
     */
    public function scopeByDateRange($query, $startDate, $endDate = null)
    {
        if ($endDate) {
            return $query->whereBetween('Fecha_Peso', [$startDate, $endDate]);
        }
        return $query->where('Fecha_Peso', '>=', $startDate);
    }

    /**
     * Scope a query to filter by animal.
     */
    public function scopeForAnimal($query, $animalId)
    {
        return $query->where('peso_etapa_anid', $animalId);
    }
}