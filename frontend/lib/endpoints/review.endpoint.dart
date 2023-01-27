import 'package:flutter/foundation.dart';
import 'package:foodz/api/api.client.dart';
import 'package:foodz/constants.dart';
import 'package:foodz/endpoints/base/base.endpoint.dart';
import 'package:foodz/endpoints/base/json.serializable.dart';
import 'package:foodz/models/dtos/review.dto.dart';

class ReviewEndpoint implements Endpoint {
  final RequestConfig _config;
  static const String _baseUrl = '$SERVER_URL/reviews';

  ReviewEndpoint.add({@required AddReviewDto addReviewDto})
      : _config = RequestConfig(Uri.parse('$_baseUrl/add'), RequestMethod.POST,
            body: bodyFromJsonSerializable(addReviewDto));

  ReviewEndpoint.delete({@required DeleteReviewDto deleteReviewDto})
      : _config = RequestConfig(
            Uri.parse('$_baseUrl/delete/${deleteReviewDto.reviewId}'),
            RequestMethod.DELETE);

  ReviewEndpoint.getAll({@required GetReviewsDto getReviewsDto})
      : _config = RequestConfig(Uri.parse('$_baseUrl/get'), RequestMethod.POST,
            body: bodyFromJsonSerializable(getReviewsDto));

  ReviewEndpoint.reply({@required ReviewReplyDto reviewReplyDto})
      : _config = RequestConfig(
            Uri.parse('$_baseUrl/reply'), RequestMethod.POST,
            body: bodyFromJsonSerializable(reviewReplyDto));

  ReviewEndpoint.highlights(
      {@required GetReviewHighlightsDto reviewHighlightsDto})
      : _config = RequestConfig(
            Uri.parse('$_baseUrl/highlights'), RequestMethod.POST,
            body: bodyFromJsonSerializable(reviewHighlightsDto));

  ReviewEndpoint.pending({@required GetPendingReviewsDto getPendingReviewsDto})
      : _config = RequestConfig(
            Uri.parse('$_baseUrl/pending'), RequestMethod.POST,
            body: bodyFromJsonSerializable(getPendingReviewsDto));

  ReviewEndpoint.update({@required UpdateReviewDto updateReviewDto})
      : _config = RequestConfig(
            Uri.parse('$_baseUrl/update'), RequestMethod.PUT,
            body: bodyFromJsonSerializable(updateReviewDto));

  @override
  RequestConfig get config => _config;
}
