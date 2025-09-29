import 'package:flutter/material.dart';
import 'package:web_flut/components/custom_button.dart';
import 'package:web_flut/components/text_form_field.dart';
import 'package:web_flut/presentation/auth/sign_up_screen.dart';
import 'package:web_flut/services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscureText = true;
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    final user = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const SignInScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.surface, theme.colorScheme.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/bookshelf-icon.webp',
                        height: 250,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome Back',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login to your account',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                        controller: _usernameController,
                        label: 'email',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
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
                      // _buildLoginButton(theme),
                      const SizedBox(height: 16),
                      CustomButton(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SignUpScreen(),
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
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).push(
                      //       PageRouteBuilder(
                      //         pageBuilder:
                      //             (context, animation, secondaryAnimation) =>
                      //                 const SignUpScreen(),
                      //         transitionsBuilder:
                      //             (
                      //               context,
                      //               animation,
                      //               secondaryAnimation,
                      //               child,
                      //             ) {
                      //               return FadeTransition(
                      //                 opacity: animation,
                      //                 child: child,
                      //               );
                      //             },
                      //       ),
                      //     );
                      //   },
                      //   style: TextButton.styleFrom(
                      //     foregroundColor: theme.colorScheme.secondary,
                      //   ),
                      //   child: const Text('Don\'t have an account? Register'),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
