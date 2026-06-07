import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_event.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class EmployeeSearchBar extends StatefulWidget {
  const EmployeeSearchBar({super.key});

  @override
  State<EmployeeSearchBar> createState() => _EmployeeSearchBarState();
}

class _EmployeeSearchBarState extends State<EmployeeSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorPallete.textPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPallete.divider),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          context.read<EmployeesListBloc>().add(EmployeesSearchQueryChanged(value));
        },
        style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by name or email...',
          hintStyle: TextStyle(color: ColorPallete.textPrimary.withValues(alpha: 0.3)),
          prefixIcon: const Icon(Icons.search, color: ColorPallete.textSecondary, size: 20),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: ColorPallete.textSecondary, size: 18),
                  onPressed: () {
                    _controller.clear();
                    context.read<EmployeesListBloc>().add(EmployeesSearchCleared());
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
