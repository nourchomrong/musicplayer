import 'package:frontend/app.dart';
import 'package:frontend/controller/auth_controller.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String? _localUsernameError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<AuthController>(context, listen: false).clearMessages();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;
    final hintColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final fillColor = theme.colorScheme.surface;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                    onPressed: () {
                      authController.clearMessages();
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 80),
                Image.asset(
                  AppAssets.logoicon,
                  height: 80,
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Choose Username",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Create a unique username for your profile.",
                    style: TextStyle(color: hintColor),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _usernameController,
                  onChanged: (_) {
                    authController.clearMessages();
                    if (_localUsernameError != null) {
                      setState(() => _localUsernameError = null);
                    }
                  },
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: "@username",
                    hintStyle: TextStyle(color: hintColor),
                    filled: true,
                    fillColor: fillColor,
                    errorText: _localUsernameError ?? 
                        authController.fieldErrors?['username']?.toString() ??
                        (authController.errorMessage?.contains('username') == true
                            ? authController.errorMessage
                            : null),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (authController.fieldErrors?['email'] != null)
                  _messageText("Email error: ${authController.fieldErrors?['email']}", false),
                if (authController.errorMessage != null &&
                    authController.fieldErrors?['username'] == null &&
                    authController.fieldErrors?['email'] == null)
                  _messageText(authController.errorMessage!, false),
                if (authController.successMessage != null)
                  _messageText(authController.successMessage!, true),
                if (authController.errorMessage != null || authController.successMessage != null)
                  const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authController.isLoading
                        ? null
                        : () async {
                            setState(() => _localUsernameError = null);
                            final username = _usernameController.text.trim();
                            
                            if (username.isEmpty) {
                              setState(() => _localUsernameError = "Please enter a username");
                              return;
                            }

                            final exists = await authController.checkUsernameExists(username);
                            if (!context.mounted) return;

                            if (exists) {
                              setState(() => _localUsernameError = "This username is already taken");
                              return;
                            }

                            String? error = await authController.register(username);
                            if (!context.mounted) return;

                            if (error == null) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.home,
                                (route) => false,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: authController.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.blueGrey,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Continue",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _messageText(String message, bool isSuccess) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        message,
        style: TextStyle(
          color: isSuccess ? Colors.green : Colors.red,
          fontSize: 14,
        ),
      ),
    );
  }
}
