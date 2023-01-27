import 'package:flutter/material.dart';
import 'package:foodz/endpoints/base/json.serializable.dart';
import 'package:foodz/models/dtos/pagination.options.dto.dart';
import 'package:foodz/util/util.dart';

class AddReviewDto implements JsonSerializable {
  final String restaurantId;
  final String content;
  final double rating;
  final DateTime dateOfVisit;

  AddReviewDto(
      {@required this.restaurantId,
      @required this.content,
      @required this.rating,
      @required this.dateOfVisit});

  @override
  Map<String, dynamic> toJson() {
    return {
      "restaurantId": restaurantId,
      "content": content,
      "rating": this.rating,
      "dateOfVisit": dateOfVisit.toIso8601String()
    };
  }
}

class DeleteReviewDto implements JsonSerializable {
  final String reviewId;

  DeleteReviewDto({@required this.reviewId});

  @override
  Map<String, dynamic> toJson() {
    return {"reviewId": this.reviewId};
  }
}

class GetReviewsDto implements JsonSerializable {
  final String restaurantId;
  final PaginationOptions paginationOptions;
  GetReviewsDto({@required this.restaurantId, this.paginationOptions});

  @override
  Map<String, dynamic> toJson() {
    return onlyDefinedKeys({
      "restaurantId": this.restaurantId,
      'paginationOptions': paginationOptions?.toJson()
    });
  }
}

class ReviewReplyDto implements JsonSerializable {
  final String reviewId;
  final String reply;
  ReviewReplyDto({@required this.reviewId, @required this.reply});

  @override
  Map<String, dynamic> toJson() {
    return {"reviewId": reviewId, "reply": reply};
  }
}

class GetReviewHighlightsDto implements JsonSerializable {
  final String restaurantId;
  GetReviewHighlightsDto({@required this.restaurantId});
  @override
  Map<String, dynamic> toJson() {
    return {"restaurantId": restaurantId};
  }
}

class GetPendingReviewsDto implements JsonSerializable {
  final String restaurantId;
  final PaginationOptions paginationOptions;
  GetPendingReviewsDto({@required this.restaurantId, this.paginationOptions});

  @override
  Map<String, dynamic> toJson() {
    return onlyDefinedKeys({
      "restaurantId": restaurantId,
      "paginationOptions": paginationOptions?.toJson()
    });
  }
}

class UpdateReviewDto implements JsonSerializable {
  final String id;
  final String content;
  final double rating;
  final DateTime dateOfVisit;
  final String reply;

  UpdateReviewDto(
      {@required this.id,
      @required this.content,
      @required this.reply,
      @required this.rating,
      @required this.dateOfVisit});

  @override
  Map<String, dynamic> toJson() {
    return onlyDefinedKeys({
      "id": id,
      "content": content,
      "reply": reply,
      "rating": rating,
      "dateOfVisit": dateOfVisit.toIso8601String()
    });
  }
}
