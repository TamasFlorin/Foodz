import { RequestWithUser } from '@interfaces/user.interface';
import { NextFunction, Request, Response } from 'express';
import {
  AddReviewDto,
  DeleteReviewDto,
  GetPendingReviewsDto,
  GetReviewHighlightsDto,
  GetReviewsDto,
  ReviewReplyDto,
  UpdateReviewDto,
} from '@dtos/review.dto';
import ReviewService from '@services/review.service';
import { Review, Reviews } from '@interfaces/review.interface';
import { PaginationOptions } from '@dtos/pagination.options.dto';

export default class ReviewController {
  private reviewService = new ReviewService();

  public add = async (req: RequestWithUser, res: Response, next: NextFunction) => {
    try {
      const addReviewDto: AddReviewDto = req.body;
      const review: Review = await this.reviewService.add(addReviewDto, req.user);
      res.status(201).json({ data: review, message: 'Review successfully added.' });
    } catch (error) {
      next(error);
    }
  };

  public delete = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const deleteReviewDto: DeleteReviewDto = { reviewId: req.params.reviewId };
      const review: Review = await this.reviewService.delete(deleteReviewDto);
      res.status(201).json({ data: review, message: 'Review successfully deleted.' });
    } catch (error) {
      next(error);
    }
  };

  public getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const getReviewsDto: GetReviewsDto = { paginationOptions: new PaginationOptions(), ...req.body };
      const reviews: Reviews = await this.reviewService.getAll(getReviewsDto);
      res.status(200).json({ data: reviews, message: 'Reviews sucessfully retrieved' });
    } catch (error) {
      next(error);
    }
  };

  public reply = async (req: RequestWithUser, res: Response, next: NextFunction) => {
    try {
      const user = req.user;
      const reviewReplyDto: ReviewReplyDto = req.body;
      const review: Review = await this.reviewService.reply(reviewReplyDto, user);
      res.status(200).json({ data: review, message: 'Sucessfully replied to the review.' });
    } catch (error) {
      next(error);
    }
  };

  public highlights = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const reviewHighlightsDto: GetReviewHighlightsDto = req.body;
      const reviews: Reviews = await this.reviewService.highlights(reviewHighlightsDto);
      res.status(200).json({ data: reviews, message: 'Sucessfully retrieved the review highlights.' });
    } catch (error) {
      next(error);
    }
  };

  public pending = async (req: RequestWithUser, res: Response, next: NextFunction) => {
    try {
      const user = req.user;
      const pendingDto: GetPendingReviewsDto = { paginationOptions: new PaginationOptions(), ...req.body };
      const reviews: Reviews = await this.reviewService.pending(pendingDto, user);
      res.status(200).json({ data: reviews, message: 'Sucessfully retrieved the comments pending reply.' });
    } catch (error) {
      next(error);
    }
  };

  public update = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const updateReviewDto: UpdateReviewDto = req.body;
      const review: Review = await this.reviewService.update(updateReviewDto);
      res.status(200).json({ data: review, message: 'Sucessfully updated the review.' });
    } catch (error) {
      next(error);
    }
  };
}
