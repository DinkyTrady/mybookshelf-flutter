import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:web_flut/components/custom_button.dart';
import 'package:web_flut/components/custom_text_form_field.dart';
import 'package:web_flut/utils/toast_util.dart';
import 'package:web_flut/presentation/auth/sign_up_screen.dart';
import 'package:web_flut/presentation/home/home_screen.dart';
import 'package:web_flut/services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (result.success) {
        ToastUtil.showToast(context, result.message, success: true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
      } else {
        ToastUtil.showToast(context, result.message, success: false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ToastUtil.showToast(context, 'Login failed: $e', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.surface, theme.colorScheme.surface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child:
                  Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/bookshelf-icon.webp',
                            height: 250,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Login to your account',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(178),
                            ),
                          ),
                          const SizedBox(height: 32),
                          CustomTextFormField(
                            controller: _emailController,
                            labelText: 'email',
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: _passwordController,
                            labelText: 'Password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscureText,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            onTap: _login,
                            text: 'Login',
                            gradientColors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                            height: 50,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const SignUpScreen(),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                ),
                              );
                            },
                            text: 'Don\'t have an account? Register',
                            gradientColors: [
                              theme.colorScheme.surface,
                              theme.colorScheme.surface,
                            ],
                            height: 30,
                            textStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 1000.ms)
                      .slideY(begin: 0.2, end: 0, duration: 800.ms),
            ),
          ),
        ),
      ),
    );
  }
}
