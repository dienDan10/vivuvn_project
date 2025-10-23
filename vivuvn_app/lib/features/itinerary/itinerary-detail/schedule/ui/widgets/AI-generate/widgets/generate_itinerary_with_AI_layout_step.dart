import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'budget_field.dart';
import 'group_size_field.dart';
import 'note_field.dart';
import 'selected_interests_section.dart';
import 'title_section.dart';

class GenerateItineraryWithAiLayout extends ConsumerWidget {
  final GlobalKey<FormState>? formKey;

  const GenerateItineraryWithAiLayout({super.key, this.formKey});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // This widget expects the parent to pass a formKey so the form state
    // survives rebuilds. Assert in debug to catch incorrect usage early.
    assert(
      formKey != null,
      'GenerateItineraryWithAiLayout requires a formKey from its parent',
    );

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TitleSection(),

              BudgetField(),

              SizedBox(height: 16),

              GroupSizeField(),

              SizedBox(height: 16),

              NoteField(),

              SizedBox(height: 20),

              SelectedInterestsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
