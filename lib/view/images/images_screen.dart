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
                  Column(children: [SearchBarImages()]),
                  Column(children: [LocalImages()]),
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(fontFamily: 'Inter', fontSize: 12),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Search by name',
                  border: OutlineInputBorder()),
            ),
          )
        ],
      ),
    );
  }
}

class LocalImages extends StatelessWidget {
  const LocalImages({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        border: TableBorder.all(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(16.0)),
        dataRowHeight: 40,
        showCheckboxColumn: true,
        columns: [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Oficial')),
          DataColumn(label: Text('Stars'), numeric: true),
          DataColumn(label: Text('Pull')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('ubuntu')),
            DataCell(Icon(Icons.check)),
            DataCell(Text('25468')),
            DataCell(Icon(Icons.download)),
          ]),
          DataRow(cells: [
            DataCell(Text('ubuntu')),
            DataCell(Icon(Icons.check)),
            DataCell(Text('68231')),
            DataCell(Icon(Icons.download)),
          ]),
        ]);
  }
}
