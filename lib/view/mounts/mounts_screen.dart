import 'package:docker_client_app/application/mounts/mounts_interactor.dart';
import 'package:docker_client_app/datasource/mounts/mounts_output_adapter.dart';
import 'package:docker_client_app/domain/mounts/ports/input/volume_dto.dart';
import 'package:docker_client_app/view/shared/utils.dart';
import 'package:docker_client_app/view/shared/widgets/success_button.dart';
import 'package:flutter/material.dart';

import '../../domain/mounts/ports/input/mounts_input_port.dart';
import '../shared/themes/color_schemes.g.dart';
import '../shared/widgets/red_button_icon.dart';
import '../shared/widgets/screen_title.dart';
import '../shared/widgets/search_bar.dart';
import '../shared/widgets/three_state_button.dart';

class MountsScreen extends StatelessWidget {
  const MountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40.0),
      child: LayoutBuilder(builder: (_, c) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Expanded(child: ScreenTitle('Mounts'))],
          ),
          const SizedBox(height: 20.0),
          Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              padding: const EdgeInsets.only(top: 20.0),
              height: c.maxHeight - 64,
              child: VolumesView(MountsInteractor(MountsOutputAdapter()),
                  constraints: c))
          //,)
        ]);
      }),
    );
  }
}

class VolumesView extends StatefulWidget {
  const VolumesView(this._interactor, {super.key, required this.constraints});

  final MountsInputPort _interactor;

  final BoxConstraints constraints;

  @override
  State<VolumesView> createState() => _VolumesViewState();
}

class _VolumesViewState extends State<VolumesView> {
  late Future<List<VolumeDTO>> _items;

  @override
  void initState() {
    super.initState();
    _items = widget._interactor.getAllVolumes();
  }

  void _searchImages(String name) {
    if (name.isEmpty) {
      setState(() {
        _items = widget._interactor.getAllVolumes();
      });
    } else {
      setState(() {
        _items = widget._interactor.getVolumesByRegexID(name);
      });
    }
  }

  void _orderByDateAsc() {
    _items.then((value) => value.sort(
          (a, b) => a.createdAt!.isAfter(b.createdAt!) ? 1 : 0,
        ));
    setState(() {});
  }

  void _orderByDateDesc() {
    _items.then((value) => value.sort(
          (a, b) => a.createdAt!.isBefore(b.createdAt!) ? 1 : 0,
        ));
    setState(() {});
  }

  void _showVolumeInfoDialog(BuildContext context, String imageId) async {
    String scheme = await widget._interactor.getVolumeSchemeById(imageId);
    showDialog(
        context: context,
        builder: (context) => VolumeSchemeDialog(scheme: scheme));
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = widget.constraints.maxWidth > 1260
        ? 5
        : widget.constraints.maxWidth >= 1080
            ? 4
            : (widget.constraints.maxWidth >= 720
                ? 3
                : (widget.constraints.maxWidth >= 620 ? 2 : 1));

    double cardHeight = widget.constraints.maxWidth > 1260
        ? 140
        : (widget.constraints.maxWidth >= 720 ? 160 : 160);

    return Column(children: [
      Row(
        children: [
          SearchBar(
              hintText: 'Search by name', width: 300, onSearch: _searchImages),
          const SizedBox(width: 20.0),
          ThreeStateButton(
            onTapState1: _orderByDateDesc,
            onTapState2: _orderByDateAsc,
          ),
          Expanded(child: Container()),
          SizedBox(
            height: 50.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Add your onPressed code here!
              },
              foregroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              backgroundColor: Theme.of(context).colorScheme.background,
              hoverColor: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.08),
              focusColor: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.12),
              elevation: 0,
              label: const Text('Create volume'),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.only(top: 24.0),
        height: widget.constraints.maxHeight - 140,
        child: FutureBuilder(
          future: _items,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No volumes'));
            }

            return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: cardHeight),
                itemBuilder: (context, index) => VolumeCard(
                    volumeDTO: snapshot.data![index],
                    onPressInfo: () => _showVolumeInfoDialog(
                        context, snapshot.data![index].name!)));
          },
        ),
      )
    ]);
  }
}

class VolumeCard extends StatelessWidget {
  const VolumeCard(
      {super.key, required this.volumeDTO, required this.onPressInfo});

  final VolumeDTO volumeDTO;

  final Function() onPressInfo;

  final TextStyle textStyle = const TextStyle(fontFamily: 'JetBrains');

  String _buildID() => volumeDTO.name!.length >= 13
      ? volumeDTO.name!.substring(0, 13)
      : volumeDTO.name!;

  String _formatDate() => formatDate(volumeDTO.createdAt!);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(6.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ID: ', style: textStyle),
                Expanded(child: SelectableText(_buildID())),
                IconButton(
                    onPressed: onPressInfo,
                    icon: const Icon(Icons.info_rounded),
                    color: Theme.of(context).colorScheme.primary)
              ],
            ),
            const SizedBox(height: 14.0),
            Expanded(child: Text(volumeDTO.scope!)),
            const SizedBox(height: 14.0),
            Text(_formatDate())
          ],
        ),
      ),
    );
  }
}

class VolumeSchemeDialog extends StatefulWidget {
  const VolumeSchemeDialog({super.key, required this.scheme});

  final String scheme;

  @override
  State<VolumeSchemeDialog> createState() => _VolumeSchemeDialogState();
}

class _VolumeSchemeDialogState extends State<VolumeSchemeDialog> {
  bool _isCopied = false;
  final BorderRadius _borderRadius = BorderRadius.circular(12.0);
  final Radius _radius = const Radius.circular(12.0);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: _borderRadius,
          side: BorderSide(
              width: 1.0, color: Theme.of(context).colorScheme.outline)),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        height: 480,
        width: 1078,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius:
                      BorderRadius.only(topLeft: _radius, topRight: _radius)),
              child: Row(
                children: [
                  Expanded(
                      child: Text('Volume Scheme',
                          style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: fonts['color']))),
                  RedButtonIcon(onPressed: () {}),
                  const SizedBox(width: 10.0),
                  _isCopied
                      ? const SuccessButton(text: 'Copied')
                      : ElevatedButton.icon(
                          onPressed: () async {
                            await copyToClipboard(widget.scheme);
                            setState(() {
                              _isCopied = true;
                            });
                          },
                          icon: const Icon(Icons.copy_rounded),
                          label: const Text('Copy scheme')),
                  const SizedBox(width: 10.0),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded),
                      label: const Text('Close')),
                ],
              ),
            ),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 600, maxWidth: 1230),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Expanded(
                            child: SelectableText(widget.scheme,
                                style: TextStyle(
                                    fontFamily: 'JetBrains',
                                    color: fonts['color'],
                                    fontWeight: FontWeight.normal))),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CreateVolumeDialog extends StatefulWidget {
  const CreateVolumeDialog({super.key});

  @override
  State<CreateVolumeDialog> createState() => _CreateVolumeDialogState();
}

class _CreateVolumeDialogState extends State<CreateVolumeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(),
    );
  }
}
