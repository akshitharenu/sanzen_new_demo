import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/pages/home_page.dart';

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
  bool _obscurePassword = true;
  bool _rememberMe = true;
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

  void _handleSignIn() {
    // Dummy login — just navigate to HomePage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  // Sanzen Logo
                  Image.asset(
                    'assets/images/Group 2043686807-1.png',
                    height: 45,
                  ),
                  const SizedBox(height: 50),
                  // Welcome Back
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    hintText: 'Email',
                    hasFocus: _emailHasFocus,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  _buildTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    hintText: 'Password',
                    hasFocus: _passwordHasFocus,
                    prefixIcon: Icons.more_horiz,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSignIn(),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  // Remember me + Forgot Password row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember me
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (val) {
                                setState(() => _rememberMe = val ?? false);
                              },
                              activeColor: AppColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                color: AppColors.grey,
                                width: 1.5,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ],
                      ),
                      // Forgot Password
                      GestureDetector(
                        onTap: () {
                          // No action for dummy app
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryGreen,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Sign In Button
                  _buildSignInButton(),
                  const SizedBox(height: 30),
                  // Divider with "OR"
                  _buildDivider(),
                  const SizedBox(height: 30),
                  // Google Button
                  _buildSocialButton(
                    iconAsset: 'assets/images/Group 2043686813.png',
                    label: 'Continue with Google',
                    onPressed: _handleSignIn,
                  ),
                  const SizedBox(height: 14),
                  // Facebook Button
                  _buildSocialButton(
                    iconAsset: 'assets/images/Group 2043686815.png',
                    label: 'Continue with Facebook',
                    onPressed: _handleSignIn,
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
    required IconData prefixIcon,
    bool isPassword = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    void Function(String)? onSubmitted,
    void Function(String)? onChanged,
  }) {
    final bool hasContent = controller.text.isNotEmpty;
    final bool isActive = hasFocus || hasContent;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
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
            horizontal: 8,
            vertical: 15,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: isActive ? AppColors.primaryGreen : AppColors.grey,
            size: 20,
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
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(25),
        ),
        child: ElevatedButton(
          onPressed: _handleSignIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            'Sign in',
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
            'OR',
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
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.lightGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
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
