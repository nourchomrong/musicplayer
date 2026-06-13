<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory;

    protected $fillable = [
        'role_id',
        'username',
        'email',
        'password',
        'profile_image',
        'bio',
        'is_verified',
        'last_login',
        'status',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'is_verified' => 'boolean',
        'last_login' => 'datetime',
    ];

    public function role()
    {
        return $this->belongsTo(Role::class);
    }
}