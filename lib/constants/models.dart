class Charity {
  final String name;
  final String link;
  final String tag;
  final String img;

  Charity({
    required this.name,
    required this.link,
    required this.tag,
    required this.img,
  });

  factory Charity.fromMap(Map charity) {
    return Charity(
      name: charity['name'] as String,
      link: charity['link'] as String,
      tag: charity['tag'] as String,
      img: charity['img'] as String,
    );
  }
}
class Info {
  final String name;
  final String link;
  final String img;

  Info({
    required this.name,
    required this.link,   
    required this.img,
  });

  factory Info.fromMap(Map charity) {
    return Info(
      name: charity['name'] as String,
      link: charity['link'] as String,
      img: charity['img'] as String,
    );
  }
}


