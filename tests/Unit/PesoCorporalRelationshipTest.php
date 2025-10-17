<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\PesoCorporal;
use App\Models\EtapaAnimal;
use App\Models\Animal;
use Illuminate\Foundation\Testing\RefreshDatabase;

class PesoCorporalRelationshipTest extends TestCase
{
    use RefreshDatabase;

    public function test_peso_corporal_can_load_etapa_animal_relationship()
    {
        // Create a peso corporal instance
        $pesoCorporal = new PesoCorporal([
            'Fecha_Peso' => '2024-01-01',
            'Peso' => 100.5,
            'Comentario' => 'Test',
            'peso_etapa_anid' => 1,
            'peso_etapa_etid' => 1,
        ]);
        
        // Test that the relationship is defined correctly
        $relation = $pesoCorporal->etapaAnimal();
        
        // This should not throw an "Array to string conversion" error
        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\HasOne::class, $relation);
    }

    public function test_peso_corporal_can_load_animal_relationship()
    {
        // Create a peso corporal instance
        $pesoCorporal = new PesoCorporal([
            'Fecha_Peso' => '2024-01-01',
            'Peso' => 100.5,
            'Comentario' => 'Test',
            'peso_etapa_anid' => 1,
            'peso_etapa_etid' => 1,
        ]);
        
        // Test that the relationship is defined correctly
        $relation = $pesoCorporal->animal();
        
        // This should not throw an "Array to string conversion" error
        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\BelongsTo::class, $relation);
    }
}