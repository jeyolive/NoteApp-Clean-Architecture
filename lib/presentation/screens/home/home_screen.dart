import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:note_app/common/constants.dart';
import 'package:note_app/common/strings.dart';
import 'package:note_app/domain/model/note.dart';
import 'package:note_app/presentation/components/components.dart';
import 'package:note_app/presentation/routes/routes.dart';
import 'package:note_app/presentation/theme/spacing.dart';

import 'bloc/home_bloc.dart';
import 'widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NoteAppBar(
        systemUiOverlayStyle: SystemUiOverlayStyle.light,
        autoImplementLeading: false,
        title: StringConstants.homeAppBarTitle,
      ),
      floatingActionButton: FadeInRight(
        delay: animationDuration,
        child: FloatingActionButton(
          onPressed: () {
            context.router.push(AddUpdateNoteRoute());
          },
          child: const Icon(FeatherIcons.plus),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, state) {
          return state.maybeMap(
            orElse: () => const ErrorText('Loading..'),
            error: (error) => ErrorText(error.message ?? ''),
            loaded: (data) => _BuildNotesList(notes: data.notes),
          );
        },
      ),
    );
  }
}

class _BuildNotesList extends StatelessWidget {
  const _BuildNotesList({
    Key? key,
    required this.notes,
  }) : super(key: key);

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.xl,
        vertical: AppSpacings.xl,
      ),
      crossAxisCount: 2,
      shrinkWrap: true,
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) {
        return FadeInUp(
          duration: Duration(milliseconds: 100 * index),
          child: NoteCard(note: notes[index]),
        );
      },
      staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
      mainAxisSpacing: AppSpacings.l,
      crossAxisSpacing: AppSpacings.l,
    );
  }
}
