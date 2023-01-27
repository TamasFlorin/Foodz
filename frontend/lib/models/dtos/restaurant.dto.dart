import 'package:flutter/material.dart';
import 'package:foodz/endpoints/base/json.serializable.dart';
import 'package:foodz/models/dtos/pagination.options.dto.dart';
import 'package:foodz/util/util.dart';

class CreateRestaurantDto implements JsonSerializable {
  final String name;
  final String address;

  const CreateRestaurantDto({@required this.name, @required this.address});

  @override
  Map<String, dynamic> toJson() {
    return {"name": name, "address": address};
  }
}

enum FilterOperator {
  Equal,
  GreaterThan,
  GeaterThanOrEqual,
  LessThan,
  LessThanOrEqual,
  NotEqual,
}

extension FilterOperatorExtension on FilterOperator {
  String get string {
    switch (this) {
      case FilterOperator.Equal:
        return r'$eq';
      case FilterOperator.GreaterThan:
        return r'$gt';
      case FilterOperator.GeaterThanOrEqual:
        return r'$gte';
      case FilterOperator.LessThan:
        return r'$lt';
      case FilterOperator.LessThanOrEqual:
        return r'$lte';
      case FilterOperator.NotEqual:
        return r'$ne';
      default:
        throw Exception("Unknown FilterOperator type.");
    }
  }
}

class FilterRelation<T> implements JsonSerializable {
  final FilterOperator filterOperator;
  final T value;
  FilterRelation({@required this.filterOperator, @required this.value});

  @override
  Map<String, dynamic> toJson() {
    return {'operator': this.filterOperator.string, 'value': this.value};
  }
}

class FilterRelations<T> implements JsonSerializable {
  final List<FilterRelation> relations;
  FilterRelations({@required this.relations});

  FilterRelations.single({@required FilterRelation relation})
      : relations = [relation];

  @override
  Map<String, dynamic> toJson() {
    if (relations.isEmpty) return null;
    return {'relations': relations.map((r) => r.toJson()).toList()};
  }
}

class FilterOptions implements JsonSerializable {
  final FilterRelations<String> name;
  final FilterRelations<String> address;
  final FilterRelations<String> ownerId;
  final FilterRelations<double> averageRating;

  FilterOptions({this.name, this.address, this.ownerId, this.averageRating});

  @override
  Map<String, dynamic> toJson() {
    return onlyDefinedKeys({
      'name': this.name?.toJson(),
      'address': this.name?.toJson(),
      'ownerId': this.ownerId?.toJson(),
      'averageRating': this.averageRating?.toJson()
    });
  }
}

enum SortCriteria { Ascending, Descending }

extension SortCriteriaExtension on SortCriteria {
  String get string => enumToString(this);
}

class SortOptions implements JsonSerializable {
  final SortCriteria name;
  final SortCriteria address;
  final SortCriteria averageRating;

  const SortOptions({this.name, this.address, this.averageRating});

  @override
  Map<String, dynamic> toJson() {
    return onlyDefinedKeys({
      if (name != null) "name": name.string,
      if (address != null) "address": address.string,
      if (averageRating != null) "averageRating": averageRating.string
    });
  }
}

class GetRestaurantsDto implements JsonSerializable {
  final FilterOptions filterOptions;
  final SortOptions sortOptions;
  final PaginationOptions paginationOptions;

  const GetRestaurantsDto(
      {this.filterOptions,
      this.sortOptions =
          const SortOptions(averageRating: SortCriteria.Descending),
      this.paginationOptions});

  @override
  Map<String, dynamic> toJson() {
    return onlyDefinedKeys({
      "filterOptions": filterOptions?.toJson(),
      "sortOptions": sortOptions?.toJson(),
      "paginationOptions": paginationOptions?.toJson()
    });
  }
}

class UpdateRestaurantDto implements JsonSerializable {
  final String id;
  final String name;
  final String address;
  UpdateRestaurantDto({this.id, this.name, this.address});

  @override
  Map<String, dynamic> toJson() {
    return onlyDefinedKeys(
        {'id': this.id, 'name': this.name, 'address': this.address});
  }
}

class DeleteRestaurantDto implements JsonSerializable {
  final String id;
  DeleteRestaurantDto({@required this.id});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

class GetRestaurantDto implements JsonSerializable {
  final String id;
  GetRestaurantDto({@required this.id});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
