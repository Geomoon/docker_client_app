import 'package:docker_client_app/view/shared/themes/color_schemes.g.dart';
import 'package:docker_client_app/view/shared/widgets/screen_title.dart';
import 'package:flutter/material.dart';

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
                height: c.maxHeight - 140,
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
        style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
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

class LocalImages extends StatelessWidget {
  const LocalImages({super.key, required this.constraints});

  final List _itemsCard = const ['FF', 'AA', 'CC', 'fdsaf', 'GH', 'OK', 'LK'];
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24.0),
      height: constraints.maxHeight - 300,
      child: GridView.builder(
        itemCount: _itemsCard.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
          mainAxisExtent: 100,
        ),
        itemBuilder: (context, index) =>
            LocalImageCard(name: _itemsCard[index]),
      ),
    );
  }
}

class LocalImageCard extends StatelessWidget {
  const LocalImageCard({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(6.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [SelectableText(name)],
        ),
      ),
    );
  }
}
