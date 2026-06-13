<?php

use Illuminate\Http\Request;
use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Route;


// Public Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/check-email', [AuthController::class, 'checkEmail']);
Route::post('/check-username', [AuthController::class, 'checkUsername']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/verify-code', [AuthController::class, 'verifyCode']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);

// Protected Routes
Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);

});
