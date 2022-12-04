import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhoto extends StatefulWidget {
  const ViewPhoto({
    Key key,
    @required this.url,
    this.heroTag = "",
  }) : super(key: key);

  final String url;
  final String heroTag;

  @override
  State<ViewPhoto> createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 36,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Hero(
        tag: widget.heroTag,
        child: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: PhotoView(
            imageProvider: NetworkImage(widget.url),
            loadingBuilder: (context, event) {
              if (event == null) {
                return const Center(
                  child: Text("Loading"),
                );
              }

              final value = event.cumulativeBytesLoaded /
                  (event.expectedTotalBytes ?? event.cumulativeBytesLoaded);

              final percentage = (100 * value).floor();
              return Center(
                child: Text("$percentage%"),
              );
            },
          ),
        ),
      ),
    );
  }
}
