<?php

use Illuminate\Support\Facades\Route;
use App\Livewire\Pages\Auth\Login;

Route::get('/', Login::class)->name('login');
