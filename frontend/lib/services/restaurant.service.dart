import 'package:flutter/foundation.dart';
import 'package:foodz/api/api.client.dart';
import 'package:foodz/endpoints/restaurant.endpoint.dart';
import 'package:foodz/models/dtos/pagination.options.dto.dart';
import 'package:foodz/models/dtos/restaurant.dto.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:foodz/services/exceptions/restaurant.service.exception.dart';
import 'package:foodz/util/value.range.dart';

class RestaurantService {
  Future<Restaurant> create(
      {@required String name, @required String address}) async {
    final createRestaurantDto =
        CreateRestaurantDto(name: name, address: address);

    final requestResult = await ApiClient().request<Restaurant>(
        RestaurantEndpoint.create(createRestaurantDto: createRestaurantDto)
            .config,
        Restaurant.fromJson);

    if (requestResult.isError) {
      throw RestaurantServiceException(requestResult);
    }

    return requestResult.data;
  }

  Future<List<Restaurant>> getAll(
      {String ownerId,
      ValueRange<double> ratingRange,
      int pageNumber,
      int itemsPerPage}) async {
    final getRestaurantsDto = GetRestaurantsDto(
        sortOptions: SortOptions(averageRating: SortCriteria.Descending),
        filterOptions: FilterOptions(
            ownerId: ownerId == null
                ? null
                : FilterRelations.single(
                    relation: FilterRelation(
                        filterOperator: FilterOperator.Equal, value: ownerId)),
            averageRating: ratingRange == null
                ? null
                : FilterRelations(relations: [
                    if (ratingRange != null && ratingRange.min != null)
                      FilterRelation(
                          filterOperator: FilterOperator.GeaterThanOrEqual,
                          value: ratingRange.min),
                    if (ratingRange != null && ratingRange.max != null)
                      FilterRelation(
                          filterOperator: FilterOperator.LessThanOrEqual,
                          value: ratingRange.max)
                  ])),
        paginationOptions: PaginationOptions(
            pageNumber: pageNumber, itemsPerPage: itemsPerPage));
    final requestResult = await ApiClient().request<Restaurants>(
        RestaurantEndpoint.getAll(getRestaurantsDto: getRestaurantsDto).config,
        Restaurants.fromJson);

    if (requestResult.isError) {
      throw RestaurantServiceException(requestResult);
    }

    return requestResult.data.restaurants;
  }

  Future<Restaurant> getInfo({@required String id}) async {
    final getRestaurantDto = GetRestaurantDto(id: id);
    final requestResult = await ApiClient().request<Restaurant>(
        RestaurantEndpoint.getInfo(getRestaurantDto: getRestaurantDto).config,
        Restaurant.fromJson);

    if (requestResult.isError) {
      throw RestaurantServiceException(requestResult);
    }

    return requestResult.data;
  }

  Future<Restaurant> update(
      {String restaurantId, String name, String address}) async {
    final updateRestaurantDto =
        UpdateRestaurantDto(id: restaurantId, name: name, address: address);
    final requestResult = await ApiClient().request<Restaurant>(
        RestaurantEndpoint.update(updateRestaurantDto: updateRestaurantDto)
            .config,
        Restaurant.fromJson);

    if (requestResult.isError) {
      throw RestaurantServiceException(requestResult);
    }

    return requestResult.data;
  }

  Future<Restaurant> delete({@required String restaurantId}) async {
    final deleteRestaurantDto = DeleteRestaurantDto(id: restaurantId);
    final requestResult = await ApiClient().request<Restaurant>(
        RestaurantEndpoint.delete(deleteRestaurantDto: deleteRestaurantDto)
            .config,
        Restaurant.fromJson);

    if (requestResult.isError) {
      throw RestaurantServiceException(requestResult);
    }

    return requestResult.data;
  }
}
