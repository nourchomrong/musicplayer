import 'package:frontend/app.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            children: [

              const SizedBox(height: 10),

              Image.asset(
                AppAssets.logoicon,
                height: 80,
              ),

              const SizedBox(height: 40),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create your Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Email"),
              ),

              const SizedBox(height: 15),

              TextField(
                obscureText: true,
                decoration: _inputDecoration("Password"),
              ),

              const SizedBox(height: 15),

              TextField(
                obscureText: true,
                decoration: _inputDecoration("Confirm Password"),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.username,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),

              const Text(
                "- Or sign up with -",
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _socialButton(AppAssets.google,),
                  _socialButton(AppAssets.facebook,),
                  _socialButton("assets/icons/twitter.png"),
                ],
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.login,
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
    );
  }

  Widget _socialButton(String imagePath) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 90,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: imagePath.toLowerCase().endsWith('.svg')
              ? SvgPicture.asset(
                  imagePath,
                  height: 24,
                )
              : Image.asset(
                  imagePath,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error_outline, size: 24);
                  },
                ),
        ),
      ),
    );
  }
}