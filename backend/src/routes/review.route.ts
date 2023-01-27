import AppRoute from '@interfaces/route.interface';
import { Router } from 'express';
import validationMiddleware from '@middlewares/validation.middleware';
import authMiddleware from '@middlewares/auth.middleware';
import {
  AddReviewDto,
  DeleteReviewDto,
  GetPendingReviewsDto,
  GetReviewHighlightsDto,
  GetReviewsDto,
  ReviewReplyDto,
  UpdateReviewDto,
} from '@dtos/review.dto';
import ReviewController from '@controllers/review.controller';
import roleMiddleware from '@middlewares/role.middleware';
import { UserRole } from '@interfaces/user.interface';

export default class ReviewRoute implements AppRoute {
  public path = '/reviews';
  public router = Router();

  private reviewController = new ReviewController();

  constructor() {
    this.router.post(
      '/add',
      validationMiddleware(AddReviewDto, 'body'),
      authMiddleware,
      roleMiddleware([UserRole.Regular, UserRole.Admin]),
      this.reviewController.add,
    );
    this.router.post('/get', validationMiddleware(GetReviewsDto, 'body'), authMiddleware, this.reviewController.getAll);
    this.router.delete(
      '/delete/:reviewId',
      validationMiddleware(DeleteReviewDto, 'params'),
      authMiddleware,
      roleMiddleware([UserRole.Admin]),
      this.reviewController.delete,
    );
    this.router.post(
      '/reply',
      validationMiddleware(ReviewReplyDto, 'body'),
      authMiddleware,
      roleMiddleware([UserRole.Owner, UserRole.Admin]),
      this.reviewController.reply,
    );
    this.router.post('/highlights', validationMiddleware(GetReviewHighlightsDto, 'body'), authMiddleware, this.reviewController.highlights);
    this.router.post(
      '/pending',
      validationMiddleware(GetPendingReviewsDto, 'body'),
      authMiddleware,
      roleMiddleware([UserRole.Owner, UserRole.Admin]),
      this.reviewController.pending,
    );
    this.router.put(
      '/update',
      validationMiddleware(UpdateReviewDto, 'body'),
      authMiddleware,
      roleMiddleware([UserRole.Admin]),
      this.reviewController.update,
    );
  }
}
