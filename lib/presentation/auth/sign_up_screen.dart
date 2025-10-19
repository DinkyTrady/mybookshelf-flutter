import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:web_flut/components/custom_button.dart';
import 'package:web_flut/components/custom_text_form_field.dart';
import 'package:web_flut/utils/toast_util.dart';
import 'package:web_flut/presentation/auth/sign_in_screen.dart';
import 'package:web_flut/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ToastUtil.showToast(context, 'Passwords do not match', success: false);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await _authService.signUp(
        _firstNameController.text,
        _lastNameController.text,
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
            builder: (BuildContext context) => const SignInScreen(),
          ),
        );
      } else {
        ToastUtil.showToast(context, result.message, success: false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ToastUtil.showToast(context, 'Registration failed: $e', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
              constraints: const BoxConstraints(maxWidth: 400),
              child:
                  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/bookshelf-icon.webp',
                            height: 150,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Create Account',
                            style: theme.textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign up to get started',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 32),
                          CustomTextFormField(
                            controller: _firstNameController,
                            labelText: 'Firstname',
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: _lastNameController,
                            labelText: 'Lastname',
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: _emailController,
                            labelText: 'Email',
                            prefixIcon: Icons.email,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: _passwordController,
                            labelText: 'Password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: theme.colorScheme.onSurface.withAlpha(
                                  100,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: _confirmPasswordController,
                            labelText: 'Confirm Password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: theme.colorScheme.onSurface.withAlpha(
                                  100,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            height: 50,
                            onTap: _register,
                            text: 'Register',
                            gradientColors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                            isLoading: _isLoading,
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 0.2, end: 0, duration: 800.ms),
            ),
          ),
        ),
      ),
    );
  }
}
