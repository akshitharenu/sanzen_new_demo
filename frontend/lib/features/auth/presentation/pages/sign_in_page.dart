import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _emailHasFocus = false;
  bool _passwordHasFocus = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() => _emailHasFocus = _emailFocusNode.hasFocus);
    });
    _passwordFocusNode.addListener(() {
      setState(() => _passwordHasFocus = _passwordFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty;
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await AuthService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        setState(() => _isLoading = false);

        if (result['success']) {
          // TODO: Save tokens and navigate to home
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome ${result['data']['user']['firstName']}!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          // Navigate to home page (to be implemented)
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error'] ?? 'Sign in failed'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  // Sanzen Logo with text
                  Image.asset(
                    'assets/images/Group 2043686807-1.png',
                    height: 50,
                  ),
                  const SizedBox(height: 120),
                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    hintText: 'Email Address',
                    hasFocus: _emailHasFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  // Password Field
                  _buildTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    hintText: 'Password',
                    hasFocus: _passwordHasFocus,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSignIn(),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sign In Button
                  _buildSignInButton(),
                  const SizedBox(height: 40),
                  // Divider with "Or Sign in with"
                  _buildDivider(),
                  const SizedBox(height: 32),
                  // Google Button
                  _buildSocialButton(
                    iconAsset: 'assets/images/Group 2043686813.png',
                    label: 'Sign in with Google',
                    onPressed: () {
                      // TODO: Implement Google sign in
                    },
                  ),
                  const SizedBox(height: 14),
                  // Facebook Button
                  _buildSocialButton(
                    iconAsset: 'assets/images/Group 2043686815.png',
                    label: 'Sign in with Facebook',
                    onPressed: () {
                      // TODO: Implement Facebook sign in
                    },
                  ),
                  const SizedBox(height: 50),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required bool hasFocus,
    bool isPassword = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    void Function(String)? onSubmitted,
    void Function(String)? onChanged,
  }) {
    final bool hasContent = controller.text.isNotEmpty;
    final bool isActive = hasFocus || hasContent;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? AppColors.primaryGreen : AppColors.lightGrey,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword ? _obscurePassword : false,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onSubmitted,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.grey,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null; // We handle validation visually
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: _isFormValid
              ? AppColors.primaryGradient
              : null,
          color: _isFormValid ? null : AppColors.grey,
          borderRadius: BorderRadius.circular(24),
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : (_isFormValid ? _handleSignIn : null),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.lightGrey,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or Sign in with',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.lightGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String iconAsset,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.lightGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconAsset,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
