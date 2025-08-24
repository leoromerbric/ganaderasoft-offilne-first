<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MedidasCorporales extends Model
{
    use HasFactory;

    protected $table = 'medidas_corporales';
    protected $primaryKey = 'id_Medida';

    protected $fillable = [
        'Altura_HC',
        'Altura_HG',
        'Perimetro_PT',
        'Perimetro_PCA',
        'Longitud_LC',
        'Longitud_LG',
        'Anchura_AG',
        'medida_etapa_anid',
        'medida_etapa_etid',
    ];

    protected $casts = [
        'Altura_HC' => 'float',
        'Altura_HG' => 'float',
        'Perimetro_PT' => 'float',
        'Perimetro_PCA' => 'float',
        'Longitud_LC' => 'float',
        'Longitud_LG' => 'float',
        'Anchura_AG' => 'float',
    ];

    /**
     * Get the etapa animal relationship.
     */
    public function etapaAnimal()
    {
        return $this->belongsTo(EtapaAnimal::class, ['medida_etapa_anid', 'medida_etapa_etid'], ['etan_animal_id', 'etan_etapa_id']);
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
            ['medida_etapa_anid', 'medida_etapa_etid'],
            'etan_animal_id'
        );
    }

    /**
     * Scope a query to filter by animal.
     */
    public function scopeForAnimal($query, $animalId)
    {
        return $query->where('medida_etapa_anid', $animalId);
    }

    /**
     * Scope a query to filter by etapa.
     */
    public function scopeForEtapa($query, $etapaId)
    {
        return $query->where('medida_etapa_etid', $etapaId);
    }
}