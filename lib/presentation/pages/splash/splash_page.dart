import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/services/deeplink_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/local/secure_storage_datasource.dart';
import '../../../injection/injection_container.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    await Future.delayed(Duration.zero);
    if (mounted) {
      final state = context.read<AuthBloc>().state;
      if (state is AuthAuthenticated) {
        _handleAuthenticated();
      }
    }
  }

  Future<void> _handleAuthenticated() async {
    final isBioEnabled = await sl<SecureStorageDatasource>().getBiometricEnabled();
    if (isBioEnabled) {
      final authenticated = await _authenticateWithBiometrics();
      if (!authenticated) {
        return;
      }
    }
    final pending = DeeplinkService.consumePending();
    if (pending != null) {
      if (mounted) context.go('/pay', extra: pending);
    } else {
      if (mounted) context.go('/home');
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) return false;

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Silakan verifikasi sidik jari Anda untuk masuk ke Smoke Money',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _handleAuthenticated();
        } else if (state is AuthUnauthenticated) {
          // Stay on splash to show welcome
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: SafeArea(
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -120,
                  right: -90,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 120,
                  left: -100,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(),
                      const AppLogo(size: 92, light: true),
                      const SizedBox(height: 26),
                      const Text(
                        'Smoke Money',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bayar, transfer, dan kelola uang\ndalam satu aplikasi yang aman.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          if (authState is AuthAuthenticated) {
                            return AppButton(
                              label: 'Masuk dengan Sidik Jari',
                              variant: AppButtonVariant.white,
                              onPressed: () async {
                                final authenticated = await _authenticateWithBiometrics();
                                if (authenticated) {
                                  final pending = DeeplinkService.consumePending();
                                  if (pending != null) {
                                    context.go('/pay', extra: pending);
                                  } else {
                                    context.go('/home');
                                  }
                                }
                              },
                            );
                          }
                          return Column(
                            children: [
                              AppButton(
                                label: 'Buat Akun Baru',
                                variant: AppButtonVariant.white,
                                onPressed: () => context.push('/register'),
                              ),
                              const SizedBox(height: 11),
                              AppButton(
                                label: 'Masuk ke Akun',
                                variant: AppButtonVariant.outlineWhite,
                                onPressed: () => context.push('/login'),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
