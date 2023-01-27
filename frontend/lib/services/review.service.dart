import 'package:flutter/foundation.dart';
import 'package:foodz/api/api.client.dart';
import 'package:foodz/endpoints/review.endpoint.dart';
import 'package:foodz/models/dtos/pagination.options.dto.dart';
import 'package:foodz/models/dtos/review.dto.dart';
import 'package:foodz/models/review.model.dart';
import 'package:foodz/services/exceptions/review.service.exception.dart';

class ReviewService {
  Future<Review> add(
      {@required String restaurantId,
      @required String content,
      @required double rating,
      @required DateTime dateOfVisit}) async {
    final addReviewDto = AddReviewDto(
        restaurantId: restaurantId,
        content: content,
        rating: rating,
        dateOfVisit: dateOfVisit);

    final requestResult = await ApiClient().request<Review>(
        ReviewEndpoint.add(addReviewDto: addReviewDto).config, Review.fromJson);

    if (requestResult.isError) {
      throw ReviewServiceException(requestResult);
    }

    return requestResult.data;
  }

  Future<Review> delete({@required String reviewId}) async {
    final deleteReviewDto = DeleteReviewDto(reviewId: reviewId);
    final requestResult = await ApiClient().request<Review>(
        ReviewEndpoint.delete(deleteReviewDto: deleteReviewDto).config,
        Review.fromJson);
    if (requestResult.isError) {
      throw ReviewServiceException(requestResult);
    }

    return requestResult.data;
  }

  Future<List<Review>> getAll(
      {@required String restaurantId,
      @required int pageNumber,
      @required int itemsPerPage}) async {
    final getReviewsDto = GetReviewsDto(
        restaurantId: restaurantId,
        paginationOptions: PaginationOptions(
            pageNumber: pageNumber, itemsPerPage: itemsPerPage));
    final requestResult = await ApiClient().request<Reviews>(
        ReviewEndpoint.getAll(getReviewsDto: getReviewsDto).config,
        Reviews.fromJson);
    if (requestResult.isError) {
      throw ReviewServiceException(requestResult);
    }

    return requestResult.data.reviews;
  }

  Future<Review> reply(
      {@required String reviewId, @required String reply}) async {
    final reviewReplyDto = ReviewReplyDto(reviewId: reviewId, reply: reply);
    final requestResult = await ApiClient().request<Review>(
        ReviewEndpoint.reply(reviewReplyDto: reviewReplyDto).config,
        Review.fromJson);
    if (requestResult.isError) {
      throw ReviewServiceException(requestResult);
    }

    return requestResult.data;
  }

  Future<List<Review>> getHighlights({@required String restaurantId}) async {
    final getReviewHighlightsDto =
        GetReviewHighlightsDto(restaurantId: restaurantId);

    final requestResult = await ApiClient().request<Reviews>(
        ReviewEndpoint.highlights(reviewHighlightsDto: getReviewHighlightsDto)
            .config,
        Reviews.fromJson);
    if (requestResult.isError) {
      throw ReviewServiceException(requestResult);
    }

    return requestResult.data.reviews;
  }

  Future<ReviewsWithHighlights> getAllWithHighlights(
      {@required String restaurantId,
      @required int pageNumber,
      @required int itemsPerPage}) async {
    final higlights = await getHighlights(restaurantId: restaurantId);
    final all = await getAll(
        restaurantId: restaurantId,
        pageNumber: pageNumber,
        itemsPerPage: itemsPerPage - higlights.length);
    final filteredHighlights = higlights.length == 2
        ? (higlights[0].id == higlights[1].id ? [higlights[0]] : higlights)
        : higlights;
    return ReviewsWithHighlights(highlights: filteredHighlights, reviews: all);
  }

  Future<List<Review>> getPending(
      {@required String restaurantId,
      @required int pageNumber,
      @required int itemsPerPage}) async {
    final getPendingReviewsDto = GetPendingReviewsDto(
        restaurantId: restaurantId,
        paginationOptions: PaginationOptions(
            pageNumber: pageNumber, itemsPerPage: itemsPerPage));

    final requestResult = await ApiClient().request<Reviews>(
        ReviewEndpoint.pending(getPendingReviewsDto: getPendingReviewsDto)
            .config,
        Reviews.fromJson);
    if (requestResult.isError) {
      throw ReviewServiceException(requestResult);
    }

    return requestResult.data.reviews;
  }

  Future<Review> update(
      {@required String reviewId,
      @required String content,
      @required String reply,
      @required double rating,
      @required DateTime dateOfVisit}) async {
    final updateReviewDto = UpdateReviewDto(
        id: reviewId,
        content: content,
        reply: reply,
        rating: rating,
        dateOfVisit: dateOfVisit);
    final requestResult = await ApiClient().request<Review>(
        ReviewEndpoint.update(updateReviewDto: updateReviewDto).config,
        Review.fromJson);
    if (requestResult.isError) {
      throw ReviewServiceException(requestResult);
    }
    return requestResult.data;
  }
}
