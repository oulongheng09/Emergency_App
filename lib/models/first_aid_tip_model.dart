class FirstAidTip {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final int displayOrder;

  const FirstAidTip({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.displayOrder,
  });

  factory FirstAidTip.fromJson(
    Map<String, dynamic> json,
  ) {
    return FirstAidTip(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      displayOrder: json['display_order'] ?? 1,
    );
  }
}