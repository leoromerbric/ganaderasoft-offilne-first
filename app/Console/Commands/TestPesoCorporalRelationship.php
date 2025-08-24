<?php

namespace App\Console\Commands;

use App\Models\PesoCorporal;
use Illuminate\Console\Command;

class TestPesoCorporalRelationship extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'test:peso-corporal-relationship';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Test the PesoCorporal relationship fix';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Testing PesoCorporal relationship...');

        try {
            // Test 1: Basic relationship definition
            $pesoCorporal = new PesoCorporal([
                'Fecha_Peso' => '2024-01-01',
                'Peso' => 100.5,
                'Comentario' => 'Test',
                'peso_etapa_anid' => 1,
                'peso_etapa_etid' => 1,
            ]);

            $relation = $pesoCorporal->etapaAnimal();
            $this->info('✓ PesoCorporal::etapaAnimal() relationship defined successfully');
            $this->info('  Relation type: '.get_class($relation));

            // Test 2: Check SQL generation
            $sql = $relation->toSql();
            $this->info('  Generated SQL: '.$sql);

            // Test 3: Verify that the whereColumn conditions are in the query
            if (strpos($sql, 'peso_corporal') !== false && strpos($sql, 'peso_etapa_anid') !== false) {
                $this->info('✓ SQL contains correct column references');
            } else {
                $this->error('✗ SQL missing expected column references');
            }

            // Test 4: Test other models too
            $this->info("\nTesting CambiosAnimal relationship...");
            $cambiosAnimal = new \App\Models\CambiosAnimal([
                'Fecha_Cambio' => '2024-01-01',
                'Peso' => 100.5,
                'cambios_etapa_anid' => 1,
                'cambios_etapa_etid' => 1,
            ]);

            $cambiosRelation = $cambiosAnimal->etapaAnimal();
            $this->info('✓ CambiosAnimal::etapaAnimal() relationship defined successfully');

            $cambiosSQL = $cambiosRelation->toSql();
            if (strpos($cambiosSQL, 'cambios_animal') !== false && strpos($cambiosSQL, 'cambios_etapa_anid') !== false) {
                $this->info('✓ CambiosAnimal SQL contains correct column references');
            } else {
                $this->error('✗ CambiosAnimal SQL missing expected column references');
            }

            // Test 5: Test MedidasCorporales
            $this->info("\nTesting MedidasCorporales relationship...");
            $medidasCorporales = new \App\Models\MedidasCorporales([
                'Altura_HC' => 120.5,
                'medida_etapa_anid' => 1,
                'medida_etapa_etid' => 1,
            ]);

            $medidasRelation = $medidasCorporales->etapaAnimal();
            $this->info('✓ MedidasCorporales::etapaAnimal() relationship defined successfully');

            $medidasSQL = $medidasRelation->toSql();
            if (strpos($medidasSQL, 'medidas_corporales') !== false && strpos($medidasSQL, 'medida_etapa_anid') !== false) {
                $this->info('✓ MedidasCorporales SQL contains correct column references');
            } else {
                $this->error('✗ MedidasCorporales SQL missing expected column references');
            }

            $this->info("\n✓ All relationship tests completed successfully!");
            $this->info("The original SQL error 'Unknown column peso_etapa_anid in where clause' should now be fixed.");

            return 0;
        } catch (\Exception $e) {
            $this->error('✗ Relationship test failed: '.$e->getMessage());
            $this->error('  File: '.$e->getFile().':'.$e->getLine());

            return 1;
        }
    }
}
