import 'dart:ui';

import 'package:cifarx_test/core/common/widgets/custom_toast.dart';
import 'package:cifarx_test/core/routes/app_routes.dart';
import 'package:cifarx_test/features/home/presentation/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_sizes.dart';
import '../../../../../core/design/app_colors.dart';
import '../../models/login_state_model.dart';
import '../../providers/login-provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin({required BuildContext context}) {
    ref.read(loginProvider.notifier).login().then((_) {
      final LoginState state = ref.read(loginProvider);
      if (state.isSuccess && context.mounted) {
        ToastManager.show(message: "Login Successful!");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        context.go(AppRoutes.home);
      } else if (state.isError) {
        ToastManager.show(message: "Login failed", backgroundColor: AppColors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final LoginState loginState = ref.watch(loginProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Stack(
            children: <Widget>[_buildBackgroundDecoration(), _buildLoginContent(loginState)],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundDecoration() {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -100,
            right: -100,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 3),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (BuildContext context, double value, Widget? child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: <Color>[AppColors.white.withValues(alpha: 0.1), Colors.transparent],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 4),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (BuildContext context, double value, Widget? child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: <Color>[
                          AppColors.accentColor.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContent(LoginState loginState) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenHorizontal),
        child: Column(
          children: <Widget>[
            const SizedBox(height: AppSizes.xxxL),
            _buildHeader(),
            const SizedBox(height: AppSizes.spaceBetweenSections),
            _buildLoginForm(loginState),
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.glassGradient,
              border: Border.all(color: AppColors.white.withValues(alpha: 0.3), width: 2),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: AppColors.white.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: AppSizes.iconXxl,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          ShaderMask(
            shaderCallback: (Rect bounds) => LinearGradient(
              colors: <Color>[AppColors.white, AppColors.white.withValues(alpha: 0.9)],
            ).createShader(bounds),
            child: const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: AppSizes.fontSizeXl,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Sign in to continue',
            style: TextStyle(
              fontSize: AppSizes.fontSizeBodyL,
              color: AppColors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(LoginState loginState) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusXxxL),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColors.white.withValues(alpha: 0.25),
                    AppColors.white.withValues(alpha: 0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusXxxL),
                border: Border.all(color: AppColors.white.withValues(alpha: 0.3), width: 1.5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildEmailField(loginState),
                    const SizedBox(height: AppSizes.spaceBetweenInputs),
                    _buildPasswordField(loginState),
                    const SizedBox(height: AppSizes.md),
                    _buildRememberAndForgot(loginState),
                    const SizedBox(height: AppSizes.spaceBetweenSections),
                    _buildLoginButton(loginState),
                    const SizedBox(height: AppSizes.lg),
                    _buildDivider(),
                    const SizedBox(height: AppSizes.lg),
                    _buildSocialLogin(),
                    const SizedBox(height: AppSizes.lg),
                    _buildSignUpPrompt(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(LoginState loginState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            fontSize: AppSizes.fontSizeBodyM,
            fontWeight: FontWeight.w600,
            color: AppColors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.2), width: 1),
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (String value) => ref.read(loginProvider.notifier).updateEmail(value),
            style: const TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeBodyM),
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.5)),
              prefixIcon: Icon(Icons.email_outlined, color: AppColors.white.withValues(alpha: 0.7)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.md,
              ),
            ),
            validator: (String? value) => ref.read(loginProvider.notifier).validateEmail(value),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(LoginState loginState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            fontSize: AppSizes.fontSizeBodyM,
            fontWeight: FontWeight.w600,
            color: AppColors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.2), width: 1),
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: !loginState.isPasswordVisible,
            onChanged: (String value) => ref.read(loginProvider.notifier).updatePassword(value),
            style: const TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeBodyM),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.5)),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  loginState.isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
                onPressed: () => ref.read(loginProvider.notifier).togglePasswordVisibility(),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.md,
              ),
            ),
            validator: (String? value) => ref.read(loginProvider.notifier).validatePassword(value),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot(LoginState loginState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: loginState.rememberMe,
                onChanged: (_) => ref.read(loginProvider.notifier).toggleRememberMe(),
                fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.white;
                  }
                  return AppColors.white.withValues(alpha: 0.3);
                }),
                checkColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              'Remember me',
              style: TextStyle(
                fontSize: AppSizes.fontSizeBodyS,
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // Handle forgot password
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: AppSizes.fontSizeBodyS,
              color: AppColors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginState loginState) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: <Color>[AppColors.white, AppColors.cardGradientEnd]),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          loginState.isLoading ? null : _handleLogin(context: context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
          ),
        ),
        child: loginState.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
              )
            : const Text(
                'Sign In',
                style: TextStyle(fontSize: AppSizes.fontSizeBodyL, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: AppColors.white.withValues(alpha: 0.3), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Text(
            'OR',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.6),
              fontSize: AppSizes.fontSizeBodyS,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.white.withValues(alpha: 0.3), thickness: 1)),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildSocialButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google',
            onTap: () => ref.read(loginProvider.notifier).socialLogin('Google'),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: _buildSocialButton(
            icon: Icons.apple_rounded,
            label: 'Apple',
            onTap: () => ref.read(loginProvider.notifier).socialLogin('Apple'),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: AppColors.white, size: AppSizes.iconMd),
            const SizedBox(width: AppSizes.sm),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppSizes.fontSizeBodyM,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: AppColors.white.withValues(alpha: 0.7),
            fontSize: AppSizes.fontSizeBodyM,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to sign up
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSizes.fontSizeBodyM,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
