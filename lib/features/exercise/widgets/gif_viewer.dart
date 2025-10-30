import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MediaViewer extends StatefulWidget {
  final String url;
  final bool isVideo;

  const MediaViewer({super.key, required this.url, required this.isVideo});

  @override
  State<MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool get _isGif =>
      widget.url.toLowerCase().endsWith('.gif') ||
      widget.url.toLowerCase().contains('gif');

  bool get _isLocalAsset =>
      !widget.url.startsWith('http://') && !widget.url.startsWith('https://');

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: true,
            looping: true,
            showControls: false,
          );
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVideo) {
      return _chewieController != null
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: Chewie(controller: _chewieController!),
            )
          : const Center(child: CircularProgressIndicator());
    }

    // ✅ Handle GIFs properly
    if (_isGif) {
      return _isLocalAsset
          ? Image.asset(widget.url, fit: BoxFit.cover)
          : Image.network(widget.url, fit: BoxFit.cover);
    }

    // ✅ Otherwise use CachedNetworkImage for static images
    return CachedNetworkImage(
      imageUrl: widget.url,
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          const Icon(Icons.error, color: Colors.red),
    );
  }
}
