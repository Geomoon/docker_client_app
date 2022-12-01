import 'package:docker_client_app/application/images/images_interactor.dart';
import 'package:docker_client_app/datasource/images/images_output_adapter.dart';
import 'package:docker_client_app/domain/images/ports/input/image_dto.dart';
import 'package:docker_client_app/view/shared/themes/color_schemes.g.dart';
import 'package:docker_client_app/view/shared/widgets/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImagesScreen extends StatelessWidget {
  const ImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40.0),
      child: LayoutBuilder(builder: (_, c) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const ScreenTitle('Images'),
          const SizedBox(height: 20.0),
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
                  Column(children: [
                    SearchBarImages(),
                    LocalImages(
                      constraints: c,
                    )
                  ]),
                  Column(children: []),
                ]),
              )
            ]),
          ),
        ]);
      }),
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

class SearchBarImages extends StatelessWidget {
  const SearchBarImages({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextField(
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            hintText: 'Search by name',
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.outline))),
      ),
    );
  }
}

class LocalImages extends StatefulWidget {
  const LocalImages({super.key, required this.constraints});

  final BoxConstraints constraints;

  @override
  State<LocalImages> createState() => _LocalImagesState();
}

class _LocalImagesState extends State<LocalImages> {
  final ImagesInteractor interactor = ImagesInteractor(ImagesOutputAdapter());

  late Future _items;

  @override
  void initState() {
    super.initState();
    _items = _list();
  }

  Future<List<ImageDTO>> _list() async {
    return await interactor.getAll();
  }

/*
  void getImages() async {
    // if (_items.isNotEmpty) return;

    List<ImageDTO> images = await interactor.getAll();
    _items = [...images];
    print('QUERYY');
  }*/

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

    return Container(
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
              mainAxisExtent: cardHeight,
            ),
            itemBuilder: (context, index) => LocalImageCard(
                name: snapshot.data![index].id!,
                createdAt: snapshot.data![index].createdAt!,
                tags: snapshot.data![index].repoTags,
                ports: snapshot.data![index].exposedPorts),
          );
        },
      ),
    );
  }
}

class LocalImageCard extends StatelessWidget {
  const LocalImageCard({
    super.key,
    required this.name,
    required this.createdAt,
    this.ports = const [],
    this.tags = const [],
  });

  final String name;
  final List<String>? tags;
  final List<String>? ports;
  final DateTime createdAt;

  final TextStyle textStyle = const TextStyle(fontFamily: 'JetBrains');

  String _buildTagsString() => tags != null ? tags!.join(', ') : '';
  String _buildPortsString() => ports != null ? ports!.join(' - ') : '';
  String _buildID() => name.substring(7, 19);
  String _formatDate() => DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);

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
          //crossAxisAlignment: WrapCrossAlignment.start,
          //alignment: WrapAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ID: ', style: textStyle),
                Expanded(child: SelectableText(_buildID())),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.info_rounded),
                    color: Theme.of(context).colorScheme.primary)
              ],
            ),
            const SizedBox(height: 14.0),
            SelectableText(_buildTagsString()),
            const SizedBox(height: 14.0),
            Text('EXPOSED PORTS:', style: textStyle),
            SelectableText(_buildPortsString()),
            const SizedBox(height: 14.0),
            Text(_formatDate())
          ],
        ),
      ),
    );
  }
}
