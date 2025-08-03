<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('game_exclusives', function (Blueprint $table) {
            $table->id();
	    $table->unsignedBigInteger('game_id');
            $table->foreign('game_id')->references('id')->on('games')->onDelete('cascade');

            // Campos obrigatórios adicionados pela migration faltante
            // $table->text('loseResults');
            // $table->text('demoWinResults');
            // $table->text('winResults');
            // $table->text('iconsJson');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('game_exclusives');
    }
};
