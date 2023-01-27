import 'package:foodz/endpoints/base/json.serializable.dart';

class PaginationOptions implements JsonSerializable {
  final int pageNumber;
  final int itemsPerPage;
  const PaginationOptions({this.pageNumber = 0, this.itemsPerPage = 5});

  @override
  Map<String, dynamic> toJson() {
    return {"pageNumber": pageNumber, "itemsPerPage": itemsPerPage};
  }
}
