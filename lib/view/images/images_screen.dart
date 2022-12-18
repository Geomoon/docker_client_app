import 'package:docker_client_app/application/images/images_interactor.dart';
import 'package:docker_client_app/application/images_docker_hub/images_dh_interactor.dart';
import 'package:docker_client_app/datasource/images/images_output_adapter.dart';
import 'package:docker_client_app/datasource/images_docker_hub/images_dh_output_adapter.dart';
import 'package:docker_client_app/domain/images/ports/input/image_dto.dart';
import 'package:docker_client_app/domain/images_docker_hub/image_docker_hub.dart';
import 'package:docker_client_app/view/shared/themes/color_schemes.g.dart';
import 'package:docker_client_app/view/shared/widgets/screen_title.dart';
import 'package:flutter/material.dart';

import '../shared/utils.dart';
import '../shared/widgets/search_bar.dart';
import '../shared/widgets/three_state_button.dart';

class ImagesScreen extends StatelessWidget {
  const ImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40.0),
      child: LayoutBuilder(builder: (_, c) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const ScreenTitle('Images'),
          const SizedBox(height: 10.0),
          DefaultTabController(
            length: 2,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TabBar(
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.white,
                  unselectedLabelColor: fonts['colors'],
                  labelPadding: const EdgeInsets.all(0),
                  indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0)),
                  tabs: const [
                    FilledTab(text: 'Local'),
                    FilledTab(text: 'Docker Hub'),
                  ]),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                height: c.maxHeight - 120,
                child: TabBarView(children: [
                  LocalImagesView(constraints: c),
                  DockerHubImagesView(constraints: c),
                ]),
              )
            ]),
          ),
        ]);
      }),
    );
  }
}

class LocalImagesView extends StatefulWidget {
  const LocalImagesView({Key? key, required this.constraints})
      : super(key: key);

  final BoxConstraints constraints;

  @override
  State<LocalImagesView> createState() => _LocalImagesViewState();
}

class _LocalImagesViewState extends State<LocalImagesView> {
  final ImagesInteractor _interactor = ImagesInteractor(ImagesOutputAdapter());

  late Future<List<ImageDTO>> _items;

  @override
  void initState() {
    super.initState();
    _items = _list();
  }

  void _searchImages(String name) {
    if (name.isEmpty) {
      setState(() {
        _items = _interactor.getAll();
      });
    } else {
      setState(() {
        _items = _interactor.getByRepository(name);
      });
    }
  }

  Future<List<ImageDTO>> _list() async {
    return await _interactor.getAll();
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

  void _showImageInfoDialog(BuildContext context, String imageId) async {
    String scheme = await _interactor.getSchemeById(imageId);
    showDialog(
        context: context,
        builder: (context) => ImageSchemeDialog(scheme: scheme));
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
        ? 200
        : (widget.constraints.maxWidth >= 720 ? 240 : 200);

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchBar(
              hintText: 'Search by name or id',
              width: 300,
              onSearch: _searchImages),
          const SizedBox(width: 20.0),
          ThreeStateButton(
            onTapState1: _orderByDateDesc,
            onTapState2: _orderByDateAsc,
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.only(top: 24.0),
        height: widget.constraints.maxHeight - 200,
        child: FutureBuilder(
          future: _items,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: cardHeight),
              itemBuilder: (context, index) => LocalImageCard(
                  imageDTO: snapshot.data![index],
                  onPressInfo: () =>
                      _showImageInfoDialog(context, snapshot.data![index].id!)),
            );
          },
        ),
      )
    ]);
  }
}

class ImageSchemeDialog extends StatefulWidget {
  const ImageSchemeDialog({super.key, required this.scheme});

  final String scheme;

  @override
  State<ImageSchemeDialog> createState() => _ImageSchemeDialogState();
}

class _ImageSchemeDialogState extends State<ImageSchemeDialog> {
  bool _isCopied = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        height: 720,
        width: 1280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text('Image Scheme',
                        style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: fonts['color']))),
                _isCopied
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFF39D353).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24.0)),
                        child: Row(
                          children: const [
                            Text('Copied',
                                style: TextStyle(color: Color(0xFF39D353))),
                            SizedBox(width: 6.0),
                            Icon(Icons.done_rounded, color: Color(0xFF39D353)),
                          ],
                        ))
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
            const SizedBox(height: 10.0),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 620, maxWidth: 1230),
                child: IntrinsicHeight(
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
            )
          ],
        ),
      ),
    );
  }
}

class LocalImageCard extends StatelessWidget {
  const LocalImageCard(
      {super.key, required this.imageDTO, required this.onPressInfo});

  final ImageDTO imageDTO;

  final Function() onPressInfo;

  final TextStyle textStyle = const TextStyle(fontFamily: 'JetBrains');

