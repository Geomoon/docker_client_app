import 'package:docker_client_app/view/shared/themes/color_schemes.g.dart';
import 'package:flutter/material.dart';

import '../shared/widgets/screen_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        children: const [
          Expanded(flex: 6, child: MainContent()),
          SizedBox(width: 20.0),
          Expanded(flex: 2, child: SideBarHome())
        ],
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  final List<ItemCard> itemsCard = const [
    ItemCard(
        title: 'Containers',
        total: 12,
        icon: Icons.widgets_rounded,
        moreInfo: '3 running'),
    ItemCard(title: 'Images', total: 14, icon: Icons.layers_rounded),
    ItemCard(title: 'Mounts', total: 6, icon: Icons.dns_rounded),
    ItemCard(title: 'Networks', total: 4, icon: Icons.stream_rounded),
  ];

  SizedBox buildMainCards() {
    return SizedBox(
      height: 440,
      child: GridView.builder(
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
          mainAxisExtent: 200,
        ),
        itemBuilder: (context, index) => itemsCard[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  children: const [ScreenTitle('Dashboard')],
                ),
                const SizedBox(height: 30),
                buildMainCards(),
                Divider(
                    height: 1, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class SideBarHome extends StatelessWidget {
  const SideBarHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(14.0),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight - 40),
              child: IntrinsicHeight(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Docs',
                          style: TextStyle(
                              fontFamily: 'Epilogue', fontSize: 20.0)),
                      const SizedBox(height: 34.0),
                      const HyperLinkCard(
                          title: 'Official Repository',
                          description:
                              'Visit our official repository on GitHub!',
                          buttonText: 'Visit',
                          url: ''),
                      Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline),
                      const PopularImagesList(),
                      const HyperLinkCard(
                          title: 'Docker Docs',
                          description:
                              'Learn with the official Docker documentation',
                          buttonText: 'Learn',
                          url: ''),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PopularImagesList extends StatelessWidget {
  const PopularImagesList({
    Key? key,
  }) : super(key: key);

  final List<List<String>> repos = const [
    ['Ubuntu', 'ubuntu-url-repo'],
    ['MySQL', 'mysql-repo-url'],
    ['Nginx', 'nginx-repo-url'],
    ['MongoDB', 'nginx-repo-url'],
    ['Node JS', 'nginx-repo-url']
  ];

  SizedBox _buildItemList(BuildContext context, List<String> item,
      {bool isFirst = false, bool isLast = false}) {
    SizedBox firstBox;
    if (isFirst) {
      firstBox = const SizedBox(height: 6);
    } else {
      firstBox = SizedBox(
        height: 6,
        child: VerticalDivider(
            width: 10,
            thickness: 1,
            color: Theme.of(context).colorScheme.secondary),
      );
    }

    SizedBox lastBox;
    if (isLast) {
      lastBox = const SizedBox(height: 16, width: 10);
    } else {
      lastBox = SizedBox(
        height: 16,
        width: 10,
        child: VerticalDivider(
            width: 10,
            thickness: 1,
            color: Theme.of(context).colorScheme.secondary),
      );
    }

    return SizedBox(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            firstBox,
            Icon(Icons.circle,
                size: 8, color: Theme.of(context).colorScheme.primary),
            lastBox
          ]),
          const SizedBox(width: 16),
          Text(item[0], style: const TextStyle(fontFamily: 'JetBrains'))
        ],
      ),
    );
  }

  List<SizedBox> _buildList(BuildContext context) {
    List<SizedBox> mapped = [];

    mapped.add(_buildItemList(context, repos[0], isFirst: true));
    for (var i = 1; i < repos.length - 1; i++) {
      mapped.add(_buildItemList(context, repos[i]));
    }
    mapped.add(_buildItemList(context, repos[repos.length - 1], isLast: true));

    return mapped;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = _buildList(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Popular Images', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 12),
        ...items
      ],
    );
  }
}

class HyperLinkCard extends StatefulWidget {
  const HyperLinkCard({
    super.key,
    required this.title,
    this.description,
    required this.buttonText,
    required this.url,
  });

  final String title;
  final String? description;
  final String url;
  final String buttonText;

  @override
  State<HyperLinkCard> createState() => _HyperLinkCardState();
}

class _HyperLinkCardState extends State<HyperLinkCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: const TextStyle(fontFamily: 'Epilogue', fontSize: 16.0)),
            Text(widget.description!,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12.0)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: () {}, child: Text(widget.buttonText))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.title,
    required this.total,
    required this.icon,
    this.moreInfo,
  });

  final String title;
  final int total;
  final IconData icon;
  final String? moreInfo;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    const hoverCardColor = Color(0xFF13233A);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: InkWell(
        splashColor: hoverCardColor,
        highlightColor: hoverCardColor,
        onTap: () {},
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${widget.total}',
                      style: const TextStyle(
                          fontFamily: 'JetBrains',
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold)),
                  Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(6.0)),
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(widget.icon, color: darkColorScheme.primary)),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                widget.title,
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 18.0),
              _buildMoreInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreInfo() {
    if (widget.moreInfo == null) {
      return const Text('');
    }
    return Row(
      children: [
        const Icon(Icons.circle, color: Color(0xFF39D353), size: 10),
        const SizedBox(width: 20.0),
        Text(
          widget.moreInfo!,
          style: const TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }
}
