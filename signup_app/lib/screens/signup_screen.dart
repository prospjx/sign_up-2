import 'package:flutter/material.dart';
import 'package:signup_app/screens/success_screen.dart';

class SignupScreen extends StatefulWidget {
	const SignupScreen({super.key});

	@override
	State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
	// =========================
	// FEATURE 1: Form Validation Setup
	// =========================
	final _formKey = GlobalKey<FormState>();

	// Input controllers
	final TextEditingController _nameController = TextEditingController();
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
	final TextEditingController _confirmPasswordController = TextEditingController();

	// =========================
	// FEATURE 2: Birth Date Picker State
	// =========================
	final TextEditingController _birthDateController = TextEditingController();
	DateTime? _selectedBirthDate;

	// =========================
	// FEATURE 3: Password Visibility Toggle State
	// =========================
	bool _passwordVisible = false;
	bool _confirmPasswordVisible = false;

	// =========================
	// FEATURE 4: Loading State Before Success
	// =========================
	bool _isLoading = false;

	@override
	void dispose() {
		_nameController.dispose();
		_emailController.dispose();
		_passwordController.dispose();
		_confirmPasswordController.dispose();
		_birthDateController.dispose();
		super.dispose();
	}

	// =========================
	// FEATURE 2: Birth Date Picker Logic
	// =========================
	Future<void> _pickBirthDate() async {
		final now = DateTime.now();

		final picked = await showDatePicker(
			context: context,
			initialDate: DateTime(now.year - 18, now.month, now.day),
			firstDate: DateTime(1900),
			lastDate: now,
		);

		if (picked != null) {
			setState(() {
				_selectedBirthDate = picked;
				_birthDateController.text =
						'${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
			});
		}
	}

	// =========================
	// FEATURE 4: Submit + Loading + Navigation
	// =========================
	Future<void> _submit() async {
		if (!_formKey.currentState!.validate()) return;

		setState(() => _isLoading = true);

		await Future.delayed(const Duration(seconds: 2));

		if (!mounted) return;

		final name = _nameController.text.trim();

		Navigator.pushReplacement(
			context,
			MaterialPageRoute(
				builder: (_) => SuccessScreen(userName: name),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Create Account'),
				backgroundColor: Colors.purple,
			),
			body: SafeArea(
				child: LayoutBuilder(
					builder: (context, constraints) {
						return SingleChildScrollView(
							padding: const EdgeInsets.all(16),
							child: ConstrainedBox(
								constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
								child: Form(
									key: _formKey,
									child: Column(
										mainAxisAlignment: MainAxisAlignment.center,
										children: [
											const Text(
												'Sign Up',
												style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
											),
											const SizedBox(height: 20),

											// =========================
											// FEATURE 1: Name Validation
											// =========================
											TextFormField(
												controller: _nameController,
												decoration: const InputDecoration(
													labelText: 'Full Name',
													prefixIcon: Icon(Icons.person),
													border: OutlineInputBorder(),
												),
												validator: (value) {
													if (value == null || value.trim().isEmpty) {
														return 'Please enter your name';
													}
													return null;
												},
											),
											const SizedBox(height: 16),

											// =========================
											// FEATURE 1: Email Validation
											// =========================
											TextFormField(
												controller: _emailController,
												keyboardType: TextInputType.emailAddress,
												decoration: const InputDecoration(
													labelText: 'Email Address',
													prefixIcon: Icon(Icons.email),
													border: OutlineInputBorder(),
												),
												validator: (value) {
													if (value == null || value.trim().isEmpty) {
														return 'Please enter your email';
													}
													if (!value.contains('@')) {
														return 'Please enter a valid email';
													}
													return null;
												},
											),
											const SizedBox(height: 16),

											// =========================
											// FEATURE 2: Birth Date Field + Date Picker
											// =========================
											TextFormField(
												controller: _birthDateController,
												readOnly: true,
												onTap: _pickBirthDate,
												decoration: InputDecoration(
													labelText: 'Birth Date',
													prefixIcon: const Icon(Icons.cake),
													border: const OutlineInputBorder(),
													suffixIcon: IconButton(
														onPressed: _pickBirthDate,
														icon: const Icon(Icons.calendar_today),
													),
												),
												validator: (value) {
													if (_selectedBirthDate == null) {
														return 'Please select your birth date';
													}
													return null;
												},
											),
											const SizedBox(height: 16),

											// =========================
											// FEATURE 1 + 3: Password Validation + Visibility Toggle
											// =========================
											TextFormField(
												controller: _passwordController,
												obscureText: !_passwordVisible,
												decoration: InputDecoration(
													labelText: 'Password',
													prefixIcon: const Icon(Icons.lock),
													border: const OutlineInputBorder(),
													suffixIcon: IconButton(
														onPressed: () {
															setState(() => _passwordVisible = !_passwordVisible);
														},
														icon: Icon(
															_passwordVisible ? Icons.visibility_off : Icons.visibility,
														),
													),
												),
												validator: (value) {
													if (value == null || value.isEmpty) {
														return 'Please enter a password';
													}
													if (value.length < 6) {
														return 'Password must be at least 6 characters';
													}
													return null;
												},
											),
											const SizedBox(height: 16),

											// =========================
											// FEATURE 1 + 3: Confirm Password Validation + Toggle
											// =========================
											TextFormField(
												controller: _confirmPasswordController,
												obscureText: !_confirmPasswordVisible,
												decoration: InputDecoration(
													labelText: 'Confirm Password',
													prefixIcon: const Icon(Icons.lock_outline),
													border: const OutlineInputBorder(),
													suffixIcon: IconButton(
														onPressed: () {
															setState(() {
																_confirmPasswordVisible = !_confirmPasswordVisible;
															});
														},
														icon: Icon(
															_confirmPasswordVisible
																	? Icons.visibility_off
																	: Icons.visibility,
														),
													),
												),
												validator: (value) {
													if (value == null || value.isEmpty) {
														return 'Please confirm your password';
													}
													if (value != _passwordController.text) {
														return 'Passwords do not match';
													}
													return null;
												},
											),
											const SizedBox(height: 24),

											// =========================
											// FEATURE 4: Loading Button
											// =========================
											SizedBox(
												width: double.infinity,
												child: ElevatedButton(
													onPressed: _isLoading ? null : _submit,
													style: ElevatedButton.styleFrom(
														backgroundColor: Colors.purple,
														padding: const EdgeInsets.symmetric(vertical: 14),
													),
													child: _isLoading
															? const SizedBox(
																	height: 20,
																	width: 20,
																	child: CircularProgressIndicator(
																		strokeWidth: 2.5,
																		color: Colors.white,
																	),
																)
															: const Text(
																	'Sign Up',
																	style: TextStyle(fontSize: 18),
																),
												),
											),
										],
									),
								),
							),
						);
					},
				),
			),
		);
	}
}