  String _buildTagsString() =>
      imageDTO.repoTags != null ? imageDTO.repoTags!.join(', ') : '';

  String _buildPortsString() =>
      imageDTO.exposedPorts != null ? imageDTO.exposedPorts!.join(' - ') : '';

  String _buildID() => imageDTO.id!.substring(7, 19);

  String _formatDate() => formatDate(imageDTO.createdAt!);

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
            Expanded(child: SelectableText(_buildTagsString())),
            const SizedBox(height: 14.0),
            Text('EXPOSED PORTS:', style: textStyle),
            Expanded(child: SelectableText(_buildPortsString())),
            const SizedBox(height: 14.0),
            Text(_formatDate())
          ],
        ),
      ),
    );
  }
}

class FilledTab extends StatelessWidget {
  const FilledTab({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Text(text),
      ),
    );
  }
}

// Docker HUB

class DockerHubImagesView extends StatefulWidget {
  const DockerHubImagesView({Key? key, required this.constraints})
      : super(key: key);
  final BoxConstraints constraints;

  @override
  State<DockerHubImagesView> createState() => _DockerHubImagesViewState();
}

class _DockerHubImagesViewState extends State<DockerHubImagesView> {
  final ImagesDHInteractor _interactor =
      ImagesDHInteractor(ImagesDHOutputAdapter());

  void _searchImages(String name) {
    if (name.isEmpty) return;

    setState(() {
      _items = _interactor.findByName(name);
    });
  }

  late Future<List<ImageDH>> _items;

  @override
  void initState() {
    super.initState();
    _items = Future.value([]);
  }

  Future<bool> _onPullImage(String name) async {
    bool installed = await _interactor.pullImage(name);
    return installed;
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = widget.constraints.maxWidth > 1260
        ? 4
        : (widget.constraints.maxWidth >= 720
            ? 3
            : (widget.constraints.maxWidth >= 620 ? 2 : 1));

    double cardHeight = widget.constraints.maxWidth > 1260
        ? 200
        : (widget.constraints.maxWidth >= 720 ? 240 : 200);

    return Column(children: [
      SearchBar(
          onSearch: _searchImages, hintText: 'Search by name', width: 400),
      Container(
        padding: const EdgeInsets.only(top: 24.0),
        height: widget.constraints.maxHeight - 200,
        child: FutureBuilder(
          future: _items,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('Search on Docker Hub',
                      style:
                          TextStyle(fontFamily: 'JetBrains', fontSize: 14.0)));
            }

            return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: cardHeight),
                itemBuilder: (context, index) => DockerHubImageCard(
                      snapshot.data![index],
                      onPull: _onPullImage,
                    ));
          },
        ),
      )
    ]);
  }
}

class DockerHubImageCard extends StatefulWidget {
  const DockerHubImageCard(this._imageDH, {super.key, required this.onPull});

  final ImageDH _imageDH;

  final Future<bool> Function(String) onPull;

  @override
  State<DockerHubImageCard> createState() => _DockerHubImageCardState();
}

class _DockerHubImageCardState extends State<DockerHubImageCard> {
  final TextStyle textStyle = const TextStyle(fontFamily: 'JetBrains');

  int _pulledState = 0;

  void _onPullAction() async {
    setState(() => _pulledState = 1);
    bool isPulled = await widget.onPull(widget._imageDH.name);
    if (isPulled) {
      setState(() => _pulledState = 2);
    } else {
      setState(() => _pulledState = 0);
    }
  }

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
                widget._imageDH.isOfficial
                    ? const Icon(Icons.verified_rounded,
                        color: Color(0xFF39D353))
                    : Container(),
                widget._imageDH.isOfficial
                    ? const SizedBox(width: 10.0)
                    : Container(),
                Expanded(child: SelectableText(widget._imageDH.name)),
                _pulledState == 0
                    ? ElevatedButton.icon(
                        onPressed: _onPullAction,
                        icon: const Icon(Icons.arrow_downward_rounded),
                        label: const Text('Pull'))
                    : _pulledState == 1
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())
                        : const Icon(Icons.done_rounded)
              ],
            ),
            const SizedBox(height: 14.0),
            Expanded(child: Text(widget._imageDH.description)),
            const SizedBox(height: 14.0),
            Row(children: [
              Icon(Icons.arrow_downward_rounded,
                  color: Theme.of(context).colorScheme.primary),
              Text('${widget._imageDH.pullCount}', style: textStyle),
              const SizedBox(width: 20.0),
              Icon(Icons.star_rounded,
                  color: Theme.of(context).colorScheme.primary),
              Text('${widget._imageDH.starCount}', style: textStyle)
            ])
          ],
        ),
      ),
    );
  }
}
