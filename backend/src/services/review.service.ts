import {
  AddReviewDto,
  DeleteReviewDto,
  GetPendingReviewsDto,
  GetReviewHighlightsDto,
  GetReviewsDto,
  ReviewReplyDto,
  UpdateReviewDto,
} from '@dtos/review.dto';
import { HttpException } from '@exceptions/http.exception';
import { Restaurant } from '@interfaces/restaurant.interface';
import { Review, Reviews } from '@interfaces/review.interface';
import { Status } from '@interfaces/status.interface';
import { User, UserRole } from '@interfaces/user.interface';
import restaurantModel from '@models/restaurant.model';
import reviewModel from '@models/review.model';
import { idsEqual } from '@utils/utils';

export default class ReviewService {
  private reviews = reviewModel;
  private restaurants = restaurantModel;

  public async add(reviewInfo: AddReviewDto, user: User): Promise<Review> {
    const restaurant: Restaurant = await this.restaurants.findOne({ _id: reviewInfo.restaurantId, status: Status.Active });
    if (!restaurant) {
      throw new HttpException(404, 'Could not find a restaurant with the given id.');
    }
    const review: Review = await this.reviews.create({ ...reviewInfo, userId: user._id });
    await this.updateRestaurantRating(restaurant, reviewInfo.rating);
    return review;
  }

  public async delete(reviewInfo: DeleteReviewDto): Promise<Review> {
    const review: Review = await this.reviews.findOne({ _id: reviewInfo.reviewId, status: Status.Active });
    if (!review) {
      throw new HttpException(404, 'Could not find a review with the given id.');
    }

    const restaurant: Restaurant = await this.restaurants.findOne({ _id: review.restaurantId, status: Status.Active });
    if (!restaurant) {
      throw new HttpException(404, 'Could not find a restaurant with the given id.');
    }

    const updatedReview: Review = await this.reviews.findOneAndUpdate({ _id: review._id }, { status: Status.Disabled }, { new: true });
    await this.updateRestaurantRating(restaurant, -review.rating);
    return updatedReview;
  }

  public async getAll(reviewInfo: GetReviewsDto): Promise<Reviews> {
    const reviews: Review[] = await this.reviews
      .where({ restaurantId: reviewInfo.restaurantId, status: Status.Active })
      .sort({ created: -1 })
      .skip(reviewInfo.paginationOptions.itemsPerPage * reviewInfo.paginationOptions.pageNumber)
      .limit(reviewInfo.paginationOptions.itemsPerPage);
    return { reviews: reviews };
  }

  public async reply(replyInfo: ReviewReplyDto, user: User): Promise<Review> {
    const review = await this.reviews.findOne({ _id: replyInfo.reviewId, status: Status.Active });
    if (!review) {
      throw new HttpException(404, 'Could not find a review with the given id.');
    }

    const restaurant: Restaurant = await this.restaurants.findOne({ _id: review.restaurantId, status: Status.Active });
    if (!restaurant) {
      throw new HttpException(404, 'The restaurant associated to this review no longer exists.');
    }

    if (!idsEqual(restaurant.ownerId, user._id) && user.role != UserRole.Admin) {
      throw new HttpException(401, 'Only owners can reply to comments about their restaurants.');
    }

    await this.reviews.updateOne({ _id: review._id }, { reply: replyInfo.reply });
    const result: Review = { ...review.toObject(), reply: replyInfo.reply };
    return result;
  }

  public async highlights(highlightInfo: GetReviewHighlightsDto): Promise<Reviews> {
    const highestReview = await this.reviews.where({ restaurantId: highlightInfo.restaurantId, status: Status.Active }).sort({ rating: -1 }).limit(1);
    const lowestReview = await this.reviews.where({ restaurantId: highlightInfo.restaurantId, status: Status.Active }).sort({ rating: 1 }).limit(1);
    const result = Array<Review>();
    if (highestReview.length > 0) {
      result.push(highestReview[0]);
    }
    if (lowestReview.length > 0) {
      result.push(lowestReview[0]);
    }
    return { reviews: result };
  }

  public async pending(pendingInfo: GetPendingReviewsDto, user: User): Promise<Reviews> {
    const restaurant = await this.restaurants.findOne({ _id: pendingInfo.restaurantId, status: Status.Active });
    if (!restaurant) {
      throw new HttpException(404, 'Could not find a restaurant with the given id.');
    }

    if (!idsEqual(restaurant.ownerId, user._id) && user.role != UserRole.Admin) {
      throw new HttpException(401, 'Only the owner of the restaurant can review the pending comments.');
    }

    const pendingReviews = await this.reviews
      .where({ restaurantId: pendingInfo.restaurantId, reply: null, status: Status.Active })
      .sort({ created: -1 })
      .skip(pendingInfo.paginationOptions.itemsPerPage * pendingInfo.paginationOptions.pageNumber)
      .limit(pendingInfo.paginationOptions.itemsPerPage);
    return { reviews: pendingReviews };
  }

  public async update(dto: UpdateReviewDto): Promise<Review> {
    const oldReview: Review = await this.reviews.findOne({ _id: dto.id, status: Status.Active });
    if (!oldReview) {
      throw new HttpException(404, 'Could not find a review with the given id.');
    }

    const restaurant: Restaurant = await this.restaurants.findOne({ _id: oldReview.restaurantId, status: Status.Active });
    if (!restaurant) {
      throw new HttpException(404, 'Could not find a restaurant with the given id.');
    }

    // remove the old review
    const updatedRestaurant = await this.updateRestaurantRating(restaurant, -oldReview.rating);

    // update the review and recompute the restaurant rating
    const { id, ...updateData } = { ...dto };
    const updatedReview: Review = await this.reviews.findOneAndUpdate({ _id: id }, updateData, { new: true });
    await this.updateRestaurantRating(updatedRestaurant, dto.rating);

    return updatedReview;
  }

  private async updateRestaurantRating(restaurant: Restaurant, rating: number): Promise<Restaurant> {
    const newNumReviews = restaurant.numReviews + (rating < 0 ? -1 : 1); // if rating is negative, we are removing a review
    const newReviewSum = restaurant.reviewSum + rating;
    const newAverageRating = newNumReviews == 0 ? 0 : newReviewSum / newNumReviews;
    const updatedRestaurant = await this.restaurants.findOneAndUpdate(
      { _id: restaurant._id },
      { averageRating: newAverageRating, numReviews: newNumReviews, reviewSum: newReviewSum },
      { new: true },
    );

    return updatedRestaurant;
  }
}
