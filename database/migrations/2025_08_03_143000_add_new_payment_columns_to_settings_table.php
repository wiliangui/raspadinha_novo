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
        Schema::table('settings', function (Blueprint $table) {
            // Adicionando todas as colunas que podem estar faltando
            // com valores padrão para não quebrar o código existente.
            $table->boolean('suitpay_is_enable')->default(false)->after('initial_bonus');
            $table->boolean('stripe_is_enable')->default(false)->after('suitpay_is_enable');
            $table->boolean('sharkpay_is_enable')->default(false)->after('stripe_is_enable');
            $table->boolean('disable_spin')->default(false)->after('sharkpay_is_enable');
            $table->boolean('disable_rollover')->default(false)->after('disable_spin');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('settings', function (Blueprint $table) {
            $table->dropColumn([
                'suitpay_is_enable',
                'stripe_is_enable',
                'sharkpay_is_enable',
                'disable_spin',
                'disable_rollover'
            ]);
        });
    }
};