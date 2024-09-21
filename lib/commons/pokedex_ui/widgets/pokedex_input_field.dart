import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/commons/pokedex_ui/stores/validator_store.dart';
import '../palettes/colors.dart';

class PokedexInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const PokedexInputField({
    Key? key,
    required this.hintText,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  State<PokedexInputField> createState() => _PokedexInputFieldState();
}

class _PokedexInputFieldState extends State<PokedexInputField> {
  static const double _radios = 30.0;
  late ValidatorStore _validatorStore;
  late bool hasController;

  @override
  void initState() {
    super.initState();
    _validatorStore = ValidatorStore(false);
    hasController = widget.controller != null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.0,
      child: Observer(
        builder: (_) {
          return TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: (inputted) => runInAction(() => _validatorStore.updateValue(inputted.isNotEmpty)),
            cursorColor: AppColors.neutral,
            textInputAction: TextInputAction.search,
            style: TextStyle(
              color: AppColors.neutral,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.light,
              disabledBorder: InputBorder.none,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(_radios)),
                borderSide: BorderSide(
                  color: AppColors.shadow,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(_radios)),
                borderSide: BorderSide(color: AppColors.shadow),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(_radios)),
                borderSide: BorderSide(
                  color: AppColors.shadow,
                ),
              ),
              suffixIcon: _validatorStore.value.value && hasController
                  ? GestureDetector(
                onTap: () {
                  widget.controller!.clear();
                  _validatorStore.updateValue(false); // Reset validation after clearing
                },
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.primary,
                ),
              )
                  : null,
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.primary,
              ),
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.all(7.0),
              hintStyle: const TextStyle(fontSize: 14),
            ),
          );
        },
      ),
    );
  }
}
