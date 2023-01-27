import { IsDateString, IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';
import { PaginationOptions } from './pagination.options.dto';

export class AddReviewDto {
  @IsString()
  restaurantId: string;

  @IsString()
  content: string;

  @IsNumber()
  rating: number;

  @IsDateString()
  dateOfVisit: Date;
}

export class DeleteReviewDto {
  @IsString()
  reviewId: string;
}

export class GetReviewsDto {
  @IsString()
  restaurantId: string;

  @IsOptional()
  paginationOptions: PaginationOptions;
}

export class UpdateReviewDto {
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  id: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  content: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  reply: string;

  @IsOptional()
  @IsNumber()
  rating: number;

  @IsDateString()
  dateOfVisit: Date;
}

export class ReviewReplyDto {
  @IsString()
  reviewId: string;

  @IsString()
  reply: string;
}

export class GetReviewHighlightsDto {
  @IsString()
  restaurantId: string;
}

export class GetPendingReviewsDto {
  @IsString()
  restaurantId: string;

  @IsOptional()
  paginationOptions: PaginationOptions;
}
