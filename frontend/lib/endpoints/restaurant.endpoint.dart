import 'package:flutter/foundation.dart';
import 'package:foodz/api/api.client.dart';
import 'package:foodz/constants.dart';
import 'package:foodz/endpoints/base/base.endpoint.dart';
import 'package:foodz/endpoints/base/json.serializable.dart';
import 'package:foodz/models/dtos/restaurant.dto.dart';

class RestaurantEndpoint implements Endpoint {
  final RequestConfig _config;
  static const String _baseUrl = '$SERVER_URL/restaurants';

  RestaurantEndpoint.create({@required CreateRestaurantDto createRestaurantDto})
      : _config = RequestConfig(
            Uri.parse('$_baseUrl/create'), RequestMethod.POST,
            body: bodyFromJsonSerializable(createRestaurantDto));

  RestaurantEndpoint.getAll({@required GetRestaurantsDto getRestaurantsDto})
      : _config = RequestConfig(Uri.parse('$_baseUrl/get'), RequestMethod.POST,
            body: bodyFromJsonSerializable(getRestaurantsDto));

  RestaurantEndpoint.getInfo({@required GetRestaurantDto getRestaurantDto})
      : _config = RequestConfig(
            Uri.parse('$_baseUrl/get/${getRestaurantDto.id}'),
            RequestMethod.GET);

  RestaurantEndpoint.update({@required UpdateRestaurantDto updateRestaurantDto})
      : _config = RequestConfig(
            Uri.parse('$_baseUrl/update'), RequestMethod.PUT,
            body: bodyFromJsonSerializable(updateRestaurantDto));

  RestaurantEndpoint.delete({@required DeleteRestaurantDto deleteRestaurantDto})
      : _config = RequestConfig(
            Uri.parse('$_baseUrl/delete/${deleteRestaurantDto.id}'),
            RequestMethod.DELETE);

  @override
  RequestConfig get config => _config;
}
