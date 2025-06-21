enum ArticleComponentType {
  heading,
  text,
  quote,
  table,
  list,
  image,
  divider,
  code,
  video,
  audio,
}

class ArticleComponentModel {
  final String id;
  final ArticleComponentType type;
  final Map<String, dynamic> content;
  final Map<String, dynamic>? style;

  ArticleComponentModel({
    required this.id,
    required this.type,
    required this.content,
    this.style,
  });

  factory ArticleComponentModel.fromJson(Map<String, dynamic> json) {
    return ArticleComponentModel(
      id: json['id'],
      type: ArticleComponentType.values.firstWhere(
            (e) => e.toString().split('.').last == json['type'],
      ),
      content: json['content'],
      style: json['style'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'content': content,
      'style': style,
    };
  }

  // Factory constructors for each component type
  factory ArticleComponentModel.heading({
    required String id,
    required String text,
    required int level, // 1-6
    String? anchor,
  }) {
    return ArticleComponentModel(
      id: id,
      type: ArticleComponentType.heading,
      content: {
        'text': text,
        'level': level,
        'anchor': anchor,
      },
    );
  }

  factory ArticleComponentModel.text({
    required String id,
    required String text,
    bool isBold = false,
    bool isItalic = false,
    String? alignment,
  }) {
    return ArticleComponentModel(
      id: id,
      type: ArticleComponentType.text,
      content: {
        'text': text,
        'isBold': isBold,
        'isItalic': isItalic,
        'alignment': alignment,
      },
    );
  }

  factory ArticleComponentModel.quote({
    required String id,
    required String text,
    String? author,
    String? source,
  }) {
    return ArticleComponentModel(
      id: id,
      type: ArticleComponentType.quote,
      content: {
        'text': text,
        'author': author,
        'source': source,
      },
    );
  }

  factory ArticleComponentModel.table({
    required String id,
    required List<List<String>> data,
    List<String>? headers,
    String? caption,
  }) {
    return ArticleComponentModel(
      id: id,
      type: ArticleComponentType.table,
      content: {
        'data': data,
        'headers': headers,
        'caption': caption,
      },
    );
  }

  factory ArticleComponentModel.list({
    required String id,
    required List<String> items,
    bool isOrdered = false,
    String? title,
  }) {
    return ArticleComponentModel(
      id: id,
      type: ArticleComponentType.list,
      content: {
        'items': items,
        'isOrdered': isOrdered,
        'title': title,
      },
    );
  }

  factory ArticleComponentModel.image({
    required String id,
    required String url,
    String? caption,
    String? alt,
    double? width,
    double? height,
  }) {
    return ArticleComponentModel(
      id: id,
      type: ArticleComponentType.image,
      content: {
        'url': url,
        'caption': caption,
        'alt': alt,
        'width': width,
        'height': height,
      },
    );
  }

  factory ArticleComponentModel.code({
    required String id,
    required String code,
    String? language,
    String? title,
    bool showLineNumbers = false,
  }) {
    return ArticleComponentModel(
      id: id,
      type: ArticleComponentType.code,
      content: {
        'code': code,
        'language': language,
        'title': title,
        'showLineNumbers': showLineNumbers,
      },
    );
  }

  factory ArticleComponentModel.divider({
    required String id,
    double thickness = 1.0,
    String? style, // solid, dashed, dotted
  }) {
    return ArticleComponentModel(
      id: id,
      type: ArticleComponentType.divider,
      content: {
        'thickness': thickness,
        'style': style ?? 'solid',
      },
    );
  }

  // Getters for easy access to content
  String get textContent => content['text'] ?? '';
  int get headingLevel => content['level'] ?? 1;
  String? get author => content['author'];
  String? get caption => content['caption'];
  List<String> get listItems => List<String>.from(content['items'] ?? []);
  bool get isOrderedList => content['isOrdered'] ?? false;
  List<List<String>> get tableData =>
      (content['data'] as List?)?.cast<List<String>>() ?? [];
  List<String>? get tableHeaders =>
      (content['headers'] as List?)?.cast<String>();
  String get imageUrl => content['url'] ?? '';
  String get codeContent => content['code'] ?? '';
  String? get codeLanguage => content['language'];
}