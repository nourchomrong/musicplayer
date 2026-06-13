<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Otp;
use App\Mail\OtpMail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'username' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'password' => 'required|min:6|confirmed',
        ]);

        $errors = [];

        if (User::where('username', $validated['username'])->exists()) {
            $errors['username'][] = 'The username has already been taken.';
        }

        if (User::where('email', $validated['email'])->exists()) {
            $errors['email'][] = 'The email has already been taken.';
        }

        if (!empty($errors)) {
            throw ValidationException::withMessages($errors);
        }

        $user = User::create([
            'role_id' => 2, // user role default
            'username' => $validated['username'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'status' => 'active',
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'User registered successfully',
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email|max:255',
            'password' => 'required|min:6',
        ]);

        $user = User::where('email', $validated['email'])->first();

        if (! $user || ! Hash::check($validated['password'], $user->password)) {
            return response()->json([
                'message' => 'Invalid credentials. Please check your email and password.',
            ], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login successful',
            'user' => $user,
            'token' => $token,
        ], 200);
    }

    public function logout(Request $request)
    {
        $user = $request->user();
        if ($user) {
            $user->currentAccessToken()?->delete();
        }

        return response()->json([
            'message' => 'Logged out successfully',
        ]);
    }

    public function checkEmail(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $exists = User::where('email', $request->email)->exists();

        return response()->json([
            'exists' => $exists,
            'message' => $exists ? 'Email is already taken.' : 'Email is available.',
        ]);
    }

    public function checkUsername(Request $request)
    {
        $request->validate([
            'username' => 'required|string',
        ]);

        $exists = User::where('username', $request->username)->exists();

        return response()->json([
            'exists' => $exists,
            'message' => $exists ? 'Username is already taken.' : 'Username is available.',
        ]);
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json([
                'message' => 'We couldn\'t find a user with that email address.',
            ], 404);
        }

        $existingOtp = Otp::where('email', $request->email)->first();

        $otp = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);

        Otp::updateOrCreate(
            ['email' => $request->email],
            [
                'otp' => $otp,
                'expires_at' => now()->addMinutes(15)
            ]
        );

        try {
            Mail::to($request->email)->send(new OtpMail($otp, $request->email));
            Log::info('OTP email sent successfully to ' . $request->email);
        } catch (\Exception $e) {
            Log::error('Failed to send OTP email: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to send email. Please try again later.',
                'error' => $e->getMessage()
            ], 500);
        }

        return response()->json([
            'message' => 'Verification code has been sent to your email.'
        ]);
    }

    public function verifyCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'code' => 'required|string|size:6',
        ]);

        $record = Otp::where('email', $request->email)
            ->where('otp', $request->code)
            ->first();

        if (!$record) {
            return response()->json([
                'message' => 'Invalid verification code.'
            ], 400);
        }

        if (now()->gt($record->expires_at)) {
            return response()->json([
                'message' => 'Verification code has expired.'
            ], 400);
        }

        return response()->json([
            'message' => 'Code verified successfully.'
        ]);
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6|confirmed',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json(['message' => 'User not found.'], 404);
        }

        $user->password = Hash::make($request->password);
        $user->save();

        // Optional: Delete OTP after successful reset
        Otp::where('email', $request->email)->delete();

        return response()->json([
            'message' => 'Password has been reset successfully.',
        ]);
    }
}
