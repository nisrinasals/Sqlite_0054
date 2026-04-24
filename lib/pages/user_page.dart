import 'package:flutter/material.dart';
import 'package:sqlite/bloc/user_bloc.dart';
import 'package:sqlite/bloc/user_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite/domain/entities/user_entity.dart';

class UserFormPage extends StatefulWidget {
  final UserEntity? user;

  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _noTelponController = TextEditingController();
  final _alamatController = TextEditingController();
  String? _noTelponError;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _noTelponController.text = widget.user!.noTelpon;
      _alamatController.text = widget.user!.alamat;
    }
  }

  String? validateNoTelpon(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!value.startsWith('+62')) {
      return 'Nomor harus dimulai dengan +62';
    }
    if (value.length > 15) {
      return 'Nomor telepon tidak boleh melebihi 15 karakter';
    }
    return null;
  }

  void _validateNoTelpon() {
    setState(() {
      _noTelponError = validateNoTelpon(_noTelponController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit User" : "Tambah User"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Avatar placeholder
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  isEdit ? Icons.person : Icons.person_add,
                  size: 50,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noTelponController,
              keyboardType: TextInputType.phone,
              onChanged: (_) => _validateNoTelpon(),
              decoration: InputDecoration(
                labelText: "No. Telepon",
                hintText: "+62xxxxxxxxxx",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.phone_outlined),
                filled: true,
                fillColor: Colors.grey[50],
                errorText: _noTelponError,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _alamatController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Alamat",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.location_on_outlined),
                filled: true,
                fillColor: Colors.grey[50],
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                // Validate all fields
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nama tidak boleh kosong")),
                  );
                  return;
                }
                if (validateNoTelpon(_noTelponController.text) != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(validateNoTelpon(_noTelponController.text)!)),
                  );
                  return;
                }
                if (_alamatController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Alamat tidak boleh kosong")),
                  );
                  return;
                }

                final newUser = UserEntity(
                  id: isEdit
                      ? widget.user!.id
                      : DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  email: _emailController.text,
                  noTelpon: _noTelponController.text,
                  alamat: _alamatController.text,
                );

                if (isEdit) {
                  context.read<UserBloc>().add(UpdateUserEvent(newUser));
                } else {
                  context.read<UserBloc>().add(AddUserEvent(newUser));
                }

                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.save),
              // FIX: Changed 'child' to 'label' below
              label: Text(
                isEdit ? "Simpan Perubahan" : "Simpan User Baru",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}