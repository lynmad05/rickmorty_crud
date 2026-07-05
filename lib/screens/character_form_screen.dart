import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../models/character_model.dart';
import '../providers/character_provider.dart';
import '../widgets/custom_text_field.dart';

class CharacterFormScreen extends StatefulWidget {
  final CharacterModel? character;

  const CharacterFormScreen({super.key, this.character});

  @override
  State<CharacterFormScreen> createState() => _CharacterFormScreenState();
}

class _CharacterFormScreenState extends State<CharacterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _speciesController;
  late final TextEditingController _originController;
  late final TextEditingController _imageUrlController;

  String _status = 'Alive';
  String _gender = 'Unknown';
  bool _isSaving = false;

  bool get _isEditing => widget.character != null;

  @override
  void initState() {
    super.initState();
    final character = widget.character;
    _nameController = TextEditingController(text: character?.name ?? '');
    _speciesController = TextEditingController(text: character?.species ?? '');
    _originController = TextEditingController(text: character?.origin ?? '');
    _imageUrlController = TextEditingController(text: character?.imageUrl ?? '');
    _status = character?.status ?? 'Alive';
    _gender = character?.gender ?? 'Unknown';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _originController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = context.read<CharacterProvider>();
    final character = CharacterModel(
      id: widget.character?.id,
      apiId: widget.character?.apiId,
      name: _nameController.text.trim(),
      status: _status,
      species: _speciesController.text.trim(),
      gender: _gender,
      origin: _originController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
    );

    if (_isEditing) {
      await provider.updateCharacter(character);
    } else {
      await provider.addCharacter(character);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              Text(
                _isEditing ? 'Editar personaje' : 'Nuevo personaje',
                style: AppTheme.displayFont(fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                _isEditing
                    ? 'Actualiza la informacion de ${widget.character?.name ?? ''}'
                    : 'Completa los datos del nuevo personaje',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                label: 'Nombre',
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _speciesController,
                label: 'Especie',
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'La especie es obligatoria' : null,
              ),
              const SizedBox(height: 18),
              _buildDropdown(
                label: 'Estado',
                value: _status,
                options: const ['Alive', 'Dead', 'unknown'],
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 18),
              _buildDropdown(
                label: 'Genero',
                value: _gender,
                options: const ['Male', 'Female', 'Genderless', 'Unknown'],
                onChanged: (value) => setState(() => _gender = value!),
              ),
              const SizedBox(height: 18),
              CustomTextField(controller: _originController, label: 'Origen'),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _imageUrlController,
                label: 'URL de imagen',
                keyboardType: TextInputType.url,
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'La imagen es obligatoria' : null,
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4),
                        )
                      : Text(_isEditing ? 'Guardar cambios' : 'Crear personaje'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.wine600),
              items: options
                  .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
