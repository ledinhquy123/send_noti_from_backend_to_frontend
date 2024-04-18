<?php

use App\Http\Controllers\NotificationController;
use Illuminate\Support\Facades\Route;

Route::post('notifyapp', [NotificationController::class, 'notifyapp']);