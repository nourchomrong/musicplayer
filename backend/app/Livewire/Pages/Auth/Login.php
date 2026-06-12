<?php

namespace App\Livewire\Pages\Auth;

use Livewire\Component;

class Login extends Component
{
    public $username = '';
    public $password = '';
    public $loginError = '';
    public function render()
    {
        return view('livewire.pages.auth.login')
            ->layout('layouts.app', [
                'title' => 'Login'
            ]);
    }
}
